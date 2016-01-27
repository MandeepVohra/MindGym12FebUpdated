//
//  MatchUpSmallView.m
//  fancard
//
//  Created by MEETStudio on 15-10-25.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "ItemInfoView.h"
#import <PureLayout/PureLayout.h>
#import "UIViewExt.h"
#import "Mconfig.h"

@implementation ItemInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    _labelTop = [[UILabel alloc] init];      
    [_labelTop.layer setMasksToBounds:YES];
    [_labelTop.layer setCornerRadius:4.0f];
    _labelTop.font = [UIFont fontWithName:kAsapRegularFont size:12.0f];
    _labelTop.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_labelTop];
    [_labelTop autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:3.0f];
    [_labelTop autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:3.0f];
    [_labelTop autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:3.0f];
    [_labelTop autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self withMultiplier:0.25f];
    
    _labelBottom = [[UILabel alloc] init];
    _labelBottom.textAlignment = NSTextAlignmentCenter;
    _labelBottom.font = [UIFont boldSystemFontOfSize:28.0f];
    _labelBottom.adjustsFontSizeToFitWidth = YES;
    _labelBottom.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self addSubview:_labelBottom];
    [_labelBottom autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_labelTop];
    [_labelBottom autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_labelBottom autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_labelBottom autoPinEdgeToSuperviewEdge:ALEdgeRight];
}

@end
