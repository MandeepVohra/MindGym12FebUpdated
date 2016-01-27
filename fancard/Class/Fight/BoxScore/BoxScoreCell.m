//
//  BoxScoreCell.m
//  fancard
//
//  Created by MEETStudio on 15-10-14.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "BoxScoreCell.h"
#import "Mconfig.h"
#import "ALView+PureLayout.h"

@implementation BoxScoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _initView];
    }
    return self;
}

- (void)_initView {

    self.contentView.backgroundColor = UIColorHex(0x262828);

    self.quarterNumLabel = [[UILabel alloc] init];
    self.quarterNumLabel.textAlignment = NSTextAlignmentCenter;
    self.quarterNumLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.quarterNumLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.quarterNumLabel];

    [self.quarterNumLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.quarterNumLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.quarterNumLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.quarterNumLabel autoSetDimension:ALDimensionHeight toSize:40.0f];

    UIImageView *scoreView = [[UIImageView alloc] init];
    scoreView.clipsToBounds = YES;
    scoreView.contentMode = UIViewContentModeScaleAspectFill;
    scoreView.image = [UIImage imageNamed:@"pic_boxScore_0"];
    [self.contentView addSubview:scoreView];

    [scoreView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.quarterNumLabel];
    [scoreView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [scoreView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [scoreView autoPinEdgeToSuperviewEdge:ALEdgeBottom];

    float boxHalfWidth = (kScreenWidth - 10) / 2.0f;
    float correctCountWidth = boxHalfWidth * 0.4f;
    float pointWidth = boxHalfWidth - correctCountWidth;
    self.correctCountLeft = [[UILabel alloc] init];
    self.correctCountLeft.backgroundColor = [UIColor clearColor];
    self.correctCountLeft.textAlignment = NSTextAlignmentCenter;
    self.correctCountLeft.textColor = [UIColor whiteColor];
    self.correctCountLeft.font = [UIFont fontWithName:kAsapRegularFont size:20.0f];
    [scoreView addSubview:self.correctCountLeft];

    [self.correctCountLeft autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.correctCountLeft autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.correctCountLeft autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.correctCountLeft autoSetDimension:ALDimensionWidth toSize:correctCountWidth];

    CGFloat lineGap = 15.0f;

    self.lineLeft = [[UIImageView alloc] init];
    self.lineLeft.hidden = YES;
    self.lineLeft.clipsToBounds = YES;
    self.lineLeft.contentMode = UIViewContentModeScaleAspectFit;
    self.lineLeft.image = [UIImage imageNamed:@"pic_line_boxScore"];
    [scoreView addSubview:self.lineLeft];

    [self.lineLeft autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:correctCountWidth];
    [self.lineLeft autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:lineGap];
    [self.lineLeft autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:lineGap];

    self.pointsLeft = [[UILabel alloc] init];
    self.pointsLeft.backgroundColor = [UIColor clearColor];
    self.pointsLeft.textAlignment = NSTextAlignmentCenter;
    self.pointsLeft.textColor = [UIColor whiteColor];
    self.pointsLeft.font = [UIFont fontWithName:kAsapBoldFont size:30.0f];
    [scoreView addSubview:self.pointsLeft];

    [self.pointsLeft autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.pointsLeft autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.pointsLeft autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.correctCountLeft];
    [self.pointsLeft autoSetDimension:ALDimensionWidth toSize:pointWidth];

    self.correctCountRight = [[UILabel alloc] init];
    self.correctCountRight.backgroundColor = [UIColor clearColor];
    self.correctCountRight.textAlignment = NSTextAlignmentCenter;
    self.correctCountRight.textColor = [UIColor whiteColor];
    self.correctCountRight.font = [UIFont fontWithName:kAsapRegularFont size:20.0f];
    [scoreView addSubview:self.correctCountRight];

    [self.correctCountRight autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.correctCountRight autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.correctCountRight autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.correctCountRight autoSetDimension:ALDimensionWidth toSize:correctCountWidth];

    self.lineRight = [[UIImageView alloc] init];
    self.lineRight.clipsToBounds = YES;
    self.lineRight.contentMode = UIViewContentModeScaleAspectFit;
    self.lineRight.hidden = YES;
    self.lineRight.image = [UIImage imageNamed:@"pic_line_boxScore"];
    [scoreView addSubview:self.lineRight];

    [self.lineRight autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:correctCountWidth];
    [self.lineRight autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:lineGap];
    [self.lineRight autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:lineGap];

    self.pointsRight = [[UILabel alloc] init];
    self.pointsRight.backgroundColor = [UIColor clearColor];
    self.pointsRight.textAlignment = NSTextAlignmentCenter;
    self.pointsRight.textColor = [UIColor whiteColor];
    self.pointsRight.font = [UIFont fontWithName:kAsapBoldFont size:30.0f];
    [scoreView addSubview:self.pointsRight];

    [self.pointsRight autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.pointsRight autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.pointsRight autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.correctCountRight];
    [self.pointsRight autoSetDimension:ALDimensionWidth toSize:pointWidth];

}

- (void)fillBoxScoreWithSeason:(SeasonTotalPoints *)Season {
    if (Season) {
//        if (Season.mySeasonQuestion > 0) {
        if (YES) {
            self.lineLeft.hidden = NO;
            self.lineRight.hidden = NO;

            self.pointsLeft.text = [NSString stringWithFormat:@"%d", Season.mySeasonScore];
            self.correctCountLeft.text = [NSString stringWithFormat:@"%d/%d", Season.myCorrectQuestion, Season.mySeasonQuestion];

            self.pointsRight.text = [NSString stringWithFormat:@"%d", Season.oppSeasonScore];
            self.correctCountRight.text = [NSString stringWithFormat:@"%d/%d", Season.oppCorrectQuestion, Season.oppSeasonQuestion];
        } else {
            self.lineLeft.hidden = YES;
            self.lineRight.hidden = YES;
            self.correctCountLeft.text = @"";
            self.pointsLeft.text = @"";
            self.pointsRight.text = @"";
            self.correctCountRight.text = @"";
        }
    }
}

@end
