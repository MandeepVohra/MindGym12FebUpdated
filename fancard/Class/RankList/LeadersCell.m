//
//  LeadersCell.m
//  fancard
//
//  Created by MEETStudio on 15-9-2.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "LeadersCell.h"
#import "Mconfig.h"
#import "UIViewExt.h"
#import "UIImageView+WebCache.h"
#import "UserInfo.h"
#import <PureLayout/PureLayout.h>

@implementation LeadersCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _initView];
    }
    return self;
}

- (void)_initView {
    _userNameView = [[UIView alloc] initWithFrame:CGRectZero];
    _userNameView.backgroundColor = [UIColor colorWithRed:38 / 255.0 green:39 / 255.0 blue:40 / 255.0 alpha:1.0f];
    [self.contentView addSubview:_userNameView];

    _userName = [[UILabel alloc] initWithFrame:CGRectZero];
    _userName.backgroundColor = [UIColor clearColor];
    [_userName setTextAlignment:NSTextAlignmentCenter];
    [_userName setTextColor:[UIColor whiteColor]];
    [_userNameView addSubview:_userName];

    _myStarRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(0, 0, 80, 12) numberOfStars:5];
    _myStarRateView.backgroundColor = [UIColor clearColor];
    _myStarRateView.scorePercent = 0;
    _myStarRateView.allowIncompleteStar = NO;
    _myStarRateView.hasAnimation = NO;
    [_userNameView addSubview:_myStarRateView];
    [_myStarRateView level:20];
    [_myStarRateView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_userName withOffset:5.0f];
    [_myStarRateView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:7.5];
    [_myStarRateView autoSetDimension:ALDimensionHeight toSize:12.0f];
    [_myStarRateView autoSetDimension:ALDimensionWidth toSize:80.0f];

    _addButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _addButton.backgroundColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageNamed:@"addfriend"];
    [_addButton setImage:image forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    [_userNameView addSubview:_addButton];

    _belowView = [[UIView alloc] initWithFrame:CGRectZero];
    _belowView.backgroundColor = [UIColor colorWithRed:205 / 255.0 green:205 / 255.0 blue:205 / 255.0 alpha:1];
    [self.contentView addSubview:_belowView];
    _belowView.userInteractionEnabled = YES;

    _userPhoto = [[UIImageView alloc] initWithFrame:CGRectZero];
    _userPhoto.backgroundColor = [UIColor colorWithRed:57 / 255.0 green:58 / 255.0 blue:55 / 255.0 alpha:1.0f];
    [_userPhoto.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [_userPhoto.layer setBorderWidth:1.5f];
    _userPhoto.clipsToBounds = YES;
    _userPhoto.contentMode = UIViewContentModeScaleAspectFill;
    [_belowView addSubview:_userPhoto];

    _pointView = [[UIView alloc] initWithFrame:CGRectZero];
    _pointView.backgroundColor = [UIColor colorWithRed:162 / 255.0 green:0 / 255.0 blue:21 / 255.0 alpha:1.0f];
    [_belowView addSubview:_pointView];

    _pointLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _pointLabel.backgroundColor = [UIColor whiteColor];
    [_pointLabel.layer setMasksToBounds:YES];

    [_pointLabel.layer setCornerRadius:5.0f];
    _pointLabel.font = [UIFont systemFontOfSize:13.0f];
    [_pointLabel setText:@"POINTS"];
    [_pointLabel setTextAlignment:NSTextAlignmentCenter];

    [_pointLabel setTextColor:[UIColor colorWithRed:162 / 255.0 green:0 / 255.0 blue:21 / 255.0 alpha:1.0f]];
    [_pointView addSubview:_pointLabel];

    _numPoints = [[UILabel alloc] initWithFrame:CGRectZero];
    _numPoints.backgroundColor = [UIColor clearColor];
    _numPoints.font = [UIFont boldSystemFontOfSize:23.0f];
    _numPoints.adjustsFontSizeToFitWidth = YES;
    [_numPoints setTextAlignment:NSTextAlignmentCenter];
    [_numPoints setTextColor:[UIColor whiteColor]];
    [_pointView addSubview:_numPoints];

    _wonLostView = [[UIView alloc] initWithFrame:CGRectZero];
    _wonLostView.backgroundColor = [UIColor whiteColor];
    [_belowView addSubview:_wonLostView];

    _starter = [[UILabel alloc] initWithFrame:CGRectZero];
    _starter.backgroundColor = [UIColor blueColor];
    [_starter.layer setMasksToBounds:YES];
    [_starter.layer setCornerRadius:5.0f];
    _starter.font = [UIFont boldSystemFontOfSize:13.0f];
    [_starter setText:@"W - L"];
    [_starter setTextAlignment:NSTextAlignmentCenter];

    [_starter setTextColor:[UIColor whiteColor]];
    [_wonLostView addSubview:_starter];

    _wonLost = [[UILabel alloc] initWithFrame:CGRectZero];
    _wonLost.backgroundColor = [UIColor clearColor];
    _wonLost.font = [UIFont systemFontOfSize:25.0f];
    [_wonLost setText:@"36-39"];
    [_wonLost setTextAlignment:NSTextAlignmentCenter];
    [_wonLost setTextColor:kMyBlue];
    [_wonLostView addSubview:_wonLost];

    _sendChallenge = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendChallenge.userInteractionEnabled = YES;
    _sendChallenge.backgroundColor = [UIColor clearColor];
    [_sendChallenge setBackgroundImage:[UIImage imageNamed:@"pic_ball_Leader.png"] forState:UIControlStateNormal];
    [_sendChallenge addTarget:self action:@selector(challenge:) forControlEvents:UIControlEventTouchUpInside];
    [_belowView addSubview:_sendChallenge];
}

- (void)addFriend
{
    NSLog(@"addFriend");
    if (_FDelegate && [_FDelegate respondsToSelector:@selector(addFriendByUserModel:)]) {
        [_FDelegate addFriendByUserModel:self.topModel];
    }
}

- (void)challenge:(UIButton *)butt {
    NSLog(@"send challenge");
    if (_delegate && [_delegate respondsToSelector:@selector(toChallenge:withRank:)]) {
        [_delegate toChallenge:self.topModel withRank:_rankIndex];
    }
}

- (void)layoutSubviews {
    _userNameView.frame = CGRectMake(0, 0, kScreenWidth, 27);

    _userName.frame = CGRectMake(13, 4, 100, 27);

    _userName.font = [UIFont boldSystemFontOfSize:16.0f];
    [_userName sizeToFit];

    _addButton.frame = CGRectMake(kScreenWidth - 52, 0, 52, 27);

    _belowView.frame = CGRectMake(0, 27, kScreenWidth, 112 - 27);

    NSString *image = _topModel.avatar;
    _userPhoto.frame = CGRectMake(10, 10, 65, 65);
    [_userPhoto sd_setImageWithURL:[NSURL URLWithString:image]];

    _pointView.frame = CGRectMake(_userPhoto.right + 10, 10, 65, 65);

    _pointLabel.frame = CGRectMake(3, 3, _pointView.width - 6, 16);

    _numPoints.frame = CGRectMake(0, 3 + 14, _pointView.width, 65 - 16 - 3);

//    NSInteger num = _topModel.points_total;
//    if (num >= 999) {
//        long h = num % 1000;
//        long k = num / 1000;
//        _numPoints.text = [NSString stringWithFormat:@"%ld,%.3ld", k, h];
//    } else {
//        _numPoints.text = [NSString stringWithFormat:@"%d", _topModel.points_today];
//    }

    _wonLostView.frame = CGRectMake(_pointView.right + 10, 10, 65, 65);

    _starter.frame = CGRectMake(3, 3, _wonLostView.width - 6, 16);

    _wonLost.frame = CGRectMake(0, 3 + 14, _wonLostView.width, 65 - 16 - 3);

//    _sendChallenge.frame = CGRectMake(kScreenWidth - 85, 0, 85, 85);
    CGSize imageSize = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pic_ball_Leader" ofType:@"png"]].size;
    float myWidth = 91 * imageSize.width / imageSize.height;
    _sendChallenge.frame = CGRectMake(kScreenWidth - myWidth + 35, -3, myWidth, 91);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
