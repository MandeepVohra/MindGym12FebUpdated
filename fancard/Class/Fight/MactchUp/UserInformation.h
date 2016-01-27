//
//  UserInformation.h
//  fancard
//
//  Created by MEETStudio on 15-10-26.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemInfoView.h"
#import "CWStarRateView.h"

@interface UserInformation : UIView {
    UIView *_myInfoBox;
    
}

@property(nonatomic, strong) UILabel *labelName;
@property(nonatomic, strong) UIImageView *avatar;
@property(nonatomic, strong) ItemInfoView *points;
@property(nonatomic, strong) ItemInfoView *ppg;     //points per game
@property(nonatomic, strong) ItemInfoView *rank;
@property(nonatomic, strong) ItemInfoView *wonLost;
@property(nonatomic, strong) CWStarRateView *myStarRateView;


@end
