//
//  HomeViewController.m
//  fancard
//  main interface

//  Created by MEETStudio on 15-8-27.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "HomeViewController.h"
#import "Mconfig.h"
#import "UIFactory.h"
#import "SettingsViewController.h"
#import "LeaderViewController.h"
#import "VSInfoViewController.h"
#import "UIViewExt.h"
#import "LevelsViewController.h"
#import "LogInViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "UIView+Round.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <LKDBHelper/NSObject+LKDBHelper.h>
#import "CMOpenALSoundManager.h"
#import "CMOpenALSoundManager+Singleton.h"
#import "WelcomeViewController.h"
#import "NSDate+FormatDateString.h"
#import "NSString+StringFormatDate.h"
#import "MySocket.h"
#import "UserInfo.h"
#import "LanbaooPrefs.h"
#import "LevelsFindFriendViewController.h"
#import "NSDictionary+NotNULL.h"

@interface HomeViewController () {
    UIImageView *_homeScreen;
    UIButton *_settingsBtn;
    UIButton *_FindFriend;

    UIButton *_VSRandom;
    UIButton *_VSFriend;
    UIButton *_LeaderBoard;

    UIButton *_Level;
//------------------------------------------
    UIView *_box;                //Intermediate user information board

    UIView *_pointView;
    UILabel *_pointsLabel;
    UILabel *_pointNumLb;

    UIView *_perView;
    UILabel *_perLabel;
    UILabel *_perNumLb;

    UIView *_rankView;
    UILabel *_rankLabel;
    UILabel *_rankNumlb;

    UIView *_wonLostView;
    UILabel *_wonLostLabel;
    UILabel *_wlNumLb;

    UIView *_clockView;
    UILabel *_whatDay;           //what day is today
    UILabel *_systemTime;
    UILabel *_userNameLb;
    CWStarRateView *_myStarRateView;

    UIImageView *_avatar;
//--------------------------------------------
    NSString *user;
    BotModel *botModel;
    NSMutableArray *challengerArr; //

    GetChallenge *chaView;         //tableView
    NSTimer *m_pTimer;
    NSDate *m_pStartDate;
    NSDate *newDate;
    double oddTime;

    NSString *beanTime;
}

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //Turn on the left slide right slide menu
    [self.appDelegate.menuCtrl setEnableGesture:YES];

    if (![LanbaooPrefs sharedInstance].musicOff) {
        [[CMOpenALSoundManager singleton] playBackgroundMusic:@"Mind-Gym-Main.mp3"];
    }

    if ([LanbaooPrefs sharedInstance].userId.intValue == 0) {
        [self welcomePage];
    }

    [self refreshInfo];
    [self getUserInfo];
    [self getChallenger];
}

- (void)refreshInfo {

    user = [LanbaooPrefs sharedInstance].userName;
    NSInteger botId = [LanbaooPrefs sharedInstance].botId;

    UserInfo *userInfo = [UserInfo searchSingleWithWhere:nil orderBy:nil];

    NSInteger winNum = userInfo.number_win;
    NSInteger lostNum = userInfo.number_lost;
    NSInteger todayPoints = userInfo.points_week;
    NSString *userName = [NSString stringWithFormat:@"%@ %@", userInfo.firstname, userInfo.lastname];
    NSInteger totalPoints = userInfo.points_total;
    NSString *avatar = userInfo.avatar;
    int rank = (int) [LanbaooPrefs sharedInstance].rank;
    NSLog(@"#######photo:%@\n", avatar);
    float per = 0;
    if ((winNum + lostNum) != 0) {
        per = (float) totalPoints / userInfo.totalCount;
    }
    NSString *userId = [LanbaooPrefs sharedInstance].userId;
    NSLog(@"\nuserId:%@\nuserName:%@\ntoday:%i\ntotal:%ld\nwinNum:%ld\nlostNum:%ld\nper:%.1f", userId, userName, todayPoints, (long) totalPoints, (long) winNum, (long) lostNum, per);
    [_pointNumLb setText:[NSString stringWithFormat:@"%i", todayPoints]];
    [_userNameLb setText:userName];
    [_perNumLb setText:[NSString stringWithFormat:@"%.1f", per]];
    [_wlNumLb setText:[NSString stringWithFormat:@"%i-%i", winNum, lostNum]];
    _rankNumlb.text = [NSString stringWithFormat:@"%d", rank];
//    NSInteger win = [[NSUserDefaults standardUserDefaults] integerForKey:kWinNum];
    [_myStarRateView level:winNum];
    NSLog(@"#######photo:%@", avatar);
    if (avatar) {
        [_avatar sd_setImageWithURL:[NSURL URLWithString:avatar]];
    } else {
        _avatar.image = [UIImage imageNamed:@""];
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //Disable slide right slide left menu
    [self.appDelegate.menuCtrl setEnableGesture:NO];
    [[CMOpenALSoundManager singleton] purgeSounds];
}

//The challenge of information received
- (void)didReceiveMessage:(NSNotification *)notification {
    NSString *message = [notification object];
    PushBean *pushBean = [PushBean objectWithKeyValues:message];
    if (pushBean) {
        NSString *action = pushBean.action;
        if (action.length > 0 && [action isEqualToString:@"challenge"]) {
            if ([CMOpenALSoundManager singleton]) {
                [[CMOpenALSoundManager singleton] playSoundWithID:8];
            }
            beanTime = pushBean.pushTime;
            NSLog(@"##beanTime:%@", beanTime);
//            Challenger *challenger = [[Challenger alloc] init];
//            challenger.fid = pushBean.uid.intValue;
//            challenger.userName = pushBean.userName;
//            challenger.avatar = pushBean.avatar;

            UserInfo *userInfo = pushBean.userInfo;

            if (!challengerArr) {
                challengerArr = [[NSMutableArray alloc] init];
            }
            if (userInfo) {
                [challengerArr addObject:userInfo];
                if (challengerArr && challengerArr.count > 0) {
                    chaView.hidden = NO;
                }
            }

            [chaView setInfo:challengerArr];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [LanbaooPrefs sharedInstance].challengerId = nil;

    //main background
    _homeScreen = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];

    _homeScreen.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pic_bg_home" ofType:@"png"]];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_homeScreen];

    //setting button
    CGRect settingsBtnFrame = CGRectMake(5, 10, 35, 40);
    _settingsBtn = [UIFactory createButtonWithFrame:settingsBtnFrame
                                              Title:@""
                                             Target:self
                                           Selector:@selector(settingsBtnClick)];

    _settingsBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_settingsBtn];

    //find friends
    _FindFriend = [UIFactory createButtonWithFrame:CGRectMake((kScreenWidth - 40), 10, 35, 40)
                                             Title:@""
                                            Target:self
                                          Selector:@selector(findFriendBtnClick)];
    _FindFriend.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_FindFriend];

    [self _userInfoBoad];  //user info

    _Level = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 50, _box.bottom + 10, 100, 40)];
    _Level.backgroundColor = [UIColor clearColor];
    [_Level addTarget:self action:@selector(level) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_Level];

    [self _belowButtons];  //game button

    chaView = [[GetChallenge alloc] initWithFrame:CGRectMake(5, _VSRandom.top - 25 - 165, kScreenWidth - 10, 165)];
    chaView.reDelegate = self;
    chaView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:chaView];
    chaView.hidden = YES;

}

- (void)welcomePage {
    WelcomeViewController *welcome = [[WelcomeViewController alloc] init];
    welcome.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:welcome];
    [self presentViewController:navCtrl animated:NO completion:nil];
}

#pragma mark - responseDelegate

- (void)responseChallenge:(UserInfo *)userInfo {
    self.fid = userInfo.id.intValue;

    challengerArr = [[NSMutableArray alloc] init];
    chaView.hidden = YES;
    [self sendAcceptChallengeMessage:userInfo];
}

- (void)sendAcceptChallengeMessage:(UserInfo *)userInfo {
    if ([MySocket singleton].sRWebSocket.readyState == SR_OPEN) {

        NSString *userId = [LanbaooPrefs sharedInstance].userId;

        PushBean *pushBean = [[PushBean alloc] init];
        pushBean.uid = userId;
        pushBean.toUid = @(_fid).stringValue;
        pushBean.action = @"accept";

        NSDate *date = [beanTime getDateWithFormat:kDateFormat];
        NSLog(@"sendAcceptChallengeMessage:date=%@", date);
        NSDate *date2 = [[NSDate new] dateByAddingTimeInterval:[LanbaooPrefs sharedInstance].gapTime];
        NSLog(@"sendAcceptChallengeMessage:date2=%@", date2);
        double seconds = [date2 timeIntervalSinceDate:date];
        NSLog(@"seconds%d", (int) seconds);
        pushBean.pushTime = [[NSDate new] getDateStrWithFormat:kDateFormat];
        [[MySocket singleton].sRWebSocket send:pushBean.JSONString];
        VSInfoViewController *vsCtrl = [[VSInfoViewController alloc] init];
        vsCtrl.joinCD24 = 24 - (int) seconds;
        vsCtrl.isAccept = YES;
        vsCtrl.friendId = _fid;
        vsCtrl.friendModel = userInfo;
        [self.navigationController pushViewController:vsCtrl animated:YES];
    }
}

#pragma mark - userInfoBoad

- (void)_userInfoBoad

{
    CGFloat boxHeight = 60.0f;

    if (iPhone6Plus) {
        boxHeight = 80.0f;
    }
    if (iPhone6) {
        boxHeight = 70.0f;
    }
    if (iPhone5) {
        boxHeight = 65.0f;
    }

    _box = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 100, boxHeight, 200, 122)];
    _box.backgroundColor = [UIColor redColor];
    [self.view addSubview:_box];

//    [_box autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:60.0f];
//    [_box autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:90.0f];
//    [_box autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:90.0f];
//    [_box autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:_box withMultiplier:0.8f];

//top left points
    _pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 68, 65)];
    _pointView.backgroundColor = [UIColor colorWithRed:162 / 255.0 green:10 / 255.0 blue:21 / 255.0 alpha:1.0f];
    [_box addSubview:_pointView];
    _pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 4, 60, 10)];
    _pointsLabel.backgroundColor = [UIColor whiteColor];
    [_pointsLabel.layer setMasksToBounds:YES];
    [_pointsLabel.layer setCornerRadius:3.0f];
    _pointsLabel.text = @"POINTS";
    _pointsLabel.textColor = [UIColor colorWithRed:162 / 255.0 green:10 / 255.0 blue:21 / 255.0 alpha:1.0f];
    _pointsLabel.font = [UIFont systemFontOfSize:8.0f];
    _pointsLabel.textAlignment = NSTextAlignmentCenter;
    [_pointView addSubview:_pointsLabel];
    _pointNumLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, 68, 51)];
    _pointNumLb.backgroundColor = [UIColor clearColor];
    _pointNumLb.textColor = [UIColor whiteColor];
    _pointNumLb.textAlignment = NSTextAlignmentCenter;
    _pointNumLb.font = [UIFont boldSystemFontOfSize:35.0f];
    _pointNumLb.adjustsFontSizeToFitWidth = YES;
    _pointNumLb.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [_pointView addSubview:_pointNumLb];
//left bottom points per game
    _perView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, 73, 57)];
    _perView.backgroundColor = [UIColor whiteColor];
    [_box addSubview:_perView];
    _perLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 8, 61, 10)];
    _perLabel.backgroundColor = [UIColor colorWithRed:162 / 255.0 green:10 / 255.0 blue:21 / 255.0 alpha:1.0f];
    [_perLabel.layer setMasksToBounds:YES];
    [_perLabel.layer setCornerRadius:3.0f];
    _perLabel.text = @"POINTS PER GAME";
    _perLabel.textColor = [UIColor whiteColor];
    _perLabel.font = [UIFont boldSystemFontOfSize:6.0f];
    _perLabel.textAlignment = NSTextAlignmentCenter;
    [_perView addSubview:_perLabel];
    _perNumLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, 73, 39)];
    _perNumLb.backgroundColor = [UIColor clearColor];
    _perNumLb.textColor = [UIColor colorWithRed:162 / 255.0 green:10 / 255.0 blue:21 / 255.0 alpha:1.0f];
    _perNumLb.textAlignment = NSTextAlignmentCenter;
    _perNumLb.font = [UIFont boldSystemFontOfSize:32.0f];
    _perNumLb.adjustsFontSizeToFitWidth = YES;
    _perNumLb.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [_perView addSubview:_perNumLb];
//top right rank
    _rankView = [[UIView alloc] initWithFrame:CGRectMake(_box.width - 68, 0, 68, 65)];
    _rankView.backgroundColor = [UIColor colorWithRed:27 / 255.0f green:10 / 255.0 blue:1 alpha:1.0f];
    [_box addSubview:_rankView];
    _rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 4, 60, 10)];
    _rankLabel.backgroundColor = [UIColor whiteColor];
    [_rankLabel.layer setMasksToBounds:YES];
    [_rankLabel.layer setCornerRadius:3.0f];
    _rankLabel.text = @"RANK";
    _rankLabel.textColor = [UIColor colorWithRed:27 / 255.0f green:10 / 255.0 blue:1 alpha:1.0f];
    _rankLabel.font = [UIFont systemFontOfSize:8.0f];
    _rankLabel.textAlignment = NSTextAlignmentCenter;
    [_rankView addSubview:_rankLabel];
    _rankNumlb = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, 68, 51)];
    _rankNumlb.backgroundColor = [UIColor clearColor];
    _rankNumlb.textColor = [UIColor whiteColor];
    _rankNumlb.textAlignment = NSTextAlignmentCenter;
    _rankNumlb.font = [UIFont boldSystemFontOfSize:35.0f];
    _rankNumlb.adjustsFontSizeToFitWidth = YES;
    _rankNumlb.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [_rankView addSubview:_rankNumlb];
//right bottom won - lost
    _wonLostView = [[UIView alloc] initWithFrame:CGRectMake(_box.width - 73, 65, 73, 57)];
    _wonLostView.backgroundColor = [UIColor whiteColor];
    [_box addSubview:_wonLostView];
    _wonLostLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 8, 61, 10)];
    _wonLostLabel.backgroundColor = [UIColor colorWithRed:27 / 255.0f green:10 / 255.0 blue:1 alpha:1.0f];
    [_wonLostLabel.layer setMasksToBounds:YES];
    [_wonLostLabel.layer setCornerRadius:3.0f];
    _wonLostLabel.text = @"WON - LOST";
    _wonLostLabel.textColor = [UIColor whiteColor];
    _wonLostLabel.font = [UIFont boldSystemFontOfSize:6.0f];
    _wonLostLabel.textAlignment = NSTextAlignmentCenter;
    [_wonLostView addSubview:_wonLostLabel];
    _wlNumLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, 73, 39)];
    _wlNumLb.backgroundColor = [UIColor clearColor];
    _wlNumLb.textColor = [UIColor colorWithRed:27 / 255.0f green:10 / 255.0 blue:1 alpha:1.0f];
    _wlNumLb.textAlignment = NSTextAlignmentCenter;
    _wlNumLb.font = [UIFont boldSystemFontOfSize:32.0f];
    _wlNumLb.adjustsFontSizeToFitWidth = YES;
    _wlNumLb.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [_wonLostView addSubview:_wlNumLb];

    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(68, 0, 64, 70)];
    backgroundView.backgroundColor = [UIColor colorWithRed:38 / 255.0 green:39 / 255.0 blue:40 / 255.0 alpha:1.0f];
    [backgroundView roundBottomCornersRadius:6.0f];
    [_box addSubview:backgroundView];

//display time
    _clockView = [[UIView alloc] initWithFrame:CGRectMake(68, 0, 64, 70)];
    _clockView.backgroundColor = [UIColor clearColor];
    [_box addSubview:_clockView];
    _whatDay = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 64, 18)];
    _whatDay.backgroundColor = [UIColor clearColor];

    NSDate *date = [NSDate date];
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
    _whatDay.text = [NSString stringWithFormat:@"Day %ld/7", (long) [componets weekday]];
    _whatDay.textColor = [UIColor whiteColor];
    _whatDay.font = [UIFont boldSystemFontOfSize:11.0f];
    _whatDay.textAlignment = NSTextAlignmentCenter;
    [_clockView addSubview:_whatDay];
    _systemTime = [[UILabel alloc] initWithFrame:CGRectMake(-4, 18, 72, 25)];
    [_systemTime.layer setMasksToBounds:YES];
    [_systemTime.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [_systemTime.layer setBorderWidth:1.5f];
    _systemTime.backgroundColor = [UIColor blackColor];
    _systemTime.font = [UIFont fontWithName:kDigitalFont size:16.0f];
    _systemTime.textAlignment = NSTextAlignmentCenter;
    _systemTime.textColor = [UIColor yellowColor];
    [_clockView addSubview:_systemTime];

    m_pTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                target:self
                                              selector:@selector(calcuRemainTime)
                                              userInfo:nil
                                               repeats:YES];
    m_pStartDate = [NSDate date];
    NSLog(@"%@", m_pStartDate);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:m_pStartDate];

    components.day += 1;
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    newDate = [calendar dateFromComponents:components];
    oddTime = [newDate timeIntervalSinceDate:m_pStartDate];      //24:00 remaining time from the current time

    _userNameLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 64, 12)];
    _userNameLb.backgroundColor = [UIColor clearColor];
    _userNameLb.textColor = [UIColor whiteColor];
    _userNameLb.font = [UIFont boldSystemFontOfSize:10.0f];
    _userNameLb.adjustsFontSizeToFitWidth = YES;
    _userNameLb.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _userNameLb.textAlignment = NSTextAlignmentCenter;
    [_clockView addSubview:_userNameLb];
    //star level
    _myStarRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(3, 58, 58, 8) numberOfStars:5];
    _myStarRateView.backgroundColor = [UIColor clearColor];
    _myStarRateView.scorePercent = 0;
    _myStarRateView.allowIncompleteStar = NO;
    _myStarRateView.hasAnimation = NO;
    [_clockView addSubview:_myStarRateView];

    _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(73, 70, 54, 52)];
    _avatar.clipsToBounds = YES;
    _avatar.contentMode = UIViewContentModeScaleAspectFill;
    _avatar.backgroundColor = [UIColor colorWithRed:4 / 255.0 green:4 / 255.0 blue:4 / 255.0 alpha:1.0f];
    [_box addSubview:_avatar];
    
    _avatar.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updatePhotoPressed)];
    [_avatar addGestureRecognizer:singleTap];

}

#pragma mark - Calculate the remaining time

- (void)calcuRemainTime {
    double deltaTime = [[NSDate date] timeIntervalSinceDate:m_pStartDate];

    int remainTime = oddTime - (int) (deltaTime + 0.5);

    if (remainTime < 0.0) {
        [m_pTimer invalidate];
        return;
    }
    [self showTime:(int) remainTime];
}

- (void)showTime:(int)time {
    int inputSeconds = (int) time;
    int hours = inputSeconds / 3600;
    int minutes = (inputSeconds - hours * 3600) / 60;
    int seconds = inputSeconds - hours * 3600 - minutes * 60;

    NSString *strTime = [NSString stringWithFormat:@"%.2d:%.2d:%.2d", hours, minutes, seconds];

    [_systemTime setText:strTime];
}

- (void)updatePhotoPressed {
    LLog(@"You want to change the picture ？");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 2) return;
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.allowsEditing = YES;
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:controller
                               animated:YES
                             completion:nil];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                message:@"Your device doesn't support this feature"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
    if (buttonIndex == 1) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:controller animated:YES completion:nil];
        }
        else {
            NSLog(@"gaoshazi");
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {

    [picker dismissViewControllerAnimated:YES completion:^{

    }];
    [self showHUD:@"Uploading Picture..." isDim:YES];

    NSString *userId = [LanbaooPrefs sharedInstance].userId;

    //The picture uploaded to the server
    NSDictionary *parameters = @{
            @"command" : @"update_user",
            @"uid" : userId
    };
    NSError *err;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]
            multipartFormRequestWithMethod:@"POST"
                                 URLString:kServerURL
                                parameters:parameters
                 constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
                     NSData *uploadImage = [self compressImageToUpload:image];
                     [formData appendPartWithFileData:uploadImage
                                                 name:@"avatar"
                                             fileName:@"user.jpg"
                                             mimeType:@"image/jpg"];
                 } error:&err];
    NSLog(@"err = %@", err);

    AFHTTPRequestOperation *opration = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    opration.responseSerializer = [AFJSONResponseSerializer serializer];
    [opration setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self showHUdComplete:@"Upload Successful!"];
        _avatar.image = image;

        NSDictionary *dict = [responseObject objectForKey:@"data"];
        NSString *photo = [dict objectForKey:@"avatar"];

        UserInfo *userInfo = [UserInfo searchSingleWithWhere:nil orderBy:nil];
        if (!userInfo) {
            userInfo = [[UserInfo alloc] init];
        }
        userInfo.avatar = photo;
        [userInfo updateToDB];

        [LanbaooPrefs sharedInstance].userName = [NSString stringWithFormat:@"%@ %@", userInfo.firstname, userInfo.lastname];

    }                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"error = %@", error);

    }];

    [opration start];
}

#pragma mark - belowButtons

- (void)_belowButtons {
    _VSRandom = [UIFactory createButtonWithFrame:CGRectMake(5, kScreenHeight - 115, 100, 100)
                                           Title:@""
                                          Target:self
                                        Selector:@selector(vsRandomClick)];
    _VSRandom.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_VSRandom];

    _VSFriend = [UIFactory createButtonWithFrame:CGRectMake(kScreenWidth / 2 - 50, kScreenHeight - 105, 100, 100)
                                           Title:@""
                                          Target:self
                                        Selector:@selector(vsFriendClick)];
    _VSFriend.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_VSFriend];

    _LeaderBoard = [UIFactory createButtonWithFrame:CGRectMake((kScreenWidth - 105), (kScreenHeight - 115), 100, 100)
                                              Title:@""
                                             Target:self
                                           Selector:@selector(leadersClick)];
    _LeaderBoard.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_LeaderBoard];

}

#pragma mark - button Click Action

- (void)settingsBtnClick {

    NSString *userId = [LanbaooPrefs sharedInstance].userId;

    if ([[CMOpenALSoundManager singleton] isBackGroundMusicPlaying]) {
        [[CMOpenALSoundManager singleton] stopBackgroundMusic];
    }

    if (userId.intValue == 0) {
        LogInViewController *loginVC = [[LogInViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    } else {
        SettingsViewController *settings = [[SettingsViewController alloc] init];
        settings.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:settings];
        [self presentViewController:navCtrl animated:YES completion:nil];
    }
}

- (void)findFriendBtnClick {

    NSString *userId = [LanbaooPrefs sharedInstance].userId;

    if ([[CMOpenALSoundManager singleton] isBackGroundMusicPlaying]) {
        [[CMOpenALSoundManager singleton] stopBackgroundMusic];
    }

    if (userId.intValue == 0) {
        LogInViewController *loginVC = [[LogInViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:NO];
    } else {
        LevelsFindFriendViewController *findFriend = [[LevelsFindFriendViewController alloc] init];
        findFriend.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.view.window.rootViewController presentViewController:findFriend animated:YES completion:nil];
    }
}

- (void)level {

    NSString *userId = [LanbaooPrefs sharedInstance].userId;

    if ([[CMOpenALSoundManager singleton] isBackGroundMusicPlaying]) {
        [[CMOpenALSoundManager singleton] stopBackgroundMusic];
    }
    if (userId.intValue == 0) {
        LogInViewController *loginVC = [[LogInViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:NO];
    } else {
        LevelsViewController *level = [[LevelsViewController alloc] init];
        level.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:level];

        [self presentViewController:navCtrl animated:YES completion:nil];
    }
}

- (void)vsRandomClick {

    NSString *userId = [LanbaooPrefs sharedInstance].userId;

    if (userId.intValue == 0) {
        [self welcomePage];
    } else {

        UserInfo *userInfo = [UserInfo searchSingleWithWhere:nil orderBy:nil];

        NSString *dateStr = userInfo.lastBotFight;
        NSDate *dateFight = [dateStr getDateWithFormat:kDateFormat];

        if (!dateFight) {
            [self bindingBot];
            return;
        }

        NSDate *dateNow = [NSDate new];
        NSString *dateNowStr = [dateNow getDateStrWithFormat:@"yyyy-MM-dd"];

        if ([dateNowStr isEqualToString:[dateFight getDateStrWithFormat:@"yyyy-MM-dd"]]) {

            [[CMOpenALSoundManager singleton] playSoundWithID:3];
            [[[UIAlertView alloc] initWithTitle:@"Alert"
                                        message:@"A new game will be available soon!"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];

            return;
        } else {
            [self bindingBot];
        }

    }
}

- (void)bindingBot {
    [self showHUD:@"Loading..." isDim:NO];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSInteger userid = [LanbaooPrefs sharedInstance].userId.intValue;

    NSDictionary *parameters = @{
            @"command" : @"bind_user_bot",
            @"id" : @(userid)
    };
    [manager GET:kServerURL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [self hideHUD];
             NSLog(@"JSON:%@", responseObject);

             NSDictionary *botDic = [responseObject objectForKey:@"data"];

             [BotModel map];
             botModel = [BotModel objectWithKeyValues:botDic];

             [LanbaooPrefs sharedInstance].botId = botModel.botId;

             VSInfoViewController *info = [[VSInfoViewController alloc] init];
             info.botModel = botModel;
             [self.navigationController pushViewController:info animated:YES];

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
}

- (void)vsFriendClick {

    NSString *userId = [LanbaooPrefs sharedInstance].userId;

    if ([[CMOpenALSoundManager singleton] isBackGroundMusicPlaying]) {
        [[CMOpenALSoundManager singleton] stopBackgroundMusic];
    }
    if (userId.intValue == 0) {
        LogInViewController *loginVC = [[LogInViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:NO];
    } else {
        NSLog(@"vs fiend");

        UserInfo *userInfo = [UserInfo searchSingleWithWhere:nil orderBy:nil];

        NSString *dateStr = userInfo.lastFrdFight;
        NSDate *dateFight = [dateStr getDateWithFormat:kDateFormat];

        if (!dateFight) {
            LeaderViewController *leader = [[LeaderViewController alloc] init];
            leader.isFindFriend = YES;
            [self.navigationController pushViewController:leader animated:YES];
            return;
        }

        NSDate *dateNow = [NSDate new];
        NSString *dateNowStr = [dateNow getDateStrWithFormat:@"yyyy-MM-dd"];

        if ([dateNowStr isEqualToString:[dateFight getDateStrWithFormat:@"yyyy-MM-dd"]]) {


            [[[UIAlertView alloc] initWithTitle:@"Alert"
                                        message:@"A new game will be available soon!"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];

            return;
        } else {
            LeaderViewController *leader = [[LeaderViewController alloc] init];
            leader.isFindFriend = YES;
            [self.navigationController pushViewController:leader animated:YES];
        }

    }
}

- (void)leadersClick {
    if ([[CMOpenALSoundManager singleton] isBackGroundMusicPlaying]) {
        [[CMOpenALSoundManager singleton] stopBackgroundMusic];
    }
    LeaderViewController *leader = [[LeaderViewController alloc] init];
    leader.isFindFriend = NO;
    [self.navigationController pushViewController:leader animated:YES];
}

#pragma mark Compress Image

- (NSData *)compressImageToUpload:(UIImage *)image {
    // Determine output size
    CGFloat maxSize = 200.0f;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat newWidth = width;
    CGFloat newHeight = height;

    // If any side exceeds the maximun size, reduce the greater side to 800px and proportionately the other one
    if (width > maxSize || height > maxSize) {
        if (width > height) {
            newWidth = maxSize;
            newHeight = (height * maxSize) / width;
        } else {
            newHeight = maxSize;
            newWidth = (width * maxSize) / height;
        }
    }

    // Resize the image
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // Set maximun compression in order to decrease file size and enable faster uploads & downloads
    NSData *processedImageData = UIImageJPEGRepresentation(newImage, 0.9f);
    return processedImageData;
}


#pragma mark Get user info

- (void)getUserInfo {

    WS(weakSelf)
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long) [[NSDate new] timeIntervalSince1970]];
//    NSDictionary *dic = @{@"uid" : uid};
    NSString *mURL = kServerURL;
    LLog(@"mURL = %@", mURL);

    NSString *uid = [LanbaooPrefs sharedInstance].userId;

    if (uid.length == 0 || uid.intValue == 0) {
        return;
    }

    NSDictionary *parameters = @{
            @"command" : @"index_rank",
            @"uid" : uid,
    };

    [manager GET:mURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *data = responseObject;
        if ([data[@"data"] isKindOfClass:[NSDictionary class]]) {
//            [weakSelf showData:data[@"result"]];
//            UserInfo *userInfo = [UserInfo searchSingleWithWhere:nil orderBy:nil];
//            UserRankIndex *userRankIndex = [UserRankIndex objectWithKeyValues:data[@"data"]];
            UserInfo *userInfo = [UserInfo objectWithKeyValues:data[@"data"]];

//            userInfo.points_week = userRankIndex.points_week;
//            userInfo.points_total = userRankIndex.totalPoints;
//            userInfo.number_win = userRankIndex.winCount;
//            userInfo.number_lost = userRankIndex.loseCount;
//            userInfo.rank = @(userRankIndex.rank).stringValue;
//            userInfo.lastBotFight = userRankIndex.lastBotFight;
//            userInfo.lastFrdFight = userRankIndex.lastFrdFight;

            if (userInfo) {
                [userInfo updateToDB];
            }

            [LanbaooPrefs sharedInstance].rank = userInfo.rank.intValue;
            [self refreshInfo];

        }
    }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LLog(@"%@", error);
    }];
}

- (void)getChallenger {
    NSString *uid = [LanbaooPrefs sharedInstance].userId;

    if (uid.length == 0) {
        return;
    }

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
            @"command" : @"get_challenger",
            @"uid" : uid
    };
    [manager GET:kServerURL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);

             if (!responseObject) {
                 return;
             }

             UserInfo *userInfo = [UserInfo searchSingleWithWhere:nil orderBy:nil];

             NSString *dateStr = userInfo.lastBotFight;
             NSDate *dateFight = [dateStr getDateWithFormat:kDateFormat];

             if (dateFight) {
                 NSDate *dateNow = [NSDate new];
                 NSString *dateNowStr = [dateNow getDateStrWithFormat:@"yyyy-MM-dd"];
                 if ([dateNowStr isEqualToString:[dateFight getDateStrWithFormat:@"yyyy-MM-dd"]]) {
                     return;
                 }
             }

             NSDictionary *dict = responseObject;
             NSArray *arrayDic = [dict getArray:@"data"];

             challengerArr = [UserInfo objectArrayWithKeyValuesArray:arrayDic];

             if (challengerArr && challengerArr.count > 0) {
                 chaView.hidden = NO;
             }
             [chaView setInfo:challengerArr];


         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
