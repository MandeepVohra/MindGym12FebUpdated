//
//  VSInfoViewController.m
//  fancard
//  Match Up

//  Created by MEETStudio on 15-8-28.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "VSInfoViewController.h"
#import "MyFightViewController.h"
#import "Mconfig.h"
#import "CMOpenALSoundManager+Singleton.h"
#import <PureLayout/PureLayout.h>
#import "UIViewExt.h"
#import "CWStarRateView.h"
#import "CWStarRateView+Level.h"
#import "UserInformation.h"
#import <MJExtension/MJExtension.h>
#import <LKDBHelper/NSObject+LKDBHelper.h>
#import <AFNetworking/AFHTTPRequestOperation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "MySocket.h"
#import "UIImageView+WebCache.h"
#import "UserInfo.h"
#import "LanbaooPrefs.h"
#import "ETGlobal.h"
#import "NSDate+FormatDateString.h"

@interface VSInfoViewController () {
    UIImageView *_backgroundImage;  //background

    UIView *_countdownView;      //5s timer view
    UILabel *_labelTipOff;        //label "TIP OFF"
    UILabel *_labelCountdown;     //timer count label
    NSTimer *CDTimer5;            //5s timer
    NSTimer *waitTimer24;         //24s timer view
    NSTimer *joinTimer24;         //“join game”
    NSTimer *timeOutTimer;        //after 24 seconds
    BOOL canJoinGame;

    NSInteger secondsCD5;           //timer counter
    NSInteger waitCD24;

    UIView *_upperView;             //Upper half of the screen view
    UIView *_belowView;             //The lower half of the screen view
    UIImageView *_iconVs;           //"VS" imageview
    UserInformation *_userInfoView; //my info
    UserInformation *_oppInfoView;  //player info

    UIView *_keepWaiting;           //The other party did not join
    UIView *_joinGame;              //Challenger go into the matchup interface
    UILabel *_logo;
    UIButton *_backButtonLeft;
    UIButton *_backButtonRight;
    UILabel *_nameLabel;
    UILabel *_statusLabel;
    UILabel *_labelShifly;
    UIView *_waiting;               //wait 24s view

    UILabel *_countDown24;          //wait 24s timer view
    UILabel *_joinTimeLabel;

    UILabel *_loading;              //locating an opponent

    UIImageView *_rotateBall;
}

@end

@implementation VSInfoViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[CMOpenALSoundManager singleton] purgeSounds];

    if (![LanbaooPrefs sharedInstance].musicOff) {
        if (_friendId) {
            [[CMOpenALSoundManager singleton] playSoundWithID:10];
            [[CMOpenALSoundManager singleton] playBackgroundMusic:@"MatchUp Screen Vs Friend.mp3"];
        } else {
            [[CMOpenALSoundManager singleton] playBackgroundMusic:@"MatchUp Screen Vs Random.mp3"];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

//background
    self.view.backgroundColor = [UIColor orangeColor];
    _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Court_01" ofType:@"png"];
    _backgroundImage.image = [UIImage imageWithContentsOfFile:path];
    [self.view addSubview:_backgroundImage];

    _iconVs = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 40, kScreenHeight / 2 - 40, 80, 80)];
    _iconVs.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_VS@2x" ofType:@"png"]];
    [self.view addSubview:_iconVs];

//upper view
    _upperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 2)];
    _upperView.backgroundColor = [UIColor clearColor];
    //[self.view addSubview:_upperView];

//----------------------------mine info-------------------------------
    _userInfoView = [[UserInformation alloc] initWithFrame:CGRectMake(1, 15, kScreenWidth, _upperView.height - 15 - 70)];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    UserInfo *userInfo = [UserInfo searchSingleWithWhere:nil orderBy:nil];
    if (!userInfo) {
        userInfo = [[UserInfo alloc] init];
    }

    NSInteger myWinNum = userInfo.number_win;
    NSInteger myLostNum = userInfo.number_lost;
    NSString *myUserName = [NSString stringWithFormat:@"%@ %@", userInfo.firstname, userInfo.lastname];
    NSInteger myTotalPoints = userInfo.points_total;
    NSInteger myRank = [LanbaooPrefs sharedInstance].rank;
    NSString *myAvatar = userInfo.avatar;
    float myPer = 0;
    NSString *myWonLost = [NSString stringWithFormat:@"%ld-%ld", (long) myWinNum, (long) myLostNum];
    if ((myWinNum + myLostNum) != 0) {
        myPer = (float) myTotalPoints / (float) (myWinNum + myLostNum);
    }
    _userInfoView.wonLost.labelBottom.text = myWonLost;
    _userInfoView.points.labelBottom.text = [NSString stringWithFormat:@"%ld", (long) myTotalPoints];
    _userInfoView.ppg.labelBottom.text = [NSString stringWithFormat:@"%.1f", myPer];
    [_userInfoView.myStarRateView level:myWinNum];
    _userInfoView.labelName.text = myUserName;
    _userInfoView.backgroundColor = [UIColor clearColor];
    _userInfoView.rank.labelBottom.text = [NSString stringWithFormat:@"%i", myRank];
    [_userInfoView.avatar sd_setImageWithURL:[NSURL URLWithString:myAvatar]];
//1    [_upperView addSubview:_userInfoView];
//-------------------------------------------------------------------------

//below view
    _belowView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight / 2, kScreenWidth, kScreenHeight / 2)];
    _belowView.backgroundColor = [UIColor clearColor];
   // [self.view addSubview:_belowView];

//--------------------------Robots information or other information---------------------------------
    _oppInfoView = [[UserInformation alloc] initWithFrame:CGRectMake(1, 15, kScreenWidth, _belowView.height - 15 - 70)];
    _oppInfoView.backgroundColor = [UIColor clearColor];
    if (self.friendModel) {
        NSString *oppWonLost = [NSString stringWithFormat:@"%d-%d", _friendModel.number_win, _friendModel.number_lost];
        NSString *oppUserName = [NSString stringWithFormat:@"%@ %@", _friendModel.firstname, _friendModel.lastname];
        float oppPer = 0;
        if ((_friendModel.number_win + _friendModel.number_lost) != 0) {
            oppPer = (float) _friendModel.points_total / (float) (_friendModel.number_win + _friendModel.number_lost);
        }
        _oppInfoView.labelName.text = oppUserName;
        [_oppInfoView.myStarRateView level:_friendModel.number_win];
        _oppInfoView.points.labelBottom.text = [NSString stringWithFormat:@"%d", _friendModel.points_total];
        _oppInfoView.ppg.labelBottom.text = [NSString stringWithFormat:@"%.1f", oppPer];
        _oppInfoView.wonLost.labelBottom.text = [NSString stringWithFormat:@"%@", oppWonLost];
        _oppInfoView.rank.labelBottom.text = [NSString stringWithFormat:@"%i", _friendModel.rank.intValue];
        [_oppInfoView.avatar sd_setImageWithURL:[NSURL URLWithString:_friendModel.avatar]];

    } else if (self.botModel) {
        NSString *oppWonLost = [NSString stringWithFormat:@"%d-%d", _botModel.winNum, _botModel.lostNum];
        NSString *oppUserName = [NSString stringWithFormat:@"%@ %@", _botModel.firstName, _botModel.lastName];
        float oppPer = 0;
        if ((_botModel.winNum + _botModel.lostNum) != 0) {
            oppPer = (float) _botModel.totalPoints / (float) (_botModel.winNum + _botModel.lostNum);
        }
        _oppInfoView.labelName.text = oppUserName;
        [_oppInfoView.myStarRateView level:_botModel.winNum];
        _oppInfoView.points.labelBottom.text = [NSString stringWithFormat:@"%d", _botModel.totalPoints];
        _oppInfoView.ppg.labelBottom.text = [NSString stringWithFormat:@"%.1f", oppPer];
        _oppInfoView.wonLost.labelBottom.text = [NSString stringWithFormat:@"%@", oppWonLost];
//        _oppInfoView.rank.labelBottom.text = [NSString stringWithFormat:@"%i", _botModel.rank.intValue];
        _oppInfoView.avatar.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"you" ofType:@"jpg"]];
    }
//2    [_belowView addSubview:_oppInfoView];

//loading label
    _loading = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 2)];
    _loading.backgroundColor = [UIColor clearColor];
    _loading.numberOfLines = 2;
    [_loading setText:@"Locating  an\nopponent…"];
    [_loading setTextAlignment:NSTextAlignmentCenter];
    [_loading setTextColor:[UIColor whiteColor]];
    _loading.font = [UIFont boldSystemFontOfSize:36.0f];

//----------------------------5s timer view---------------------------
    _countdownView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 30, 0, 60, 50)];
    _countdownView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.88f];
    _countdownView.hidden = YES;
    [_upperView addSubview:_countdownView];

    _labelTipOff = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 15)];
    _labelTipOff.backgroundColor = [UIColor clearColor];
    _labelTipOff.font = [UIFont boldSystemFontOfSize:13.0f];
    [_labelTipOff setText:@"TIP-OFF"];
    [_labelTipOff setTextAlignment:NSTextAlignmentCenter];
    [_labelTipOff setTextColor:[UIColor yellowColor]];
    [_countdownView addSubview:_labelTipOff];

    _labelCountdown = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 60, 35)];
    _labelCountdown.backgroundColor = [UIColor clearColor];
    _labelCountdown.font = [UIFont fontWithName:kDigitalFont size:35.0f];
    [_labelCountdown setTextAlignment:NSTextAlignmentCenter];
    [_labelCountdown setTextColor:[UIColor redColor]];
    [_countdownView addSubview:_labelCountdown];

    _keepWaiting = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 2)];
    _keepWaiting.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.81f];
//3    [_belowView addSubview:_keepWaiting];

    _waiting = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 2)];
    _waiting.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9f];
//4    [_belowView addSubview:_waiting];

//---------------------------------The other party did not join the game------------------------------------
    UILabel *notJoinedLabel = [[UILabel alloc] init];
    notJoinedLabel.textAlignment = NSTextAlignmentCenter;
    notJoinedLabel.text = @"Opponent hasn't joined...";
    notJoinedLabel.backgroundColor = [UIColor clearColor];
    [notJoinedLabel setTextColor:[UIColor redColor]];
    notJoinedLabel.adjustsFontSizeToFitWidth = YES;
    notJoinedLabel.font = [UIFont fontWithName:kAsapBoldFont size:26.0f];
    [_keepWaiting addSubview:notJoinedLabel];
    [notJoinedLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [notJoinedLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [notJoinedLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:40.0f];
    [notJoinedLabel autoSetDimension:ALDimensionHeight toSize:40.0f];

    UILabel *labelKeepWait = [[UILabel alloc] init];
    labelKeepWait.textAlignment = NSTextAlignmentCenter;
    labelKeepWait.adjustsFontSizeToFitWidth = YES;
    labelKeepWait.numberOfLines = 2;
    labelKeepWait.backgroundColor = [UIColor clearColor];
    [labelKeepWait setTextColor:[UIColor whiteColor]];
    labelKeepWait.font = [UIFont fontWithName:kAsapBoldFont size:22.0f];
    NSString *str1 = @"You can keep waiting or\nthey can just catch up!";
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:str1];
    [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:[str1 rangeOfString:@"keep waiting"]];
    [labelKeepWait setAttributedText:string1];
    [_keepWaiting addSubview:labelKeepWait];
    [labelKeepWait autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [labelKeepWait autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [labelKeepWait autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:notJoinedLabel];
    [labelKeepWait autoSetDimension:ALDimensionHeight toSize:90.0f];

    UIButton *startGame = [UIButton buttonWithType:UIButtonTypeCustom];
    [startGame setTitle:@"Start Game" forState:UIControlStateNormal];
    [startGame setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startGame setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    startGame.titleLabel.font = [UIFont fontWithName:kAsapBoldFont size:40.0f];
    startGame.backgroundColor = [UIColor redColor];
    [_keepWaiting addSubview:startGame];
    [startGame autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [startGame autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [startGame autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:12.0f];
    [startGame autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:labelKeepWait];
    [startGame addTarget:self action:@selector(toBeginGame) forControlEvents:UIControlEventTouchUpInside];
//--------------------------------------------------------------------------------------

//-----------------------------------Challenger waiting to be added--------------------------------------
    UILabel *labelWait = [[UILabel alloc] init];
    labelWait.textAlignment = NSTextAlignmentCenter;
    labelWait.text = @"waiting for opponent...";
    labelWait.adjustsFontSizeToFitWidth = YES;
    labelWait.backgroundColor = [UIColor clearColor];
    [labelWait setTextColor:[UIColor whiteColor]];
    labelWait.font = [UIFont fontWithName:kAsapBoldFont size:30.0f];
    [_waiting addSubview:labelWait];
    [labelWait autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [labelWait autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [labelWait autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:40.0f];
    [labelWait autoSetDimension:ALDimensionHeight toSize:40.0f];

    _countDown24 = [[UILabel alloc] init];
    _countDown24.font = [UIFont fontWithName:kDigitalFont size:180.0f];
    _countDown24.textAlignment = NSTextAlignmentCenter;
    _countDown24.backgroundColor = [UIColor clearColor];
    [_countDown24 setTextColor:[UIColor redColor]];
    [_waiting addSubview:_countDown24];
    [_countDown24 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_countDown24 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_countDown24 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [_countDown24 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:labelWait];

//-----------------------------------Challenger go into the matchup interface------------------------------------------------
    _joinGame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 2)];
    _joinGame.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9f];

    CGSize imageSize = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Btn_back" ofType:@"png"]].size;
    float myWidth = 30 * imageSize.width / imageSize.height;

    _backButtonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButtonRight.frame = CGRectMake(kScreenWidth - 50, 0, 50, 50);
    [_backButtonRight setImage:[UIImage imageNamed:@"btn_close.png"] forState:UIControlStateNormal];
    _backButtonRight.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    [_backButtonRight addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];

    _backButtonLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButtonLeft.frame = CGRectMake(10, 10, myWidth, 30);
    [_backButtonLeft setBackgroundImage:[UIImage imageNamed:@"Btn_back.png"] forState:UIControlStateNormal];
    [_backButtonLeft addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];

    _logo = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 140, 10, 130, 30)];
    _logo.textAlignment = NSTextAlignmentCenter;
    _logo.backgroundColor = [UIColor clearColor];
    [_logo setTextColor:[UIColor orangeColor]];
    _logo.font = [UIFont fontWithName:kAsapBoldFont size:26.0f];
    NSString *str = @"MINDGYM";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
    [string addAttribute:NSForegroundColorAttributeName value:kMyBlue range:[str rangeOfString:@"GYM"]];
    [_logo setAttributedText:string];

    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 25)];
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@", _friendModel.firstname, _friendModel.lastname];

    _nameLabel.textColor = [UIColor redColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont fontWithName:kAsapBoldFont size:25.0f];
    [_joinGame addSubview:_nameLabel];

    _statusLabel = [[UILabel alloc] init];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.textColor = [UIColor redColor];
    _statusLabel.font = [UIFont fontWithName:kAsapBoldFont size:25.0f];
    [_joinGame addSubview:_statusLabel];
    [_statusLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_statusLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_statusLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_nameLabel];
    [_statusLabel autoSetDimension:ALDimensionHeight toSize:25.0f];

    _joinTimeLabel = [[UILabel alloc] init];
    _joinTimeLabel.textAlignment = NSTextAlignmentCenter;
    _joinTimeLabel.text = @"";
    _joinTimeLabel.backgroundColor = [UIColor clearColor];
    [_joinTimeLabel setTextColor:[UIColor yellowColor]];
    _joinTimeLabel.font = [UIFont fontWithName:kDigitalFont size:40.0f];
    [_joinGame addSubview:_joinTimeLabel];
    [_joinTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_joinTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_joinTimeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_statusLabel];
    [_joinTimeLabel autoSetDimension:ALDimensionHeight toSize:50.0f];

    _labelShifly = [[UILabel alloc] init];
    _labelShifly.textAlignment = NSTextAlignmentCenter;
    _labelShifly.backgroundColor = [UIColor clearColor];
    [_labelShifly setTextColor:[UIColor whiteColor]];
    _labelShifly.font = [UIFont fontWithName:kAsapBoldFont size:16.0f];
    [_joinGame addSubview:_labelShifly];
    [_labelShifly autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_joinTimeLabel];
    [_labelShifly autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_labelShifly autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_labelShifly autoSetDimension:ALDimensionHeight toSize:20.0f];

    UIButton *joinGame = [UIButton buttonWithType:UIButtonTypeCustom];
    [joinGame setTitle:@"Join Game" forState:UIControlStateNormal];
    [joinGame setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [joinGame setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    joinGame.titleLabel.font = [UIFont fontWithName:kAsapBoldFont size:40.0f];
    joinGame.backgroundColor = [UIColor redColor];
    [_joinGame addSubview:joinGame];
    [joinGame autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:8.0f];
    [joinGame autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:8.0f];
    [joinGame autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [joinGame autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_labelShifly];
    [joinGame addTarget:self action:@selector(toJoinGame) forControlEvents:UIControlEventTouchUpInside];

//-------------------------------------------------------------------------------------------------------
    canJoinGame = YES;

/*  is Challenger:
 * Show my information ; 24 seconds after the display timing"start game"
 * Receive action = @ "begin", hidden time, show opponent
 *
 *  isAccept:
 * Show my information ( in the next half of the screen ) ; 24 seconds countdown, after resume timing (layout adjust )
 * Click on "join game" send action = @ "begin", hidden time, show opponent
 */
    [self UIAcceptChallenge];
    
    if (_isChallenger) {
        _isChallenger = NO;
        NSLog(@"isChallenger");
        [_upperView addSubview:_userInfoView];
        [_belowView addSubview:_waiting];
        [self.view addSubview:_iconVs];
        // [self.MyacceptChallengeImageView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveImageUrl"]] placeholderImage:[UIImage imageNamed:@"PlaceholderImageWithoutBorder"]];
        //[self.MyNameLabel setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserName"]];
        waitCD24 = 24;
        waitTimer24 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(time24) userInfo:nil repeats:YES];

    }
    else if (_isAccept)
    {
        _isAccept = NO;
        NSLog(@"isAccept");
        [_belowView addSubview:_userInfoView];
        [_upperView addSubview:_joinGame];
        [_joinGame addSubview:_backButtonLeft];
        [_joinGame addSubview:_logo];
        _statusLabel.text = @"already played";
        _labelShifly.text = @"Before Challenge expires!";

        joinTimer24 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(joinTime) userInfo:nil repeats:YES];
        [self.AcceptChallengeView setHidden:NO];
        [self acceptChallenge];

    } else {
        NSLog(@"robot");
        _rotateBall = [[UIImageView alloc] initWithFrame:CGRectMake(-kScreenWidth / 2 - 10, 0, kScreenWidth * 2, kScreenWidth - 40)];
        [self animateWithAnimationView:_rotateBall];
        [_belowView addSubview:_rotateBall];
        [_belowView addSubview:_loading];
        [self.view addSubview:_iconVs];
        [_upperView addSubview:_userInfoView];
        secondsCD5 = 9;
        CDTimer5 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    }
    [self getQuestions];
}

#pragma mark - Battle the computer last five seconds
- (void)acceptChallenge {
    NSString *userId = [LanbaooPrefs sharedInstance].userId;

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters = @{
            @"command" : @"accept_challenge",
            @"uid" : userId,
            @"fid" : @(self.friendId)
    };
    [manager GET:kServerURL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             NSDictionary *data = responseObject;
             UserInfo *userInfo = [UserInfo objectWithKeyValues:data[@"data"]];
               [self.UseracceptChallengeImageView sd_setImageWithURL:[NSURL URLWithString:[userInfo valueForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"PlaceholderImageWithoutBorder"]];
             [self.UserNameLabel setText:[NSString stringWithFormat:@"%@ %@",userInfo.firstname,userInfo.lastname]];
             

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
}

#pragma mark - 对战电脑最后五秒

//5s timer
- (void)timeFireMethod {
    secondsCD5--;
    if (secondsCD5 <= 5 && secondsCD5 > 0) {
        _countdownView.hidden = NO;
        _loading.hidden = YES;
        _rotateBall.hidden = YES;

        [_belowView addSubview:_oppInfoView];
        int seconds = secondsCD5 % 60;
        NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
        [_labelCountdown setText:strTime];
    }
    if (secondsCD5 == 0) {
        [CDTimer5 invalidate];
        [_labelCountdown setText:@"00"];
        [self timeOver];
    }
}

//5 seconds count up
- (void)timeOver {
    if ([[CMOpenALSoundManager singleton] isBackGroundMusicPlaying]) {
        [[CMOpenALSoundManager singleton] stopBackgroundMusic];
    }
    _rotateBall.animationImages = nil;
    MyFightViewController *random = [[MyFightViewController alloc] init];
    if (_botModel) {
        NSString *name = [NSString stringWithFormat:@"%@ %@", _botModel.firstName, _botModel.lastName];
        random.opponentName = name;
    }
    [self.navigationController pushViewController:random animated:YES];
}

#pragma mark - Players play against the last five seconds chronograph

- (void)doubleTimeFireMethod {
    secondsCD5--;
    if (secondsCD5 <= 5 && secondsCD5 > 0) {
        _countdownView.hidden = NO;
        _loading.hidden = YES;
        _rotateBall.hidden = YES;

        int seconds = secondsCD5 % 60;
        NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
        [_labelCountdown setText:strTime];
    }
    if (secondsCD5 == 0) {
        [CDTimer5 invalidate];
        [_labelCountdown setText:@"00"];
        [self doubleTimeOver];
    }
}

- (void)doubleTimeOver {
    if ([[CMOpenALSoundManager singleton] isBackGroundMusicPlaying]) {
        [[CMOpenALSoundManager singleton] stopBackgroundMusic];
    }
    _rotateBall.animationImages = nil;

    if ([ETGlobal sharedGlobal].allQuizs.count > 0) {

    } else {
        [self showHit:@"no questions"];
        WS(weakSelf)
        int64_t delayInSeconds = 3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        });
        return;
    }

    MyFightViewController *player = [[MyFightViewController alloc] init];
    player.fid = _friendId;
    if (self.friendModel) {
        NSString *name = [NSString stringWithFormat:@"%@ %@", _friendModel.firstname, _friendModel.lastname];
        player.opponentName = name;
        player.oppAvatar = _friendModel.avatar;
    }
    [self.navigationController pushViewController:player animated:YES];
}


//24 seconds count up
- (void)time24 {
    waitCD24--;
    int seconds = waitCD24 % 60;
    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
    [_countDown24 setText:strTime];
    if (waitCD24 == 0) {
        [waitTimer24 invalidate];
        [_waiting setHidden:YES];
        [_belowView addSubview:_keepWaiting];
    }
}

- (void)joinTime {
    _joinCD24--;
    int seconds = _joinCD24 % 60;
    if (seconds < 0) {
        seconds = 0;
    }
    NSString *strTime = [NSString stringWithFormat:@":%.2d", seconds];
    [_joinTimeLabel setText:strTime];
    if (_joinCD24 <= 0) {
        [joinTimer24 invalidate];
//        canJoinGame = NO;
        [_backButtonLeft setHidden:YES];
        [_logo setHidden:YES];
        [_joinGame addSubview:_backButtonRight];
        _nameLabel.textColor = [UIColor whiteColor];
        _statusLabel.text = @"CHALLENGES YOU!";
        _statusLabel.textColor = kMyRedColor;
        _labelShifly.text = @"Before Live Gameplay expires!";
    }
}

- (void)toJoinGame {
    if (canJoinGame) {
        [joinTimer24 invalidate];
        NSInteger userId = [LanbaooPrefs sharedInstance].userId.intValue;
        PushBean *pushBean = [[PushBean alloc] init];
        pushBean.uid = @(userId).stringValue;
        pushBean.toUid = @(_friendId).stringValue;
        pushBean.action = @"begin";
        if ([MySocket singleton].sRWebSocket.readyState == SR_OPEN) {
            [[MySocket singleton].sRWebSocket send:pushBean.JSONString];
            [_joinGame setHidden:YES];
            [_upperView addSubview:_oppInfoView];
            secondsCD5 = 5;
            CDTimer5 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doubleTimeFireMethod) userInfo:nil repeats:YES];
        }
    } else {
        NSLog(@"time out");
    }
}

- (void)toBeginGame {

    if ([ETGlobal sharedGlobal].allQuizs.count > 0) {
        MyFightViewController *random = [[MyFightViewController alloc] init];
        random.fid = _friendId;
        [self.navigationController pushViewController:random animated:YES];
    } else {
        [self showHit:@"no questions"];
        WS(weakSelf)
        int64_t delayInSeconds = 3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        });
        return;
    }
}

//The challenge of information received
- (void)didReceiveMessage:(NSNotification *)notification {
    NSString *message = [notification object];
    PushBean *pushBean = [PushBean objectWithKeyValues:message];
    if (pushBean) {
        NSString *action = pushBean.action;
        if (action.length > 0 && [action isEqualToString:@"begin"]) {
            [waitTimer24 invalidate];
            [_waiting setHidden:YES];
            [_belowView addSubview:_oppInfoView];
            secondsCD5 = 5;
            CDTimer5 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doubleTimeFireMethod) userInfo:nil repeats:YES];
        }
    }
}

#pragma mark - rotating_ball Animation

- (void)animateWithAnimationView:(UIImageView *)animationView {

    NSMutableArray *animationImages = [NSMutableArray array];
    int maxIndex = 46;
    for (int i = 0; i <= maxIndex; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%@%02d@2x", @"rotating_ball_", i];

        UIImage *image = [UIImage imageNamed:imageName];

        [animationImages addObject:image];
    }
    [animationView setAnimationImages:animationImages];
    [animationView setAnimationDuration:animationView.animationImages.count * 0.05];
    [animationView setAnimationRepeatCount:0];
    [animationView startAnimating];
}

- (void)getQuestions {
    NSString *command;
    if (!_friendId) {
        command = @"get_random_quiz";

    } else {
        command = @"get_friend_quiz";
    }

    NSLog(@"\nnow command:%@\n", command);
    [ETGlobal sharedGlobal].allQuizs = [NSMutableArray array];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
            @"command" : command,
            @"date" : [[NSDate new] getDateStrWithFormat:kDateFormat]
    };
    [manager GET:kServerURL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//             NSLog(@"JSON: %@", responseObject);
             [self hideHUD];
             [QuestionModels map];

             NSMutableArray *arrayDic = [responseObject objectForKey:@"data"];
             [ETGlobal sharedGlobal].allQuizs = [QuestionModels objectArrayWithKeyValuesArray:arrayDic];
//             [self beginGame];

             if ([ETGlobal sharedGlobal].allQuizs.count > 0) {

             } else {
                 [self showHit:@"no questions"];
                 WS(weakSelf)
                 int64_t delayInSeconds = 3;
                 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                 dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                     [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                 });
                 return;
             }

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [self getQuestions];
            }];
}

-(void)UIAcceptChallenge{
    
    self.AcceptChallengeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.AcceptChallengeView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"AcceptChallengeScreen"]]];
    [self.view addSubview:self.AcceptChallengeView];
    [self.AcceptChallengeView setHidden:YES];
    
    self.MyacceptChallengeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(31, 49, 70, 70)];
    [self.MyacceptChallengeImageView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveImageUrl"]] placeholderImage:[UIImage imageNamed:@""]];
    [[self.MyacceptChallengeImageView layer] setCornerRadius:self.MyacceptChallengeImageView.frame.size.width/2];
    [self.MyacceptChallengeImageView setClipsToBounds:YES];
    [self.AcceptChallengeView addSubview:self.MyacceptChallengeImageView];
    
    
    self.UseracceptChallengeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(219, 49, 70, 70)];
    [[self.UseracceptChallengeImageView layer] setCornerRadius:self.MyacceptChallengeImageView.frame.size.width/2];
    [self.UseracceptChallengeImageView setClipsToBounds:YES];
    [self.AcceptChallengeView addSubview:self.UseracceptChallengeImageView];

    self.MyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 120, 30)];
    [self.MyNameLabel setTextColor:[UIColor whiteColor]];
    [self.MyNameLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14.0]];
    [self.MyNameLabel setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserName"]];
    [self.MyNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.AcceptChallengeView addSubview:self.MyNameLabel];
    
    
    self.UserNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 80, 120, 30)];
    //[DayLabel setText:[NSString stringWithFormat:@"Day %ld/7", (long) [componets weekday]]];
    [self.UserNameLabel setTextColor:[UIColor whiteColor]];
    [self.UserNameLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14.0]];
    [self.UserNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.AcceptChallengeView addSubview:self.UserNameLabel];
    

    UIImageView *SelfRate1 = [[UIImageView alloc] initWithFrame:CGRectMake(31, 150, 12, 11)];
    [SelfRate1 setImage:[UIImage imageNamed:@"Unstar"]];
    [self.AcceptChallengeView addSubview:SelfRate1];
    
    UIImageView *SelfRate2 = [[UIImageView alloc] initWithFrame:CGRectMake(44, 150, 12, 11)];
    [SelfRate2 setImage:[UIImage imageNamed:@"Unstar"]];
    [self.AcceptChallengeView addSubview:SelfRate2];
    
    UIImageView *SelfRate3 = [[UIImageView alloc] initWithFrame:CGRectMake(57, 150, 12, 11)];
    [SelfRate3 setImage:[UIImage imageNamed:@"Unstar"]];
    [self.AcceptChallengeView addSubview:SelfRate3];
    
    UIImageView *SelfRate4 = [[UIImageView alloc] initWithFrame:CGRectMake(70, 150, 12, 11)];
    [SelfRate4 setImage:[UIImage imageNamed:@"Unstar"]];
    [self.AcceptChallengeView addSubview:SelfRate4];
    
    UIImageView *SelfRate5 = [[UIImageView alloc] initWithFrame:CGRectMake(83, 150, 12, 11)];
    [SelfRate5 setImage:[UIImage imageNamed:@"Unstar"]];
    [self.AcceptChallengeView addSubview:SelfRate5];
    
    if ([self.stringMyLevel intValue]>0 && [self.stringMyLevel intValue]<= 4)
    {
       
        [SelfRate1 setImage:[UIImage imageNamed:@"StarIcon"]];
    }
    else if ([self.stringMyLevel intValue]>4 && [self.stringMyLevel intValue]<= 24)
    {

        [SelfRate1 setImage:[UIImage imageNamed:@"StarIcon"]];
        [SelfRate2 setImage:[UIImage imageNamed:@"StarIcon"]];
        
    }
    else if ([self.stringMyLevel intValue]>24 && [self.stringMyLevel intValue]<= 74){

        [SelfRate1 setImage:[UIImage imageNamed:@"StarIcon"]];
        [SelfRate2 setImage:[UIImage imageNamed:@"StarIcon"]];
        [SelfRate3 setImage:[UIImage imageNamed:@"StarIcon"]];
        
    }
    else if ([self.stringMyLevel intValue]>74 && [self.stringMyLevel intValue]<= 124){

        [SelfRate1 setImage:[UIImage imageNamed:@"StarIcon"]];
        [SelfRate2 setImage:[UIImage imageNamed:@"StarIcon"]];
        [SelfRate3 setImage:[UIImage imageNamed:@"StarIcon"]];
        [SelfRate4 setImage:[UIImage imageNamed:@"StarIcon"]];
        
    }
    else if ([self.stringMyLevel intValue]>124){

        [SelfRate1 setImage:[UIImage imageNamed:@"StarIcon"]];
        [SelfRate2 setImage:[UIImage imageNamed:@"StarIcon"]];
        [SelfRate3 setImage:[UIImage imageNamed:@"StarIcon"]];
        [SelfRate4 setImage:[UIImage imageNamed:@"StarIcon"]];
        [SelfRate5 setImage:[UIImage imageNamed:@"StarIcon"]];
    }
    
    UILabel *laebelPointMy = [[UILabel alloc] initWithFrame:CGRectMake(0, 254, 140, 30)];
    [laebelPointMy setText:@"Points"];
    [laebelPointMy setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10.0]];
    [laebelPointMy setTextColor:[UIColor whiteColor]];
    [laebelPointMy setTextAlignment:NSTextAlignmentCenter];
    [self.AcceptChallengeView addSubview:laebelPointMy];
    
    UILabel *laebelPointValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 224, 80, 30)];
    [laebelPointValue setText:self.stringmypoints];
    [laebelPointValue setTextAlignment:NSTextAlignmentCenter];
    [laebelPointValue setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14.0]];
    [laebelPointValue setTextColor:[UIColor whiteColor]];
    [laebelPointValue setBackgroundColor:[UIColor clearColor]];
    [self.AcceptChallengeView addSubview:laebelPointValue];
    
    
    UILabel *laebelPointMuser = [[UILabel alloc] initWithFrame:CGRectMake(178, 254, 140, 30)];
    [laebelPointMuser setText:@"Points"];
    [laebelPointMuser setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10.0]];
    [laebelPointMuser setTextColor:[UIColor whiteColor]];
    [laebelPointMuser setTextAlignment:NSTextAlignmentCenter];
    [self.AcceptChallengeView addSubview:laebelPointMuser];

    
    self.laebelPointUserValue = [[UILabel alloc] initWithFrame:CGRectMake(178, 224, 140, 30)];
    [self.laebelPointUserValue setText:@"0"];
    [self.laebelPointUserValue setTextAlignment:NSTextAlignmentCenter];
    [self.laebelPointUserValue setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14.0]];
    [self.laebelPointUserValue setTextColor:[UIColor whiteColor]];
    [self.laebelPointUserValue setBackgroundColor:[UIColor clearColor]];
    [self.AcceptChallengeView addSubview:self.laebelPointUserValue];
    
    
    UILabel *laebelPPGMy = [[UILabel alloc] initWithFrame:CGRectMake(0, 337, 140, 30)];
    [laebelPPGMy setText:@"PPG"];
    [laebelPPGMy setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10.0]];
    [laebelPPGMy setTextColor:[UIColor whiteColor]];
    [laebelPPGMy setTextAlignment:NSTextAlignmentCenter];
    [self.AcceptChallengeView addSubview:laebelPPGMy];
    
    UILabel *laebelPPgValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 310, 140, 30)];
    [laebelPPgValue setText:self.stringMyPPG];
    [laebelPPgValue setTextAlignment:NSTextAlignmentCenter];
    [laebelPPgValue setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14.0]];
    [laebelPPgValue setTextColor:[UIColor whiteColor]];
    [laebelPPgValue setBackgroundColor:[UIColor clearColor]];
    [self.AcceptChallengeView addSubview:laebelPPgValue];
    
    
    UILabel *laebelPPGUser = [[UILabel alloc] initWithFrame:CGRectMake(178, 337, 140, 30)];
    [laebelPPGUser setText:@"PPG"];
    [laebelPPGUser setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10.0]];
    [laebelPPGUser setTextColor:[UIColor whiteColor]];
    [laebelPPGUser setTextAlignment:NSTextAlignmentCenter];
    [self.AcceptChallengeView addSubview:laebelPPGUser];
    
    
    self.laebelPPgUserValue = [[UILabel alloc] initWithFrame:CGRectMake(178, 310, 140, 30)];
    [self.laebelPPgUserValue setText:@""];
    [self.laebelPPgUserValue setTextAlignment:NSTextAlignmentCenter];
    [self.laebelPPgUserValue setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14.0]];
    [self.laebelPPgUserValue setTextColor:[UIColor whiteColor]];
    [self.laebelPPgUserValue setBackgroundColor:[UIColor clearColor]];
    [self.AcceptChallengeView addSubview:self.laebelPPgUserValue];
    
    

    UILabel *laebelWl = [[UILabel alloc] initWithFrame:CGRectMake(0, 420, 140, 30)];
    [laebelWl setText:@"W-L"];
    [laebelWl setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10.0]];
    [laebelWl setTextColor:[UIColor whiteColor]];
    // [laebelWl setTextAlignment:NSTextAlignmentCenter];
    [self.AcceptChallengeView addSubview:laebelWl];
    
    UILabel *laebelWLValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 393, 140, 30)];
    [laebelWLValue setText:self.StringMyWinLoss];
    [laebelWLValue setTextAlignment:NSTextAlignmentCenter];
    [laebelWLValue setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14.0]];
    [laebelWLValue setTextColor:[UIColor whiteColor]];
    [laebelWLValue setBackgroundColor:[UIColor clearColor]];
    [self.AcceptChallengeView addSubview:laebelWLValue];
    
    UILabel *laebelWlUser = [[UILabel alloc] initWithFrame:CGRectMake(178, 420, 140, 30)];
    [laebelWlUser setText:@"W-L"];
    [laebelWlUser setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10.0]];
    [laebelWlUser setTextColor:[UIColor whiteColor]];
    // [laebelWl setTextAlignment:NSTextAlignmentCenter];
    [self.AcceptChallengeView addSubview:laebelWlUser];
    
    
    self.laebelWLValueUser = [[UILabel alloc] initWithFrame:CGRectMake(178, 393, 140, 30)];
    [self.laebelWLValueUser setText:@""];
    [self.laebelWLValueUser setTextAlignment:NSTextAlignmentCenter];
    [self.laebelWLValueUser setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14.0]];
    [self.laebelWLValueUser setTextColor:[UIColor whiteColor]];
    [self.laebelWLValueUser setBackgroundColor:[UIColor clearColor]];
    [self.AcceptChallengeView addSubview:self.laebelWLValueUser];
    
    
    UILabel *laebelRankMy = [[UILabel alloc] initWithFrame:CGRectMake(0, 503, 140, 30)];
    [laebelRankMy setText:@"Rank"];
    [laebelRankMy setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10.0]];
    [laebelRankMy setTextColor:[UIColor whiteColor]];
    [laebelRankMy setTextAlignment:NSTextAlignmentCenter];
    [self.AcceptChallengeView addSubview:laebelRankMy];
    
    
    UILabel *laebelRankMyValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 477, 140, 30)];
    [laebelRankMyValue setText:self.stringMyRank];
    [laebelRankMyValue setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10.0]];
    [laebelRankMyValue setTextColor:[UIColor whiteColor]];
    [laebelRankMyValue setTextAlignment:NSTextAlignmentCenter];
    [self.AcceptChallengeView addSubview:laebelRankMyValue];
    
    UILabel *laebelRankuser = [[UILabel alloc] initWithFrame:CGRectMake(178, 503, 140, 30)];
    [laebelRankuser setText:@"Rank"];
    [laebelRankuser setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10.0]];
    [laebelRankuser setTextColor:[UIColor whiteColor]];
    [laebelRankuser setTextAlignment:NSTextAlignmentCenter];
    [self.AcceptChallengeView addSubview:laebelRankuser];
    
    self.laebelRankUserValue = [[UILabel alloc] initWithFrame:CGRectMake(178, 477, 140, 30)];
    [self.laebelRankUserValue setText:@""];
    [self.laebelRankUserValue setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10.0]];
    [self.laebelRankUserValue setTextColor:[UIColor whiteColor]];
    [self.laebelRankUserValue setTextAlignment:NSTextAlignmentCenter];
    [self.AcceptChallengeView addSubview:self.laebelRankUserValue];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
