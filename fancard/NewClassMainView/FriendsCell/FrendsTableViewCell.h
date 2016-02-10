//
//  FrendsTableViewCell.h
//  fancard
//
//  Created by Mandeep on 28/01/16.
//  Copyright © 2016 MEETStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrendsTableViewCell : UITableViewCell
@property (nonatomic,retain) IBOutlet UIImageView *ProfilePic,*RateImage1,*RateImage2,*RateImage3,*RateImage4,*RateImage5,*TickImage;
@property (nonatomic,retain) IBOutlet UILabel *LabelCount,*NameLabel,*WonLostLabel,*PointsLabel;
@property (nonatomic,retain) IBOutlet UIButton *ChallengeButton,*AddfriendButton;
@end
