//
//  HomeTableViewCell.h
//  MateflickApp
//
//  Created by sudheer-kumar on 20/01/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
//@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthDaylabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIImageView *postedImage;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UIButton *upperLikeB;
@property (strong, nonatomic) IBOutlet UILabel *upperLabel;
@property (strong, nonatomic) IBOutlet UIButton *upperCommentB;
@property (strong, nonatomic) IBOutlet UILabel *uppercommentlabel;
@property (weak, nonatomic) IBOutlet UIButton *upperFlickBtn;
@property (weak, nonatomic) IBOutlet UIButton *lowerFlickBtn;
@property (weak, nonatomic) IBOutlet UIButton *postDeleteBtn;


@property (weak, nonatomic) IBOutlet UIButton *userNameBtn;

//@IBOutlet private weak var collectionView: UICollectionView!


@end
