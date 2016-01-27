//
//  NFTrivaBarView.m
//  fancard
//
//  Created by MEETStudio on 15-8-28.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "NFTrivaBarView.h"
#import "Mconfig.h"
#import "UIViewExt.h"

@implementation NFTrivaBarView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)_initView
{
    _questionImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 84)];
    _questionImage.backgroundColor = [UIColor colorWithRed:162/255.0f green:0 blue:20/255.0f alpha:1.0f];
    
    _belowView = [[UIView alloc] initWithFrame:CGRectMake(0, 84, kScreenWidth, self.height - 84 - 4)];
    _belowView.backgroundColor = [UIColor blueColor];
    
    _timeImage = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth / 2 - 35), 80, 70, self.height - 84 - 4 + 8)];
    _timeImage.backgroundColor = [UIColor blackColor];
    
    [self addSubview:_questionImage];
    [self addSubview:_belowView];
    [self addSubview:_timeImage];

    _questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 16, kScreenWidth-20.0f, 52)];
    _questionLabel.backgroundColor = [UIColor clearColor];
    _questionLabel.textAlignment = NSTextAlignmentCenter;
    _questionLabel.adjustsFontSizeToFitWidth = YES;
    _questionLabel.numberOfLines = 0;
    [_questionLabel setText:@""];
    _questionLabel.font = [UIFont fontWithName:kAsapRegularFont size:25.0f];
    _questionLabel.textColor = [UIColor whiteColor];
    [_questionImage addSubview:_questionLabel];
    
    _pauseLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 16, kScreenWidth-20.0f, 52)];
    _pauseLabel.backgroundColor = [UIColor clearColor];
    _pauseLabel.textAlignment = NSTextAlignmentCenter;
    _pauseLabel.numberOfLines = 1;
    [_pauseLabel setText:@""];
    [_pauseLabel sizeThatFits:CGSizeMake(kScreenWidth-20.0f, 52)];
    _pauseLabel.font = [UIFont boldSystemFontOfSize:30.0f];
    _pauseLabel.textColor = [UIColor whiteColor];
    [_questionImage addSubview:_pauseLabel];
    
    //timer board
    _quaView = [[UIView alloc] initWithFrame:CGRectMake(0, 3, 70, 13)];
    _quaView.backgroundColor = [UIColor clearColor];
    [_timeImage addSubview:_quaView];
    _image1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 13, 13)];
    _image1.image = [UIImage imageNamed:@"dot_red.png"];
    _image2 = [[UIImageView alloc] initWithFrame:CGRectMake(10+13-1, 0, 13, 13)];
    _image2.image = [UIImage imageNamed:@"dot_white.png"];
    _image3 = [[UIImageView alloc] initWithFrame:CGRectMake(10+13*2-1, 0, 13, 13)];
    _image3.image = [UIImage imageNamed:@"dot_white.png"];
    _image4 = [[UIImageView alloc] initWithFrame:CGRectMake(10+13*3-1, 0, 13, 13)];
    _image4.image = [UIImage imageNamed:@"dot_white.png"];
    [_quaView addSubview:_image1];
    [_quaView addSubview:_image2];
    [_quaView addSubview:_image3];
    [_quaView addSubview:_image4];
    
    _timeQua = [[UILabel alloc] initWithFrame:CGRectMake(10, 17, 50, 20)];
    _timeQua.textAlignment = NSTextAlignmentCenter;
    _timeQua.backgroundColor = [UIColor colorWithRed:38 / 255.0 green:39 / 255.0 blue:40 / 255.0 alpha:1.0f];
    [_timeQua setText:@"--:--"];
    _timeQua.font = [UIFont fontWithName:kDigitalFont size:18.0f];
    [_timeQua setTextColor:[UIColor yellowColor]];
    [_timeImage addSubview:_timeQua];
    
    _roundTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 70, 30)];
    _roundTime.backgroundColor = [UIColor clearColor];
    _roundTime.textAlignment = NSTextAlignmentCenter;
    [_roundTime setText:@"--"];
    [_roundTime setTextColor:[UIColor redColor]];
    _roundTime.font = [UIFont fontWithName:kDigitalFont size:35.0f];
    [_timeImage addSubview:_roundTime];
    
    _time5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 70, 30)];
    _time5.backgroundColor = [UIColor clearColor];
    _time5.textAlignment = NSTextAlignmentCenter;
    [_time5 setText:@""];
    [_time5 setTextColor:[UIColor redColor]];
    _time5.font = [UIFont fontWithName:kDigitalFont size:35.0f];
    [_timeImage addSubview:_time5];
    
    //Battle of user information
    _userPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, _belowView.height - 10, _belowView.height - 10)];
    _userPhoto.backgroundColor = [UIColor whiteColor];
    _userPhoto.clipsToBounds = YES;
    _userPhoto.contentMode = UIViewContentModeScaleAspectFill;
    [_belowView addSubview:_userPhoto];
    
    _opponentPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 5 - (_belowView.height - 10), 5, _belowView.height - 10, _belowView.height - 10)];
    _opponentPhoto.backgroundColor = [UIColor whiteColor];
    _opponentPhoto.clipsToBounds = YES;
    _opponentPhoto.contentMode = UIViewContentModeScaleAspectFill;
    [_belowView addSubview:_opponentPhoto];
    
    _userPoints = [[UILabel alloc] initWithFrame:CGRectMake(5 + _userPhoto.bounds.size.width, 0, kScreenWidth / 2 - _timeImage.width / 2 - _userPhoto.width - 5, _belowView.height)];
    _userPoints.backgroundColor = [UIColor clearColor];
    _userPoints.font = [UIFont boldSystemFontOfSize:36.0f];
    [_userPoints setText:@"0"];
    [_userPoints setTextAlignment:NSTextAlignmentCenter];
    [_userPoints setTextColor:[UIColor whiteColor]];
    [_belowView addSubview:_userPoints];
    
    _botPoints = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 + _timeImage.bounds.size.width / 2, 0, _userPoints.width, _userPoints.height)];
    _botPoints.backgroundColor = [UIColor clearColor];
    _botPoints.font = [UIFont boldSystemFontOfSize:36.0f];
    [_botPoints setText:@"0"];
    [_botPoints setTextAlignment:NSTextAlignmentCenter];
    [_botPoints setTextColor:[UIColor whiteColor]];
    [_belowView addSubview:_botPoints];
}

- (void)drawRect:(CGRect)rect {
    
}

@end
