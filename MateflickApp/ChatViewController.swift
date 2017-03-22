/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import Photos
import Firebase
import JSQMessagesViewController
struct imageRef {
    static var IM = String()
}
final class ChatViewController: JSQMessagesViewController {
    
    // MARK: Properties
    private let imageURLNotSetKey = "mPhotoUrl"
    var channelRef: FIRDatabaseReference?
    var childRef: FIRDatabaseReference?
    
    private lazy var messageRef: FIRDatabaseReference = self.channelRef!
    //fileprivate lazy var storageRef: FIRStorageReference = FIRStorage.storage().reference
    //  private lazy var userIsTypingRef: FIRDatabaseReference = self.channelRef!.child("typingIndicator").child(self.senderId)
    //  private lazy var usersTypingQuery: FIRDatabaseQuery = self.channelRef!.child("typingIndicator").queryOrderedByValue().queryEqual(toValue: true)
    
    private var newMessageRefHandle: FIRDatabaseHandle?
    private var updatedMessageRefHandle: FIRDatabaseHandle?
    
    private var messages: [JSQMessage] = []
    private var photoMessageMap = [String: JSQPhotoMediaItem]()
    
    private var localTyping = false
    var channel: Channel? {
        didSet {
            self.chatUserNameLabel.text = channel?.name
            self.chatUserNameLabel.textColor = UIColor .white
        }
    }
    //    var isTyping: Bool {
    //    get {
    //      return localTyping
    //    }
    //    set {
    //      localTyping = newValue
    //      userIsTypingRef.setValue(newValue)
    //    }
    //  }
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    // MARK: View Lifecycle
    var app = AppDelegate()
    var img = [Any]()
    var im = String()
    var dateString = String()
    @IBOutlet weak var navBarView: UIView!
    
    @IBOutlet weak var chatImageBtn: UIButton!
    
    @IBOutlet weak var chatUserNameLabel: UILabel!
    
    @IBOutlet weak var callBtn: UIButton!
    
    @IBOutlet weak var videoCallBtn: UIBarButtonItem!
    var sendMessageWithImageUrl = String()
    var dateTimeArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.backgroundColor = UIColor.red
        
        //JSQMessagesBubbleImage.addSubview(label)
        
        
        //self.collectionView.backgroundColor = UIColor.gray
        if Image.hide == "0" {
            self.callBtn.isHidden = true
            self.videoCallBtn.isEnabled = false
            self.videoCallBtn.tintColor = UIColor.clear
        }else{
            self.callBtn.isHidden = false
            self.videoCallBtn.isEnabled = true
            //self.videoCallBtn.tintColor = UIColor.clear
        }
        self.navBarView.backgroundColor = UIColor.clear
        self.chatUserNameLabel.backgroundColor = UIColor.clear
        self.senderId = String( describing: UserDefaults.standard.integer(forKey: "id"))
        //FIRAuth.auth()?.currentUser?.uid
        
        observeMessages()
        
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //FIRDatabase.database().persistenceEnabled = true
        
        
        //observeTyping()
        
        chatImageBtn.layer.masksToBounds = false
        chatImageBtn.layer.cornerRadius = chatImageBtn.frame.height/2
        chatImageBtn.clipsToBounds = true
        if  let url = NSURL(string: Image.img) {
            if let data = NSData(contentsOf: url as URL){
                chatImageBtn .setBackgroundImage(UIImage(data: data as Data), for: .normal)
            }
        }
        
    }
    
    deinit {
        if let refHandle = newMessageRefHandle {
            messageRef.removeObserver(withHandle: refHandle)
        }
        if let refHandle = updatedMessageRefHandle {
            messageRef.removeObserver(withHandle: refHandle)
        }
    }
    
    // MARK: Collection view data source (and related) methods
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    //    func firstMessageOfTheDay(indexOfMessage: NSIndexPath) -> Bool {
    //        let messageDate = messages[indexOfMessage.item].date
    //        guard let previouseMessageDate = messages[indexOfMessage.item - 1].date else {
    //            return true // because there is no previous message so we need to show the date
    //        }
    //        let calendar = NSCalendar.current
    //        let day = calendar.component(.day, from: messageDate!)
    //
    //        let previouseMessageDay = calendar.component(.day, from: previouseMessageDate)
    //            if (day == previouseMessageDay) {
    //                return false
    //            } else {
    //            return true
    //        }
    //    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        // cell.textView.isSelectable = true
        
        
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.black
            
            
        } else {
            cell.textView?.textColor = UIColor.black
        }
        //collectionView.allowsMultipleSelection = true
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 10
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString {
        let message: JSQMessage? = self.messages[indexPath.item]
        if indexPath.item == 0 {
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message?.date)!
        }
        if indexPath.item  > -1 {
            let previousMessage: JSQMessage? = self.messages[indexPath.item]
            let checkTime: Bool? = message?.date != previousMessage?.date
            if checkTime != nil {
                return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message?.date)!
            }
        }
        return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message?.date)!
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        if indexPath.item > 0 {
            let previousMessage: JSQMessage? = self.messages[indexPath.item]
            let message: JSQMessage? = self.messages[indexPath.item]
            if (message?.date?.timeIntervalSince((previousMessage?.date)!))! / 60 > 1 {
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
        }
        return 0.0
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //collectionView.allowsMultipleSelection = true
    }
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(collectionView: JSQMessagesCollectionView!, didDeleteMessageAtIndexPath indexPath: NSIndexPath!) {
        
        self.messages.remove(at: indexPath.row)
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView?, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString? {
        
        if Image.hide == "0" {
            let message = messages[indexPath.item]
            switch message.senderId {
            case senderId:
                return nil
            default:
                guard let senderDisplayName = message.senderDisplayName else {
                    assertionFailure()
                    return nil
                }
                return NSAttributedString(string: senderDisplayName)
            }
        }else{
            return nil
        }
        //    let message = messages[indexPath.item]
        //    if (message.senderId == self.senderId) {
        //        //if "\(dateTimeArray[indexPath.item])"[indexPath.row]
        //            //self.collectionView.reloadData
        //    //if messages.count == dateTimeArray.count {
        //            return NSAttributedString(string: self.dateString)
        //    }else{
        ////    let dayTimePeriodFormatter = DateFormatter()
        ////    dayTimePeriodFormatter.dateFormat = "MMM d, h:mm a"
        ////    dayTimePeriodFormatter.timeZone = NSTimeZone.local
        ////    let dateString = dayTimePeriodFormatter.string(from:Date())
        //        return NSAttributedString(string: self.dateString)
        //    }
        
    }
    
    // MARK: Firebase related methods
    func updateDate(){
        //self.dateTimeArray.removeAll()
        let messageQuery = messageRef.queryLimited(toLast:1000000)
        
        // We can use the observe method to listen for new
        // messages being written to the Firebase DB
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            let messageData = snapshot.value as! Dictionary<String, AnyObject>
            
            
            let fbtimestamp = messageData["fbtimestamp"] as AnyObject
            var fbtimestampStr = String()
            fbtimestampStr = "\(fbtimestamp)"
            let text = fbtimestampStr.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range:nil)
            
            if let myDouble = NumberFormatter().number(from: text)?.doubleValue {
                let date = NSDate(timeIntervalSince1970:myDouble/1000)
                let dayTimePeriodFormatter = DateFormatter()
                dayTimePeriodFormatter.dateFormat = "MMM d, h:mm a"
                dayTimePeriodFormatter.timeZone = NSTimeZone.local
                self.dateString = dayTimePeriodFormatter.string(from: date as Date)
                //self.dateTimeArray.append(dateString)
                print("dfgjfd",self.dateTimeArray)
            }
        })
    }
    private func observeMessages() {
        
        //updateDate()
        let messageQuery = messageRef.queryLimited(toLast:1000000)
        
        // We can use the observe method to listen for new
        // messages being written to the Firebase DB
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            let messageData = snapshot.value as! Dictionary<String, AnyObject>
            
            
            let fbtimestamp = messageData["fbtimestamp"] as AnyObject
            var fbtimestampStr = String()
            fbtimestampStr = "\(fbtimestamp)"
            let text = fbtimestampStr.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range:nil)
            
            if let myDouble = NumberFormatter().number(from: text)?.doubleValue {
                let date = NSDate(timeIntervalSince1970:myDouble/1000)
                let dayTimePeriodFormatter = DateFormatter()
                dayTimePeriodFormatter.dateFormat = "MMM d, h:mm a"
                dayTimePeriodFormatter.timeZone = NSTimeZone.local
                self.dateString = dayTimePeriodFormatter.string(from: date as Date)
                //self.dateTimeArray.append(dateString)
                //print("dfgjfd",self.dateTimeArray)
            }
            //        var cal2 = Calendar.current
            //
            //        var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
            //
            //        let dateFormatter2 = DateFormatter()
            //
            //        dateFormatter2.dateFormat = "MMM dd yyyy hh:mm:ss:sssa"
            //        let postedTime: Date? = dateFormatter2.date(from: text)
            //        dateFormatter2.dateFormat = "MMM dd yyyy hh:mm:ss:sssa"
            //        //dateFormatter2.timeZone = NSTimeZone.system
            //
            //        var components2 = cal2.dateComponents([.era, .year, .month, .day, .hour, .minute, .second], from: Date())
            //        let today2 = cal2.date(from: components2)
            //        components2 = cal2.dateComponents([Calendar.Component.second], from: postedTime!, to: (today2! as Date) )
            //        print("(today as Date)",(today2! as Date))
            //        var dateTimeStr = String()
            //        let sec = components2.second!
            //        let min = sec/60
            //        let hour = sec/3600
            //        print("Sec",sec)
            //
            //        if sec < 60 {
            //            dateTimeStr = "\(sec) Sec"
            //        }
            //        else if min < 60 {
            //            dateTimeStr = "\(min) Min"
            //        }
            //        else if hour < 12 {
            //            dateTimeStr = "\(hour) Hr"
            //        }
            //        else if hour < 24 {
            //            dateTimeStr = "Today"
            //        }
            //        else if hour < 48 {
            //            dateTimeStr = "Yesterday"
            //        }
            //        else {
            //            let dateFormatter = DateFormatter()
            //            dateFormatter.dateFormat = "MMM dd yyyy hh:mm:ss:sssa"
            //            let yourDate: Date? = dateFormatter.date(from: text)
            //            dateFormatter.dateFormat = "dd MMM yyyy"
            //            dateTimeStr = "\(dateFormatter.string(from: yourDate!))"
            //        }
            //         self.dateTimeArray.append(dateTimeStr)
            // print("fbtimestamp",text)
            
            
            if let id = messageData["name"] as! String!, let name = messageData["userFirstName"] as! String!, let text = messageData["text"] as! String!, text.characters.count > 0 {
                self.addMessage(withId: id,date:self.dateString, name: name, text: text )
                self.finishReceivingMessage()
            } else if let id = messageData["name"] as! String!, let photoURL = messageData["photoUrl"] as! String! {
                
                if let mediaItem = JSQPhotoMediaItem(maskAsOutgoing: id == self.senderId) {
                    self.addPhotoMessage(withId: id, key: snapshot.key, mediaItem: mediaItem)
                    
                    if photoURL.hasPrefix("https://") {
                        self.fetchImageDataAtURL(photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: nil)
                        
                    }
                    
                }
            } else {
                print("Error! Could not decode message data")
            }
            
        })
        
        // We can also use the observer method to listen for
        // changes to existing messages.
        // We use this to be notified when a photo has been stored
        // to the Firebase Storage, so we can update the message data
        updatedMessageRefHandle = messageRef.observe(.childChanged, with: { (snapshot) in
            let key = snapshot.key
            
            let messageData = snapshot.value as! Dictionary<String, AnyObject>
            if let photoURL = messageData["photoUrl"] as! String!  {
                // The photo has been updated.
                //print("photoURL",photoURL)
                if let mediaItem = self.photoMessageMap[key] {
                    
                    self.fetchImageDataAtURL(photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: key)
                }
            }
        })
    }
    
    private func fetchImageDataAtURL(_ photoURL: String, forMediaItem mediaItem: JSQPhotoMediaItem, clearsPhotoMessageMapOnSuccessForKey key: String?){
        
        if photoURL != "mPhotoUrl" {
            //print("photoURL",photoURL)
            
            if  let url = NSURL(string: photoURL) {
                if let data = NSData(contentsOf: url as URL){
                    mediaItem.image = UIImage.init(data: data as Data)
                }
            }
            self.collectionView.reloadData()
            //     let storageRef = FIRStorage.storage().reference(forURL: photoURL )
            //         storageRef.data(withMaxSize: INT64_MAX){ (data, error) in
            //      if let error = error {
            //        print("Error downloading image data: \(error)")
            //        return
            //      }
            //
            //      storageRef.metadata(completion: { (metadata, metadataErr) in
            //        if let error = metadataErr {
            //          print("Error downloading metadata: \(error)")
            //          return
            //        }
            //
            //        if (metadata?.contentType == "image/gif") {
            //          mediaItem.image = UIImage.gifWithData(data!)
            //        } else {
            //          mediaItem.image = UIImage.init(data: data!)
            //        }
            //        self.collectionView.reloadData()
            //
            //        guard key != nil else {
            //          return
            //        }
            //        self.photoMessageMap.removeValue(forKey: key!)
            //      })
            //    }
        }else{
            
        }
    }
    
    //  private func observeTyping() {
    //    let typingIndicatorRef = channelRef!.child("typingIndicator")
    //    userIsTypingRef = typingIndicatorRef.child(senderId)
    //    userIsTypingRef.onDisconnectRemoveValue()
    //    usersTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqual(toValue: true)
    //
    //    usersTypingQuery.observe(.value) { (data: FIRDataSnapshot) in
    //
    //      // You're the only typing, don't show the indicator
    //      if data.childrenCount == 1 && self.isTyping {
    //        return
    //      }
    //
    //      // Are there others typing?
    //      self.showTypingIndicator = data.childrenCount > 0
    //      self.scrollToBottom(animated: true)
    //    }
    //  }
    //
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        // 1
       
        let itemRef = messageRef.childByAutoId()
        //var userIDS = String()
        var pushID = String()
        pushID = String( describing:itemRef)
        
        let childID = pushID.replacingOccurrences(of: "https://mateflick-c34e3.firebaseio.com/"+(channel?.id)!+"/", with: "", options: .literal, range: nil)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy hh:mm:ss:sssa"
        let dateTimeStr = "\(dateFormatter.string(from: date!))"
        
        let messageItem = [
            "mftxnid":"",
            "name": String( describing: UserDefaults.standard.integer(forKey: "id")),
            "photoUrl":"mPhotoUrl",
            "pushId": childID,
            "text": text!,
            "timestamp": dateTimeStr,
            "userFirstName":senderDisplayName,
            "username":(channel?.name)!] as [String : String]
        
        // 3
        
        itemRef.setValue(messageItem)
        messageRef.child(childID).child("fbtimestamp").setValue(FIRServerValue.timestamp())
        
        for (_, element) in Image.groupIDsArray.enumerated()  {
            
            let relationMessageItem = [
                "deleteStatus":"",
                "deliveredStatus":"",
                "pushIdUserMessage":childID,
                "readStatus":"",
                "userid": "\(element)"] as [String : String]
            
            messageRef.child(childID).child("userMessageRelationshipModels_").child("\(element)").setValue(relationMessageItem)
            
        }
        
        // 4
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        // 5
        finishSendingMessage()
        //isTyping = false
    }
    
    func sendPhotoMessage() ->  String? {
        
        let itemRef = messageRef.childByAutoId()
        
        var pushID = String()
        pushID = String( describing:itemRef)
        let childID = pushID.replacingOccurrences(of: "https://mateflick-c34e3.firebaseio.com/"+(channel?.id)!+"/", with: "", options: .literal, range: nil)
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy hh:mm:ss:sssa"
        let dateTimeStr = "\(dateFormatter.string(from: date as Date))"
        
        
        let messageItem = [
            "mftxnid":"" ,
            "name": senderId!,
            "photoUrl":imageURLNotSetKey,
            "pushId": childID,
            "text": "",
            "timestamp": dateTimeStr,
            "userFirstName":senderDisplayName,
            "username":(channel?.name)! ] as [String : String]
        
        // 3
        
        itemRef.setValue(messageItem)
        messageRef.child(childID).child("fbtimestamp").setValue(FIRServerValue.timestamp())
        for (_, element) in Image.groupIDsArray.enumerated()  {
            
            let relationMessageItem = [
                "deleteStatus":"" ,
                "deliveredStatus":"" ,
                "pushIdUserMessage":childID ,
                "readStatus":"" ,
                "userid": "\(element)" ] as [String : String]
            self.messageRef.child(childID).child("userMessageRelationshipModels_").child("\(element)").setValue(relationMessageItem)
            
        }
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
        
        return itemRef.key
        
    }
    
    func setImageURL(_ url: String, forPhotoMessageWithKey key: String) {
        let itemRef = messageRef.child(key)
        itemRef.updateChildValues(["photoUrl": url])
    }
    
    // MARK: UI and User Interaction
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())}
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            picker.sourceType = UIImagePickerControllerSourceType.camera
        } else {
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        present(picker, animated: true, completion:nil)
    }
    
    private func addMessage(withId id: String,date: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    private func addPhotoMessage(withId id: String, key: String, mediaItem: JSQPhotoMediaItem) {
        if let message = JSQMessage(senderId: id, displayName: "", media: mediaItem) {
            messages.append(message)
            
            if (mediaItem.image == nil) {
                photoMessageMap[key] = mediaItem
            }
            
            collectionView.reloadData()
        }
    }
    
    // MARK: UITextViewDelegate methods
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        //isTyping = textView.text != ""
    }
    
}

// MARK: Image Picker Delegate
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion:nil)
        
        // 1
        //    if let photoReferenceUrl = info[UIImagePickerControllerReferenceURL] as? URL {
        //      // Handle picking a Photo from the Photo Library
        //      // 2
        //      let assets = PHAsset.fetchAssets(withALAssetURLs: [photoReferenceUrl], options: nil)
        //      let asset = assets.firstObject
        //
        //      // 3
        //if let key = sendPhotoMessage() {
        //        // 4
        //
        //
        //        asset?.requestContentEditingInput(with: nil, completionHandler: { (contentEditingInput, info)  in
        //          let imageFileURL = contentEditingInput?.fullSizeImageURL
        //
        //          // 5
        //            let date = NSDate()
        //            let dateFormatter = DateFormatter()
        //            dateFormatter.dateFormat = "MMM dd yyyy HH:mm:ss:SSSa"
        //            let dateTimeStr = "\(dateFormatter.string(from: date as Date))"
        //
        //          //let path = "\(FIRAuth.auth()?.currentUser?.uid)/\(Int(Date.timeIntervalSinceReferenceDate * 1000))/\(photoReferenceUrl.lastPathComponent)"
        //           let path = "images/"+"imgkey"+key+"imgkey"+String( describing: UserDefaults.standard.integer(forKey: "id"))+"picbyk"+dateTimeStr+".jpg"
        //
        //          // 6
        //          FIRStorage.storage().reference().child(path).putFile(imageFileURL!, metadata: nil) { (metadata, error) in
        //            if let error = error {
        //              print("Error uploading photo: \(error.localizedDescription)")
        //              return
        //            }
        // 7            self.setImageURL(FIRStorage.storage().reference().child((metadata?.path)!).description, forPhotoMessageWithKey: key)
        //          }
        //        })
        //      }
        //    } else {
        //      // Handle picking a Photo from the Camera - TODO
        //    }
        
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorageUsingImage(selectedImage)
        }
        
    }
    fileprivate func uploadToFirebaseStorageUsingImage(_ image: UIImage) {
        if let key = sendPhotoMessage() {
            //let imageName = UUID().uuidString
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd yyyy hh:mm:ss:sssa"
            let dateTimeStr = "\(dateFormatter.string(from: date as Date))"
            let imageName = "images/"+"imgkey"+key+"toacc"+Image.selectedID+"imgkey"+"picbyk"+dateTimeStr+".jpg"
            let ref = FIRStorage.storage().reference().child(imageName)
            
            if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
                ref.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    
                    if error != nil {
                        print("Failed to upload image:", error)
                        return
                    }
                    
                    if let imageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        self.setImageURL(imageUrl, forPhotoMessageWithKey: key)
                        
                    }
                    
                })
            }
            
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
    
}
