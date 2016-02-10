//
//  LeadersCell.h
//  fancard
//
//  Created by MEETStudio on 15-9-2.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView+Level.h"
#import "CWStarRateView.h"
#import "RankDelegate.h"

@class UserInfo;

@interface LeadersCell : UITableViewCell {
    UIView *_userNameView;
    UIButton *_addButton;

    UIView *_belowView;

    UIImageView *_userPhoto;
    UIView *_pointView;
    UILabel *_pointLabel;

    UIView *_wonLostView;
    UILabel *_starter;
    UILabel *_wonLost;
}

@property(nonatomic, assign) id <LeadersDelegate> delegate;
@property(nonatomic, assign) id <addFriendDelegate> FDelegate;
@property(nonatomic, strong) NSString *rankIndex;

@property(nonatomic, retain) UserInfo *topModel;
@property(nonatomic, strong) UILabel *userName;
@property(nonatomic, strong) UILabel *numPoints;
@property(nonatomic, strong) UIButton *sendChallenge;
@property(nonatomic, strong) CWStarRateView *myStarRateView;
@property(nonatomic, strong) UILabel *wonLost;

- (void)toChallenge:(UserInfo *)userModels withRank:rank;

@end
