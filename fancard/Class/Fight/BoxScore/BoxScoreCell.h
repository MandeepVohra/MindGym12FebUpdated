//
//  BoxScoreCell.h
//  fancard
//
//  Created by MEETStudio on 15-10-14.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeasonTotalPoints.h"

@interface BoxScoreCell : UITableViewCell

@property(nonatomic, strong) UILabel *quarterNumLabel;
//@property(nonatomic, strong) UIView *scoreView;

@property(nonatomic, strong) UILabel *correctCountLeft;      // correct answer/wrong answer
@property(nonatomic, strong) UIImageView *lineLeft;
@property(nonatomic, strong) UILabel *pointsLeft;
@property(nonatomic, strong) UILabel *correctCountRight;
@property(nonatomic, strong) UIImageView *lineRight;
@property(nonatomic, strong) UILabel *pointsRight;

- (void)fillBoxScoreWithSeason:(SeasonTotalPoints *)Season;

@end
