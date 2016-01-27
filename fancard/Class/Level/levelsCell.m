//
//  levelsCell.m
//  fancard
//
//  Created by MEETStudio on 15-9-10.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "levelsCell.h"
#import "Mconfig.h"
#import "UIViewExt.h"

@implementation levelsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _initView];
    }
    return self;
}

- (void)_initView {
    _leftView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 40, (kScreenHeight - 50) / 5 - 11)];
    _leftView.backgroundColor = kLevelGray;
    [self.contentView addSubview:_leftView];

    _locks = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 20, 28)];
    _locks.backgroundColor = [UIColor clearColor];
    [_leftView addSubview:_locks];

    _line = [[UILabel alloc] initWithFrame:CGRectMake(2.5f, _leftView.height / 2 - 3, _leftView.width - 5, 1.5f)];
    _line.backgroundColor = [UIColor whiteColor];
    [_leftView addSubview:_line];

    _labelWinNum = [[UILabel alloc] initWithFrame:CGRectMake(0, _leftView.height / 2 + 2, _leftView.width, _leftView.height / 2 - 15)];
    _labelWinNum.backgroundColor = [UIColor clearColor];
    _labelWinNum.font = [UIFont fontWithName:kAsapBoldFont size:25.0f];
    _labelWinNum.textAlignment = NSTextAlignmentCenter;
    _labelWinNum.textColor = [UIColor whiteColor];
    [_leftView addSubview:_labelWinNum];

    _labelWins = [[UILabel alloc] initWithFrame:CGRectMake(0, _leftView.height - 15, _leftView.width, 15)];
    _labelWins.backgroundColor = [UIColor clearColor];
    _labelWins.font = [UIFont fontWithName:kAsapRegularFont size:10.0f];
    _labelWins.textAlignment = NSTextAlignmentCenter;
    _labelWins.textColor = [UIColor whiteColor];
    [_leftView addSubview:_labelWins];

    _rightView = [[UIView alloc] initWithFrame:CGRectMake(_leftView.right, 10, kScreenWidth - 10 - _leftView.width, _leftView.height)];
    _rightView.backgroundColor = [UIColor colorWithRed:241.0 / 255.0 green:240.0 / 255.0 blue:241.0 / 255.0 alpha:1.0f];
    [self.contentView addSubview:_rightView];

    _levelName = [[UILabel alloc] initWithFrame:CGRectMake(13, 12, _rightView.width / 2, 20)];
    _levelName.backgroundColor = [UIColor clearColor];
    _levelName.font = [UIFont boldSystemFontOfSize:23.0f];
    _levelName.textColor = kLevelGray;
    [_rightView addSubview:_levelName];
    
    _myStarRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(_rightView.width - 10 - 100, _levelName.top+2, 100, 16.3) numberOfStars:5 image:@"icon_star_2"];
    _myStarRateView.backgroundColor = [UIColor clearColor];
    _myStarRateView.scorePercent = 0;
    _myStarRateView.allowIncompleteStar = NO;
    _myStarRateView.hasAnimation = NO;
    [_rightView addSubview:_myStarRateView];

    _bluePoint1 = [[UIImageView alloc] initWithFrame:CGRectMake(_levelName.left, _levelName.bottom + 18, 5, 5)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"dot_gray" ofType:@"png"];
    _bluePoint1.image = [UIImage imageWithContentsOfFile:path];
    [_rightView addSubview:_bluePoint1];

    _bluePoint2 = [[UIImageView alloc] initWithFrame:CGRectMake(_levelName.left, _bluePoint1.bottom + 15, 5, 5)];
    _bluePoint2.image = [UIImage imageWithContentsOfFile:path];
    [_rightView addSubview:_bluePoint2];

    _privilege1 = [[UILabel alloc] initWithFrame:CGRectMake(_bluePoint1.right + 10, _bluePoint1.top - 5, 200, 15)];
    _privilege1.backgroundColor = [UIColor clearColor];
    _privilege1.font = [UIFont fontWithName:kAsapRegularFont size:12.0f];
    [_rightView addSubview:_privilege1];

    _privilege2 = [[UILabel alloc] initWithFrame:CGRectMake(_privilege1.left, _privilege1.bottom + 5, 200, 15)];
    _privilege2.backgroundColor = [UIColor clearColor];
    _privilege2.font = [UIFont fontWithName:kAsapRegularFont size:12.0f];
    [_rightView addSubview:_privilege2];
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
