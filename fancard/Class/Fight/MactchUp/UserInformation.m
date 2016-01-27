//
//  UserInformation.m
//  fancard
//
//  Created by MEETStudio on 15-10-26.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "UserInformation.h"
#import "Mconfig.h"
#import <PureLayout/PureLayout.h>
#import "CWStarRateView+Level.h"

@implementation UserInformation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)_initView
{
    _myInfoBox = [[UIView alloc] initWithFrame:CGRectMake(10, 60, kScreenWidth - 20, 130.f)];
    _myInfoBox.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.81f];
    [self addSubview:_myInfoBox];
    
    _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110, 110)];
    _avatar.clipsToBounds = YES;
    _avatar.contentMode = UIViewContentModeScaleAspectFill;
    _avatar.backgroundColor = [UIColor colorWithRed:53.0/255.0f green:53.0/255.0f blue:53.0/255.0f alpha:1.0f];
    [_avatar.layer setBorderWidth:1.3f];
    [_avatar.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self addSubview:_avatar];
    
    _labelName = [[UILabel alloc] init];
    _labelName.backgroundColor = [UIColor clearColor];
    _labelName.text = @"Firstname Lastname";
    _labelName.textColor = [UIColor whiteColor];
    _labelName.font = [UIFont fontWithName:kAsapBoldFont size:18.0f];
    _labelName.adjustsFontSizeToFitWidth = YES;
    [_myInfoBox addSubview:_labelName];
    [_labelName autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_avatar withOffset:5.0f];
    [_labelName autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_labelName autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_labelName autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:_myInfoBox withMultiplier:0.2f];
    _myStarRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(100, 30, 140, 20) numberOfStars:5];
    _myStarRateView.backgroundColor = [UIColor clearColor];
    _myStarRateView.scorePercent = 0;
    _myStarRateView.allowIncompleteStar = NO;
    _myStarRateView.hasAnimation = NO;
    [_myInfoBox addSubview:_myStarRateView];
    [_myStarRateView level:20];
    
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, kScreenWidth-20, 70)];
    myView.backgroundColor = [UIColor clearColor];
    [_myInfoBox addSubview:myView];
    
    _points = [[ItemInfoView alloc] init];
    _points.backgroundColor = [UIColor colorWithRed:153.0/255.0f green:0/255.0f blue:10.0/255.0f alpha:1.0f];
    _points.labelTop.backgroundColor = [UIColor whiteColor];
    _points.labelTop.text = @"POINTS";
    _points.labelTop.textColor = [UIColor colorWithRed:153.0/255.0f green:0/255.0f blue:10.0/255.0f alpha:1.0f];
    _points.labelBottom.text = @"699";
    _points.labelBottom.textColor = [UIColor whiteColor];
    [myView addSubview:_points];
    
    _ppg = [[ItemInfoView alloc] init];
    _ppg.backgroundColor = [UIColor whiteColor];
    _ppg.labelTop.backgroundColor = [UIColor colorWithRed:153.0/255.0f green:0/255.0f blue:10.0/255.0f alpha:1.0f];
    _ppg.labelTop.text = @"PPG";
    _ppg.labelTop.textColor = [UIColor whiteColor];
    _ppg.labelBottom.text = @"58.3";
    _ppg.labelBottom.textColor = [UIColor colorWithRed:153.0/255.0f green:0/255.0f blue:10.0/255.0f alpha:1.0f];
    [myView addSubview:_ppg];
    
    _rank = [[ItemInfoView alloc] init];
    _rank.backgroundColor = [UIColor colorWithRed:22.0/255.0f green:-0/255.0f blue:242.0/255.0f alpha:1.0f];
    _rank.labelTop.backgroundColor = [UIColor whiteColor];
    _rank.labelTop.text = @"RANK";
    _rank.labelTop.textColor = [UIColor colorWithRed:22.0/255.0f green:-0/255.0f blue:242.0/255.0f alpha:1.0f];
    _rank.labelBottom.text = @"32";
    _rank.labelBottom.textColor = [UIColor whiteColor];
    [myView addSubview:_rank];
    
    _wonLost = [[ItemInfoView alloc] init];
    _wonLost.backgroundColor = [UIColor whiteColor];
    _wonLost.labelTop.backgroundColor = [UIColor colorWithRed:22.0/255.0f green:-0/255.0f blue:242.0/255.0f alpha:1.0f];
    _wonLost.labelTop.text = @"W - L";
    _wonLost.labelTop.textColor = [UIColor whiteColor];
    //    _wonLost.labelBottom.text = @"2-12";
    _wonLost.labelBottom.textColor = [UIColor colorWithRed:22.0/255.0f green:-0/255.0f blue:242.0/255.0f alpha:1.0f];
    [myView addSubview:_wonLost];
    NSArray *views = @[_points, _ppg, _rank, _wonLost];
    [views[1] autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [views autoSetViewsDimension:ALDimensionHeight toSize:65.0f];
    [views autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:5.0f insetSpacing:YES matchedSizes:YES];
}

@end
