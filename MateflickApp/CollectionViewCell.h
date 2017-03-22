//
//  CollectionViewCell.h
//  MateflickApp
//
//  Created by sudheer-kumar on 01/03/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *collectionimageBtn;
@property (weak, nonatomic) IBOutlet UILabel *collectionUserNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addFriendActionBtn;

@end
