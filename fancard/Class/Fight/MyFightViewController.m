//
//  MyFightViewController.m
//  fancard
//  Game logic interface
//
//  Created by MEETStudio on 15-8-28.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "MyFightViewController.h"
#import "Mconfig.h"
#import "NFTrivaBarView.h"
#import "UIViewExt.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "ETGlobal.h"
#import "scoreModel.h"
#import "BoxScoreCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import <LKDBHelper/NSObject+LKDBHelper.h>
#import "playerScore.h"
#import "CMOpenALSoundManager+Singleton.h"
#import "UIView+FrameCategory.h"
#import "NSMutableArray+shuffling.h"
#import "UILabel+DynamicFontSize.h"
#import "MySocket.h"
#import "UIImageView+WebCache.h"
#import "CateModel.h"
#import "UserInfo.h"
#import "LanbaooPrefs.h"
#import "NSDate+FormatDateString.h"

@interface MyFightViewController () {
    UIImageView *topicDisplay;

    UIView *_groupView;
    UIButton *_abLeft;             //ab = answerButton
    UIButton *_abMid;
    UIButton *_abRight;

    UIButton *backBtn;

    NFTrivaBarView *barView;       //Top score display plate
    UIImageView *courtImage;

    NSInteger secondsCountDown;

//answer_rotating_ball
    UIImageView *avLeft;           //av = animationView
    UIImageView *avMid;
    UIImageView *avRight;

    NSTimer *kGlobalTimer;
    int oddTime;       //24s remain

    NSMutableArray *questionArr;

    int myScroe;
    int myS;
    int oppScroe;
    int oppS;
    NSString *chosenAns;

    NSInteger userId;
    NSInteger botId;
    NSString *userName;

    UIImageView *background;
    UITableView *boxScore;
    UIImageView *nameView;
    UILabel *uNameLb;
    UILabel *opNameLb;
    UILabel *line;

    int musicFileNum;

    CGRect groupViewFrame;

    BOOL showtopicDisplay;

    NSArray *randomAudioArr;

    BOOL audioSwitch1;
    BOOL audioSwitch2;

    int quaNum;        //number of Quarter with dot_red、dot_white
    int questionNum;   //number of question

    SeasonTotalPoints *season1;
    SeasonTotalPoints *season2;
    SeasonTotalPoints *season3;
    SeasonTotalPoints *season4;

    BOOL isGameRunning;
    BOOL theBallShouldMove;
    BOOL isBoxScoreDisplay;
    int gameTimeCounter;//Tenths of a second
    int gameAnimationTimeCounter;//Tenths of a second ( total of 24 seconds literally [ actual 12 seconds ] a cycle )
    int boxScoreDisplayTimeCounter;//Tenths of a second

    NSMutableDictionary *allQuestionDict;//questions of 4 Quarters

    NSArray *cate;//question catgory

    int maxDurationOfQuarter;
    int durationOfQuarter;

    NSTimeInterval videoDuration;
}

@end

@implementation MyFightViewController {
    MPMoviePlayerController *_player;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!showtopicDisplay) {
        showtopicDisplay = YES;
        [[CMOpenALSoundManager singleton] purgeSounds];

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

//        [self getQuestions];
        [self initQuestions];
        [self getTopicDisplay];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    userName = [LanbaooPrefs sharedInstance].userName;
    botId = [LanbaooPrefs sharedInstance].botId;
    userId = [LanbaooPrefs sharedInstance].userId.intValue;

//    _fid = 3;

    NSLog(@"\n##userId:%ld\n##botId:%ld\n##userName:%@\n##fid:%ld\n", (long) userId, (long) botId, userName, (long) _fid);

//    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter addObserver:self
//                      selector:@selector(networkDidReceiveMessage:)
//                          name:kJPFNetworkDidReceiveMessageNotification
//                       object:nil];

    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(kScreenWidth - 50, 0, 50, 50);
    [backBtn setImage:[UIImage imageNamed:@"btn_close.png"] forState:UIControlStateNormal];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    [backBtn addTarget:self action:@selector(_backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.backgroundColor = [UIColor clearColor];

//barView
    barView = [[NFTrivaBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    barView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.7f];

    UserInfo *userInfo = [UserInfo searchSingleWithWhere:nil orderBy:nil];
    if (!userInfo) {
        userInfo = [[UserInfo alloc] init];
    }

    NSString *myAvatar = userInfo.avatar.length > 0 ? userInfo.avatar : @"";

    [barView.userPhoto sd_setImageWithURL:[NSURL URLWithString:myAvatar]];
    if (self.oppAvatar) {
        [barView.opponentPhoto sd_setImageWithURL:[NSURL URLWithString:self.oppAvatar]];
    } else {
        [barView.opponentPhoto setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"you" ofType:@"jpg"]]];
    }

//floor
    courtImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, barView.height - 5, kScreenWidth, kScreenHeight - barView.height + 5)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Court_02" ofType:@"jpg"];
    courtImage.image = [UIImage imageWithContentsOfFile:path];
    [self.view addSubview:courtImage];
    [self.view addSubview:barView];
    [self.view addSubview:backBtn];
    backBtn.hidden = YES;

    [self _initGroupView];  //answers grounpView

    [self _initBoxScore];   // BoxScore

    //points of each quarter
    season1 = [[SeasonTotalPoints alloc] init];
    season2 = [[SeasonTotalPoints alloc] init];
    season3 = [[SeasonTotalPoints alloc] init];
    season4 = [[SeasonTotalPoints alloc] init];

    questionArr = [[NSMutableArray alloc] init];
    randomAudioArr = [self audio];

    myScroe = 0;
    myS = 0;
    oppScroe = 0;
    oppS = 0;
    quaNum = 1;
    musicFileNum = 0;
    showtopicDisplay = NO;
    audioSwitch1 = NO;
    audioSwitch2 = NO;

    maxDurationOfQuarter = 60;
    durationOfQuarter = maxDurationOfQuarter;

    videoDuration = 4;

    [kGlobalTimer invalidate];
    _groupView.hidden = YES;
}

- (void)_initGroupView {
    groupViewFrame = CGRectMake(0, kScreenHeight - kScreenWidth / 2 + 30, kScreenWidth, kScreenWidth / 2);
    _groupView = [[UIImageView alloc] initWithFrame:groupViewFrame];
    _groupView.backgroundColor = [UIColor clearColor];
    _groupView.userInteractionEnabled = YES;
    [self.view addSubview:_groupView];

    _abLeft = [[UIButton alloc] initWithFrame:CGRectMake(5, 30, 90, 90)];
    _abLeft.backgroundColor = [UIColor clearColor];
    _abLeft.centerX = kScreenWidth / 6.0f;
    _abLeft.tag = 1;

    [_abLeft addTarget:self action:@selector(answerPressed:) forControlEvents:UIControlEventTouchUpInside];

    _answer1 = [[UILabel alloc] initWithFrame:CGRectMake(8.5, 40, 80, 70)];
    _answer1.centerY = _groupView.height / 2.0f - 20.0f;
    _answer1.centerX = kScreenWidth / 6.0f;
    _answer1.backgroundColor = [UIColor clearColor];
    _answer1.font = [UIFont fontWithName:kAsapBoldFont size:40.0f];
    _answer1.numberOfLines = 0;
    _answer1.textAlignment = NSTextAlignmentCenter;
    _answer1.adjustsFontSizeToFitWidth = YES;
    [_answer1 setTextColor:[UIColor whiteColor]];
    _answer1.transform = CGAffineTransformMakeRotation(-M_PI / 180 * 20);
    [_answer1 setTextAlignment:NSTextAlignmentCenter];

    _abMid = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - _abLeft.width / 2, 35, _abLeft.width, _abLeft.height)];
    _abMid.centerX = kScreenWidth / 2.0f;
    _abMid.backgroundColor = [UIColor clearColor];
    _abMid.tag = 2;
    [_abMid addTarget:self action:@selector(answerPressed:) forControlEvents:UIControlEventTouchUpInside];

    _answer2 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 80 / 2, 45, 80, 70)];
    _answer2.centerY = _groupView.height / 2.0f - 10.0f;
    _answer2.centerX = kScreenWidth / 2.0f;
    _answer2.backgroundColor = [UIColor clearColor];
    _answer2.font = [UIFont fontWithName:kAsapBoldFont size:40.0f];
    _answer2.numberOfLines = 0;
    _answer2.textAlignment = NSTextAlignmentCenter;
    _answer2.adjustsFontSizeToFitWidth = YES;
    [_answer2 setTextColor:[UIColor whiteColor]];
    _answer2.transform = CGAffineTransformMakeRotation(-M_PI / 180 * 20);
    [_answer2 setTextAlignment:NSTextAlignmentCenter];

    _abRight = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 5 - _abLeft.width, 30, _abLeft.width, _abLeft.height)];
    _abRight.backgroundColor = [UIColor clearColor];
    _abRight.centerX = kScreenWidth * 5 / 6.0f;
    _abRight.tag = 3;
    [_abRight addTarget:self action:@selector(answerPressed:) forControlEvents:UIControlEventTouchUpInside];

    _answer3 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 8.5 - 80, 40, 80, 70)];
    _answer3.centerY = _groupView.height / 2.0f - 20.0f;
    _answer3.centerX = kScreenWidth * 5 / 6.0f;
    _answer3.backgroundColor = [UIColor clearColor];
    _answer3.font = [UIFont fontWithName:kAsapBoldFont size:40.0f];
    _answer3.numberOfLines = 0;
    _answer3.adjustsFontSizeToFitWidth = YES;
    _answer3.textAlignment = NSTextAlignmentCenter;
    [_answer3 setTextColor:[UIColor whiteColor]];
    _answer3.transform = CGAffineTransformMakeRotation(-M_PI / 180 * 20);
    [_answer3 setTextAlignment:NSTextAlignmentCenter];

//answer_ball animation
    avLeft = [[UIImageView alloc] initWithFrame:CGRectMake(-kScreenWidth / 3 - 5, -10, kScreenWidth, kScreenWidth / 2 - 20)];
    avLeft.backgroundColor = [UIColor clearColor];
    [self animateWithAnimationView:avLeft];
    [_groupView addSubview:avLeft];

    avMid = [[UIImageView alloc] initWithFrame:CGRectMake(-5, 0, kScreenWidth, kScreenWidth / 2 - 20)];
    [self animateWithAnimationView:avMid];
    [_groupView addSubview:avMid];

    avRight = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 3 - 5, -10, kScreenWidth, kScreenWidth / 2 - 20)];
    [self animateWithAnimationView:avRight];

    [_groupView addSubview:avRight];
    [_groupView addSubview:_answer1];
    [_groupView addSubview:_answer2];
    [_groupView addSubview:_answer3];
    [_groupView addSubview:_abLeft];
    [_groupView addSubview:_abMid];
    [_groupView addSubview:_abRight];
}

- (void)_initBoxScore {

    background = [[UIImageView alloc] initWithFrame:CGRectMake(0, barView.bottom, kScreenWidth, kScreenHeight - barView.height)];
//    [background setImage:[UIImage imageNamed:@"pic_boxScore.png"]];
    [self.view addSubview:background];

    background.hidden = YES;
    boxScore = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth - 10, kScreenHeight - barView.height - 10)];
    boxScore.delegate = self;
    boxScore.dataSource = self;
    boxScore.scrollEnabled = NO;
    boxScore.backgroundColor = [UIColor clearColor];
    boxScore.separatorStyle = UITableViewCellSeparatorStyleNone;
    [background addSubview:boxScore];

    nameView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, boxScore.width, 44)];
    nameView.clipsToBounds = YES;
    nameView.contentMode = UIViewContentModeScaleAspectFill;
    nameView.image = [UIImage imageNamed:@"pic_boxScore_header"];
//    nameView.backgroundColor = [UIColor clearColor];
    boxScore.tableHeaderView = nameView;

    uNameLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, nameView.width / 2, nameView.height)];
    uNameLb.backgroundColor = [UIColor clearColor];
    uNameLb.text = userName;
    uNameLb.textAlignment = NSTextAlignmentCenter;
    uNameLb.font = [UIFont fontWithName:kAsapRegularFont size:20.0f];
    uNameLb.adjustsFontSizeToFitWidth = YES;
    uNameLb.textColor = [UIColor whiteColor];
    [nameView addSubview:uNameLb];

    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(uNameLb.right - 1, 6, 2, 32)];
    lineImage.clipsToBounds = YES;
    lineImage.contentMode = UIViewContentModeScaleAspectFill;
    [lineImage setImage:[UIImage imageNamed:@"pic_line_boxScore"]];
    [nameView addSubview:lineImage];

    opNameLb = [[UILabel alloc] initWithFrame:CGRectMake(uNameLb.right, 0, uNameLb.width, uNameLb.height)];
    opNameLb.backgroundColor = [UIColor clearColor];
    opNameLb.text = self.opponentName;
    opNameLb.textAlignment = NSTextAlignmentCenter;
    opNameLb.font = [UIFont fontWithName:kAsapRegularFont size:20.0f];
    opNameLb.adjustsFontSizeToFitWidth = YES;
    opNameLb.textColor = [UIColor whiteColor];
    [nameView addSubview:opNameLb];
}

- (NSArray *)audio {
    NSMutableArray *array = [@[
            @"MG1.mp3",
            @"MG2.mp3",
            @"MG3.mp3",
            @"MG4.mp3",
            @"MG5.mp3",
            @"MG6.mp3",
            @"MG7.mp3",
            @"MG8.mp3",
            @"MG9.mp3",
            @"MG10.mp3",
            @"MG11.mp3",
            @"MG12.mp3",
            @"MG13.mp3",
            @"MG14.mp3",
            @"MG15.mp3",
            @"MG16.mp3",
            @"MG17.mp3",
            @"MG18.mp3",
            @"MG19.mp3",
            @"MG20.mp3",
            @"MG21.mp3",
            @"MG22.mp3",
            @"MG23.mp3",
            @"MG24.mp3",
            @"MG25.mp3",
            @"MG26.mp3",
            @"MG27.mp3",
            @"MG28.mp3",
            @"MG29.mp3",
            @"MG30.mp3",
            @"MG31.mp3",
            @"MG32.mp3",
            @"MG33.mp3",
            @"MG34.mp3",
            @"MG35.mp3",
            @"MG36.mp3",
            @"MG37.mp3",
            @"MG38.mp3",
            @"MG39.mp3",
            @"MG40.mp3",
            @"MG41.mp3",
            @"MG42.mp3",
            @"MG43.mp3",
            @"MG44.mp3",
            @"MG45.mp3",
            @"MG46.mp3",
            @"MG47.mp3",
            @"MG48.mp3",
            @"MG49.mp3",
            @"MG50.mp3",
            @"MG51.mp3",
            @"MG52_4.mp3",
            @"MG53_4.mp3",
            @"MG54_4.mp3",
            @"MG55_4.mp3",
            @"MG56_4.mp3",
            @"MG57_4.mp3",
            @"MG58_4.mp3",
            @"MG59_4.mp3",
            @"MG60_4.mp3",
            @"MG61_4.mp3",
            @"MG62_4.mp3",
            @"MG63_4.mp3",
            @"MG64_4.mp3",
            @"MG65_4.mp3",
            @"MG66_4.mp3",
            @"MG67_4.mp3",
            @"MG68_4.mp3",
            @"MG69_4.mp3",
            @"MG70_4.mp3",
            @"MG71_4.mp3",
            @"MG72_4.mp3",
            @"MG73_4.mp3",
            @"MG74_4.mp3",
            @"MG75_4.mp3",
            @"MG76_4.mp3",
            @"MG77_4.mp3",
            @"MG78_4.mp3",
            @"MG79_4.mp3",
            @"MG80_4.mp3",
            @"MG81.mp3",
            @"MG82.mp3",
            @"MG83.mp3",
            @"MG84.mp3",
            @"MG85.mp3",
            @"MG86.mp3",
            @"MG87.mp3"
    ] mutableCopy];
    [array shuffle];
    return array;
}

#pragma mark - BoxScore UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"BoxScoreCell";
    BoxScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[BoxScoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor clearColor];

    NSArray *quarterArr = @[@"1ST QUARTER", @"2ND QUARTER", @"3RD QUARTER", @"4TH QUARTER"];
    cell.quarterNumLabel.text = quarterArr[indexPath.row];

    NSArray *seasonArr = @[season1, season2, season3, season4];
    if ((quaNum - 1) > indexPath.row) {
        [cell fillBoxScoreWithSeason:seasonArr[indexPath.row]];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float height = (boxScore.height - 44) / 4;
    return height;
}


- (void)getTopicDisplay {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
            @"command" : @"get_cate"
    };
    [manager GET:kServerURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//             NSLog(@"JSON: %@", responseObject);
        NSDictionary *dict = responseObject;
//        QuestionModels *questionModels = [ETGlobal sharedGlobal].allQuizs[0];

        cate = [CateModel objectArrayWithKeyValuesArray:dict[@"data"]];
        if (cate && cate.count > 0) {
            [self displayTopic];
        }

    }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
//                [self getTopicDisplay];
        [self topicDisplay:@""];
    }];
}

- (void)displayTopic {

    if (!questionArr || questionArr.count == 0) {
        [self showHit:@"no questions"];
        WS(weakSelf)
        int64_t delayInSeconds = 3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        });
        return;
    }
    QuestionModels *questionModels = questionArr[0];
    NSString *mURL;
    for (CateModel *cateModel in cate) {
        if (cateModel.id == questionModels.cateId) {
            mURL = cateModel.category_image;
            break;
        }
    }
    [self topicDisplay:mURL];
}

- (void)topicDisplay:(NSString *)mURL {
    mURL = [NSString stringWithFormat:@"%@", mURL];
    topicDisplay = [[UIImageView alloc] initWithFrame:CGRectMake(0, barView.bottom, kScreenWidth, kScreenHeight - barView.height)];
    [topicDisplay sd_setImageWithURL:[[NSURL alloc] initWithString:mURL]];
    [self.view addSubview:topicDisplay];

    NSArray *quarterArr = @[@"1st Quarter", @"2nd Quarter", @"3rd Quarter", @"4th Quarter"];

    barView.pauseLabel.text = quarterArr[(NSUInteger) (quaNum < 5 ? (quaNum - 1) : 3)];

    [self performSelector:@selector(beginGame) withObject:self afterDelay:5.0f];
}

- (void)initQuestions {
    NSArray *array = [ETGlobal sharedGlobal].allQuizs;

    NSMutableArray *quarterOne = [[NSMutableArray alloc] init];
    NSMutableArray *quarterTwo = [[NSMutableArray alloc] init];
    NSMutableArray *quarterThree = [[NSMutableArray alloc] init];
    NSMutableArray *quarterFour = [[NSMutableArray alloc] init];

    for (QuestionModels *questionModels in array) {
        int quarter = questionModels.quarter;
        switch (quarter) {
            case 0: {
                [quarterOne addObject:questionModels];
                break;
            }
            case 1: {
                [quarterTwo addObject:questionModels];
                break;
            }
            case 2: {
                [quarterThree addObject:questionModels];
                break;
            }
            case 3: {
                [quarterFour addObject:questionModels];
                break;
            }
            default:
                break;
        }
    }

    allQuestionDict = [[NSMutableDictionary alloc] init];

    allQuestionDict[@"1"] = quarterOne;
    allQuestionDict[@"2"] = quarterTwo;
    allQuestionDict[@"3"] = quarterThree;
    allQuestionDict[@"4"] = quarterFour;

    questionNum = 0;

    questionArr = allQuestionDict[@(quaNum).stringValue];
}

- (void)getQuestions {
    NSString *command;
    if (!_fid) {
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
             [QuestionModels map];

             NSMutableArray *arrayDic = [responseObject objectForKey:@"data"];
             [ETGlobal sharedGlobal].allQuizs = [QuestionModels objectArrayWithKeyValuesArray:arrayDic];
             [self initQuestions];
             [self getTopicDisplay];
//             [self beginGame];

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [self getQuestions];
            }];
}

- (void)beginGame {
    topicDisplay.hidden = YES;
    _groupView.hidden = NO;
    barView.timeQua.text = @"01:00";
    if (!kGlobalTimer || !kGlobalTimer.isValid) {
        kGlobalTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateView) userInfo:nil repeats:YES];
    }
    [self beginNewQuestion];
}

- (void)updateView {
    [self updateTime];
    [self updateMove];
    [self updateTime24];
    [self timeFire];
}

- (void)hideExtra {
    barView.questionLabel.hidden = YES;
    barView.userPhoto.hidden = YES;
    barView.opponentPhoto.hidden = YES;
    barView.userPoints.hidden = YES;
    barView.botPoints.hidden = YES;
    [barView.timeQua setTextColor:[UIColor colorWithRed:38 / 255.0 green:39 / 255.0 blue:40 / 255.0 alpha:1.0f]];
    [barView.roundTime setTextColor:[UIColor clearColor]];
    _groupView.hidden = YES;
}

- (void)showExtra {
    barView.questionLabel.hidden = NO;
    barView.userPhoto.hidden = NO;
    barView.opponentPhoto.hidden = NO;
    barView.userPoints.hidden = NO;
    barView.botPoints.hidden = NO;
    [barView.timeQua setTextColor:[UIColor yellowColor]];
    [barView.roundTime setTextColor:[UIColor redColor]];
    _groupView.hidden = NO;
}

- (void)beginNewQuestion {

    if (kGlobalTimer && [kGlobalTimer isValid]) {

    } else {
        [barView.time5 setText:@"00"];
        [self showTheEndView];
        return;
    }

    LLog(@"%s", sel_getName(_cmd));
    LLog(@"durationOfQuarter = %i", durationOfQuarter);
    gameAnimationTimeCounter = gameTimeCounter;

    isGameRunning = YES;
    theBallShouldMove = YES;
    isBoxScoreDisplay = NO;

    [self showExtra];
    myS = 0;
    oppS = 0;

    background.hidden = YES;
    if ([[CMOpenALSoundManager singleton] isBackGroundMusicPlaying]) {
        [[CMOpenALSoundManager singleton] stopBackgroundMusic];
    }
    [[CMOpenALSoundManager singleton] purgeSounds];
    [[CMOpenALSoundManager singleton] playBackgroundMusic:randomAudioArr[musicFileNum]];
    musicFileNum = musicFileNum + 1;
    if (musicFileNum > (randomAudioArr.count - 1)) {
        musicFileNum = 0;
    }
    _abLeft.enabled = YES;
    _abMid.enabled = YES;
    _abRight.enabled = YES;
    secondsCountDown = 5;

    if (questionNum < questionArr.count) {

        _question = questionArr[questionNum];
        barView.time5.text = @"";
        barView.pauseLabel.text = @"";
        barView.questionLabel.text = _question.question;
        barView.roundTime.text = @"24";

        NSArray *answers = [_question answers];
        [_answer1 adjustFontSizeWithText:answers[0] constrainedToSize:(CGSize) {80, 70}];
        [_answer2 adjustFontSizeWithText:answers[1] constrainedToSize:(CGSize) {80, 70}];
        [_answer3 adjustFontSizeWithText:answers[2] constrainedToSize:(CGSize) {80, 70}];

        _groupView.frame = groupViewFrame;

        questionNum = questionNum + 1;
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"No more question";
        [hud hide:YES afterDelay:3];
        if ([[CMOpenALSoundManager singleton] isBackGroundMusicPlaying]) {
            [[CMOpenALSoundManager singleton] stopBackgroundMusic];
        }
        [kGlobalTimer invalidate];
        _abLeft.enabled = NO;
        _abMid.enabled = NO;
        _abRight.enabled = NO;
        barView.roundTime.text = @"";
        barView.questionLabel.text = @"";
        barView.timeQua.hidden = YES;
        barView.time5.hidden = YES;

        background.hidden = NO;
        [boxScore reloadData];

        int type = 0;
        if (myScroe > oppScroe) {
            barView.pauseLabel.text = @"You Won";
            [[CMOpenALSoundManager singleton] playBackgroundMusic:@"If Win.mp3"];
            type = 1;
        } else if (myScroe == oppScroe) {
            barView.pauseLabel.text = @"You Tied";
            [[CMOpenALSoundManager singleton] playBackgroundMusic:@"BoxScore - Post Game - If Win or Undecided.mp3"];
            type = 2;
        } else if (myScroe < oppScroe) {
            barView.pauseLabel.text = @"You Lost";
            [[CMOpenALSoundManager singleton] playBackgroundMusic:@"BoxScore - Post Game - If Lost.mp3"];
            type = 0;
        }

        [self postResult:type];
    }
}

- (void)postResult:(int)type {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
            @"command" : @"get_result",
            @"uid" : @(userId),
            @"type" : @(type)
    };
    if (botId > 0) {
        parameters = @{
                @"command" : @"get_result",
                @"uid" : @(userId),
                @"fid" : @(botId),
                @"type" : @(type)
        };
    }

    [manager GET:kServerURL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON:%@", responseObject);
             NSDictionary *userModel = [responseObject objectForKey:@"data"];

             UserInfo *userInfo = [UserInfo objectWithKeyValues:userModel];

             if (userInfo) {
                 [userInfo updateToDB];
                 [LanbaooPrefs sharedInstance].userName = [NSString stringWithFormat:@"%@ %@", userInfo.firstname, userInfo.lastname];
             }

             backBtn.hidden = NO;

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error:%@", error);

            }];
}

//answer question
- (void)answerPressed:(UIButton *)sender {

    [self hideExtra];
    _abLeft.enabled = NO;
    _abMid.enabled = NO;
    _abRight.enabled = NO;

    theBallShouldMove = NO;

    NSString *time = barView.roundTime.text;
    NSLog(@"time:%@", time);
    int remainTime = [time intValue] / 2;       //the actual time remaining

    //get the selected answer
    NSInteger tag = [sender tag];
    NSString *str = [NSString stringWithFormat:@"answer%d", (int) tag];
    UILabel *label = [self valueForKey:str];
    chosenAns = label.text;
    int questionId = _question.identifier;
    NSLog(@"\nquestionId:%d\nanswer:%@\n", questionId, chosenAns);

    if (userId > 0 && (!_fid || _fid == 0)) {
        [self currentQuestion:questionId answer:chosenAns now:remainTime];

        //userId == 0: not login
    } else if (userId == 0) {
        if ([chosenAns isEqualToString:self.question.rightAns])
        {
            [self answerResult:YES now:remainTime];

        } else {
            [self answerResult:NO now:remainTime];
        }
    }
        //VS friend
    else if (userId > 0 && _fid > 0) {
        [self currentQuestion:questionId answer:chosenAns command:@"answer_friend_question" now:remainTime];
    }
}

#pragma mark - Get scores from the server

- (void)currentQuestion:(int)questionId answer:(NSString *)answer command:(NSString *)command now:(int)remainTime {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
            @"command" : command,
            @"question_id" : @(questionId),
            @"answer" : answer,
            @"uid" : @(userId),
            @"fid" : @(_fid),
            @"time" : @(remainTime),
            @"quarter" : @(quaNum - 1),
            @"date" : [[NSDate new] getDateStrWithFormat:kDateFormat]
    };
    NSLog(@"%@", parameters);
    [manager GET:kServerURL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);

             [playerScore map];
             NSDictionary *scoreDic = [responseObject objectForKey:@"data"];
             playerScore *pScore = [playerScore objectWithKeyValues:scoreDic];
             NSLog(@"###id:%ld\n###score:%ld", (long) pScore.playerId, (long) pScore.score);

             if (pScore.playerId == userId) {
                 myS = pScore.score;
//                 [self calculateGrade];
                 [self calcuateMyGrade];
                 oppS = 0;
             } else if (pScore.playerId == _fid) {
//                 oppS = pScore.score;
//                 [self calculateGrade];
//                 myS = 0;
             }
             [self postAllScore:myS];
             [self playerTogether];

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
}

- (void)postAllScore:(int)myCurrentScore {
    PushBean *pushBean = [[PushBean alloc] init];
    pushBean.uid = @(userId).stringValue;
    pushBean.toUid = @(_fid).stringValue;
    pushBean.action = @"score";
//    pushBean.myCurrentScore = oppCurrentScore;
    pushBean.currentScore = myCurrentScore;
    if ([MySocket singleton].sRWebSocket.readyState == SR_OPEN) {
        [[MySocket singleton].sRWebSocket send:pushBean.JSONString];
    }
}

- (void)didReceiveMessage:(NSNotification *)notification {
    NSString *message = [notification object];
    PushBean *pushBean = [PushBean objectWithKeyValues:message];
    if (pushBean) {
        NSString *action = pushBean.action;
        if (action.length > 0 && [action isEqualToString:@"score"]) {
//            myS = pushBean.myCurrentScore;
//            myScroe = myScroe + myS;
            oppS = pushBean.currentScore;
            [self calculateOppGrade];
            oppScroe = oppScroe + oppS;
            barView.botPoints.text = [NSString stringWithFormat:@"%d", oppScroe];
            barView.userPoints.text = [NSString stringWithFormat:@"%d", myScroe];
        }
    }
}

//play with computer，get score from server
- (void)currentQuestion:(int)questionId answer:(NSString *)answer now:(int)remainTime {
    theBallShouldMove = NO;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
            @"command" : @"answer_bot_question",
            @"question_id" : @(questionId),
            @"answer" : answer,
            @"uid" : @(userId),
            @"fid" : @(botId),
            @"time" : @(remainTime),
            @"quarter" : @(quaNum - 1),
            @"date" : [[NSDate new] getDateStrWithFormat:kDateFormat]
    };

    [manager GET:kServerURL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             NSDictionary *scoreDic = [responseObject objectForKey:@"data"];
             scoreModel *score = [scoreModel objectWithKeyValues:scoreDic];
             oppS = score.addBotCredit;
             myS = score.addUserCredit;

             [self calculateGrade];
             [self onlinePlayerResult];

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
}

#pragma mark - Timer

- (void)updateTime24 {

    if (!theBallShouldMove) {
        return;
    }

    gameAnimationTimeCounter = gameAnimationTimeCounter + 1;
    if (gameAnimationTimeCounter < 10) {
        return;
    } else {
        gameAnimationTimeCounter = 0;
    }

    oddTime = [barView.roundTime.text intValue];

    if (oddTime == 0) {
        [self hideExtra];
        _abLeft.enabled = NO;
        _abMid.enabled = NO;
        _abRight.enabled = NO;

        theBallShouldMove = NO;

        if (userId > 0) {
            if (!(_player && (_player.playbackState == MPMoviePlaybackStatePlaying))) {

                int questionId = _question.identifier;
                NSLog(@"\nquestionId:%d\nanswer:%@\n", questionId, chosenAns);
                if (_fid && _fid > 0) {
                    [self currentQuestion:questionId answer:@"##timeOut##" command:@"answer_friend_question" now:0];
                } else {
                    [self currentQuestion:questionId answer:@"##timeOut##" now:0];
                }
            }

        } else {
            if (!(_player && (_player.playbackState == MPMoviePlaybackStatePlaying))) {
                [self answerResult:NO now:0];
            }
        }

        [self postAllScore:0];

    } else {
        oddTime = oddTime - 2;
        barView.roundTime.text = [NSString stringWithFormat:@"%.2d", oddTime];
    }
}

- (void)updateTime {

    if (!isGameRunning) {
        return;
    }

    gameTimeCounter = gameTimeCounter + 1;
    if (gameTimeCounter < 10) {
        return;
    } else {
        gameTimeCounter = 0;
    }

//    NSArray *times = [barView.timeQua.text componentsSeparatedByString:@":"];
//    int minu = [times[0] intValue];
//    int second = [times[1] intValue];

//    if (second == 0 && minu > 0) {
//        minu = minu - 1;
//        second = 58;
//    } else if (second > 0) {
//        second = second - 2;
//    }

    if (durationOfQuarter > 0) {
        durationOfQuarter = durationOfQuarter - 2;
    }

    if (durationOfQuarter <= 20) {
        if (audioSwitch1 == NO) {
            audioSwitch1 = YES;
            [[CMOpenALSoundManager singleton] playSoundWithID:0];
        }
    }
    if (durationOfQuarter <= 4) {
        if (audioSwitch2 == NO) {
            audioSwitch2 = YES;
            [[CMOpenALSoundManager singleton] playSoundWithID:1];
        }
    }
    if (durationOfQuarter == 0) {

        isGameRunning = NO;
        theBallShouldMove = NO;

        _abLeft.enabled = NO;
        _abMid.enabled = NO;
        _abRight.enabled = NO;
        barView.roundTime.text = @"";
        barView.questionLabel.text = @"";

        quaNum = quaNum + 1;

        durationOfQuarter = maxDurationOfQuarter;

        if (quaNum < 5) {
            questionArr = allQuestionDict[@(quaNum).stringValue];
            questionNum = 0;
        }

        if (quaNum == 2) {
            barView.image1.image = [UIImage imageNamed:@"dot_red.png"];
            barView.image2.image = [UIImage imageNamed:@"dot_red.png"];
            barView.image3.image = [UIImage imageNamed:@"dot_white.png"];
            barView.image4.image = [UIImage imageNamed:@"dot_white.png"];
            barView.pauseLabel.text = @"End of 1st Quarter";
        }
        if (quaNum == 3) {
            barView.image1.image = [UIImage imageNamed:@"dot_red.png"];
            barView.image2.image = [UIImage imageNamed:@"dot_red.png"];
            barView.image3.image = [UIImage imageNamed:@"dot_red.png"];
            barView.image4.image = [UIImage imageNamed:@"dot_white.png"];
            barView.pauseLabel.text = @"End of 2nd Quarter";
        }
        if (quaNum == 4) {
            barView.image1.image = [UIImage imageNamed:@"dot_red.png"];
            barView.image2.image = [UIImage imageNamed:@"dot_red.png"];
            barView.image3.image = [UIImage imageNamed:@"dot_red.png"];
            barView.image4.image = [UIImage imageNamed:@"dot_red.png"];
            barView.pauseLabel.text = @"End of 3rd Quarter";
        }
        if (quaNum == 5) {

            [self showTheEndView];

        } else {
            if (_player && (_player.playbackState == MPMoviePlaybackStatePlaying)) {
//                [self performSelector:@selector(BoxScoreDisplay) withObject:self afterDelay:0.0f];
            } else {
                [self BoxScoreDisplay];
            }
        }
    }
    barView.timeQua.text = [NSString stringWithFormat:@"%.2d:%.2d", durationOfQuarter / 60, durationOfQuarter % 60];
}

- (void)showTheEndView {

    [kGlobalTimer invalidate];
    kGlobalTimer = nil;

    [self hideExtra];
    barView.userPhoto.hidden = NO;
    barView.opponentPhoto.hidden = NO;
    barView.userPoints.hidden = NO;
    barView.botPoints.hidden = NO;
    background.hidden = NO;
    [boxScore reloadData];
    int type = 0;
    if (myScroe > oppScroe) {
        barView.pauseLabel.text = @"You Won";
        [[CMOpenALSoundManager singleton] playBackgroundMusic:@"BoxScore - Post Game - If Win or Undecided.mp3"];
        type = 1;
    }
    if (myScroe == oppScroe) {
        barView.pauseLabel.text = @"You Tied";
        [[CMOpenALSoundManager singleton] playBackgroundMusic:@"BoxScore - Post Game - If Win or Undecided.mp3"];
        type = 2;
    }
    if (myScroe < oppScroe) {
        barView.pauseLabel.text = @"You Lost";
        [[CMOpenALSoundManager singleton] playBackgroundMusic:@"BoxScore - Post Game - If Lost.mp3"];
        type = 0;
    }
    [self postResult:type];

    [LanbaooPrefs sharedInstance].challengerId = nil;
}

- (void)updateMove {

    if (theBallShouldMove) {
        float y = (kScreenHeight - barView.height - _groupView.height + 25) / 12;
        CGRect rect = _groupView.frame;
        rect.origin.y -= y / 10;
        //    NSLog(@"##########%f",rect.origin.y);

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        _groupView.frame = rect;
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_groupView cache:YES];
        [UIView commitAnimations];
    }

}

#pragma mark - Display BoxScore

- (void)BoxScoreDisplay {

    isBoxScoreDisplay = YES;
    boxScoreDisplayTimeCounter = 0;
    /*
     *5s timer
     *
     *paly audio: "BoxScore.mp3"
     */
    [boxScore reloadData];
    if ([[CMOpenALSoundManager singleton] isBackGroundMusicPlaying]) {
        [[CMOpenALSoundManager singleton] stopBackgroundMusic];
    }
    barView.time5.text = @"05";
    background.hidden = NO;

    if (quaNum == 2) {
        [[CMOpenALSoundManager singleton] playSoundWithID:5];
    } else if (quaNum == 3) {
        [[CMOpenALSoundManager singleton] playSoundWithID:4];
    } else if (quaNum == 4) {
        [[CMOpenALSoundManager singleton] playSoundWithID:6];
    }
    audioSwitch1 = NO;
    audioSwitch2 = NO;
}

//timer
- (void)timeFire {

    if (!isBoxScoreDisplay) {
        return;
    }

    boxScoreDisplayTimeCounter = boxScoreDisplayTimeCounter + 1;
    if (boxScoreDisplayTimeCounter < 10) {
        return;
    } else {
        boxScoreDisplayTimeCounter = 0;
    }

    secondsCountDown--;
    if (secondsCountDown <= 5 && secondsCountDown >= 0) {

        int seconds;
        if (kGlobalTimer && [kGlobalTimer isValid]) {
            seconds = secondsCountDown % 60;
        } else {
            seconds = 0;
        }
        NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
        [barView.time5 setText:strTime];
    }

    //Scoreboard countdown show ended five seconds, then displays the topic
    if (secondsCountDown == 0) {
        if (quaNum > 4) {
            [self showTheEndView];
        } else {
            [self displayTopic];
        }
    }
}

#pragma mark - Select results

- (void)onlinePlayerResult {
    oppScroe = oppScroe + oppS;
    myScroe = myScroe + myS;
    barView.botPoints.text = [NSString stringWithFormat:@"%d", oppScroe];
    barView.userPoints.text = [NSString stringWithFormat:@"%d", myScroe];

    [self currentVideo];
}

//VS friend: play video
- (void)playerTogether {
    myScroe = myScroe + myS;
    oppScroe = oppScroe + oppS;
    barView.botPoints.text = [NSString stringWithFormat:@"%d", oppScroe];
    barView.userPoints.text = [NSString stringWithFormat:@"%d", myScroe];

    if (myS == 2) {
        NSURL *portraitUrl = [[NSBundle mainBundle] URLForResource:@"Beta-Dunk-Make-Animation" withExtension:@"mp4"];
        [self playVideo:portraitUrl withYCoordinate:CGRectGetMaxY(barView.frame)];

    } else if (myS == 0) {
        NSURL *portraitUrl = [[NSBundle mainBundle] URLForResource:@"Miss-3-point" withExtension:@"mp4"];
        [self playVideo:portraitUrl withYCoordinate:CGRectGetMaxY(barView.frame)];

    } else if (myS == 3) {
        NSURL *portraitUrl = [[NSBundle mainBundle] URLForResource:@"MG-Made-3pt-Animation" withExtension:@"mp4"];
        [self playVideo:portraitUrl withYCoordinate:CGRectGetMaxY(barView.frame)];

    } else {
//        [self performSelector:@selector(beginNewQuestion) withObject:self afterDelay:0.0f];
        [self beginNewQuestion];
    }
}

- (void)answerResult:(BOOL)result now:(int)remainTime {
/*  result == YES:right
 *  result == NO:wrong
 *  remianTime:
 */
    int a = (arc4random() % 4);
    if (a == 0) {
        oppS = 3;
    } else if (a == 3) {
        oppS = 0;
    } else {
        oppS = 2;
    }
    if (result == YES && oddTime != 0) {
        if (remainTime <= 6) {
            myS = 2;
        } else {
            myS = 3;
        }
    } else if (result == NO && oddTime != 0) {
        myS = 0;
    }
    oppScroe = oppScroe + oppS;
    myScroe = myScroe + myS;
    barView.botPoints.text = [NSString stringWithFormat:@"%d", oppScroe];
    barView.userPoints.text = [NSString stringWithFormat:@"%d", myScroe];

    [self calculateGrade];
    [self currentVideo];
}


- (void)calcuateMyGrade {
    SeasonTotalPoints *currentSeason = [[SeasonTotalPoints alloc] init];
    if (quaNum == 1) {
        currentSeason = season1;
    } else if (quaNum == 2) {
        currentSeason = season2;
    } else if (quaNum == 3) {
        currentSeason = season3;
    } else if (quaNum == 4) {
        currentSeason = season4;
    }

    [currentSeason updateMyCurrentScoreWithScore:myS];
}

- (void)calculateOppGrade {
    SeasonTotalPoints *currentSeason = [[SeasonTotalPoints alloc] init];
    if (quaNum == 1) {
        currentSeason = season1;
    } else if (quaNum == 2) {
        currentSeason = season2;
    } else if (quaNum == 3) {
        currentSeason = season3;
    } else if (quaNum == 4) {
        currentSeason = season4;
    }

    [currentSeason updateOppCurrentScoreWithScore:oppS];
}


- (void)calculateGrade {
    SeasonTotalPoints *currentSeason = [[SeasonTotalPoints alloc] init];
    if (quaNum == 1) {
        currentSeason = season1;
    } else if (quaNum == 2) {
        currentSeason = season2;
    } else if (quaNum == 3) {
        currentSeason = season3;
    } else if (quaNum == 4) {
        currentSeason = season4;
    }

//    int myCurrentScore = 0;
//    int opponentCurrentScore = 0;
//    if (userId > 0 && _fid > 0) {
//        myCurrentScore = myS;
//        opponentCurrentScore = oppS;
//
//    } else {
//        myCurrentScore = myS;
//        opponentCurrentScore = oppS;
//    }
    [currentSeason addScoreWithMyCurrentScore:myS opponentCurrentScore:oppS];

}

// video to play, determine by scores
- (void)currentVideo {
    if (myS == 2) {
        NSURL *portraitUrl = [[NSBundle mainBundle] URLForResource:@"Beta-Dunk-Make-Animation" withExtension:@"mp4"];
        [self playVideo:portraitUrl withYCoordinate:CGRectGetMaxY(barView.frame)];

    } else if (myS == 0) {
        NSURL *portraitUrl = [[NSBundle mainBundle] URLForResource:@"Miss-3-point" withExtension:@"mp4"];
        [self playVideo:portraitUrl withYCoordinate:CGRectGetMaxY(barView.frame)];

    } else if (myS == 3) {
        NSURL *portraitUrl = [[NSBundle mainBundle] URLForResource:@"MG-Made-3pt-Animation" withExtension:@"mp4"];
        [self playVideo:portraitUrl withYCoordinate:CGRectGetMaxY(barView.frame)];

    } else {
//        [self performSelector:@selector(beginNewQuestion) withObject:self afterDelay:0.0f];
        [self beginNewQuestion];
    }
}

#pragma mark - rotating_ball Animation

- (void)animateWithAnimationView:(UIImageView *)animationView {
    NSMutableArray *animationImages = [NSMutableArray array];
    int maxIndex = 46;
    if (animationView == avLeft) {
        for (int i = 0; i <= maxIndex; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%@%02d@2x", @"rotating_ball_", i];
            UIImage *image = [UIImage imageNamed:imageName];

            [animationImages addObject:image];
        }
        [animationView setAnimationImages:animationImages];
        [animationView setAnimationDuration:animationView.animationImages.count * 0.05];
        [animationView setAnimationRepeatCount:0];    // 0 means infinite (default is 0)
        [animationView startAnimating];
    }
    if (animationView == avMid) {

        for (int i = 15; i <= maxIndex + 15; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%@%02d@2x", @"rotating_ball_", i > maxIndex ? i - maxIndex : i];
            UIImage *image = [UIImage imageNamed:imageName];

            [animationImages addObject:image];
        }
        [animationView setAnimationImages:animationImages];
        [animationView setAnimationDuration:animationView.animationImages.count * 0.05];
        [animationView startAnimating];
    }
    if (animationView == avRight) {
        for (int i = 31; i <= maxIndex + 31; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%@%02d@2x", @"rotating_ball_", i > maxIndex ? i - maxIndex : i];
            UIImage *image = [UIImage imageNamed:imageName];

            [animationImages addObject:image];
        }
        [animationView setAnimationImages:animationImages];
        [animationView setAnimationDuration:animationView.animationImages.count * 0.05];
        [animationView startAnimating];
    }
}

#pragma mark - backAction

- (void)_backBtnClick {
    [kGlobalTimer invalidate];
    if ([[CMOpenALSoundManager singleton] isBackGroundMusicPlaying]) {
        [[CMOpenALSoundManager singleton] stopBackgroundMusic];
    }

    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - splashVideo

- (void)splashVideoPlayFinished {

    LLog(@"%s", sel_getName(_cmd));
//        [self BoxScoreDisplay];

//        [self performSelector:@selector(beginNewQuestion) withObject:self afterDelay:0];
//        [self beginNewQuestion];
}

- (void)playVideo:(NSURL *)url withYCoordinate:(CGFloat)YCoordinate {

    // init player without a url so we don't miss notifications from it while we're preparing it's state.
    if (!_player) {
        _player = [[MPMoviePlayerController alloc] initWithContentURL:nil];
    }
    // video doesn't need to be shifted down
    _player.view.frame = self.view.frame;
    _player.view.height = _player.view.height - YCoordinate;
    _player.view.y = YCoordinate;

    _player.controlStyle = MPMovieControlStyleNone;
    _player.scalingMode = MPMovieScalingModeAspectFill;
    _player.allowsAirPlay = NO;
    // we're going to install it once it's loaded and play it then
    _player.shouldAutoplay = NO;
    // there's still a little bit of black flash left when the player is inserted
    // as it starts to play, adding the splash image to the background of the player
    // will get rid of it

    _player.view.userInteractionEnabled = NO;

//    // this is the default notification up through iOS 5
//    _loadNotification = MPMoviePlayerLoadStateDidChangeNotification;
//    if ([_player respondsToSelector:@selector(readyForDisplay)]) {
//        // iOS 6, listen for this notification instead
//        _loadNotification = MPMoviePlayerReadyForDisplayDidChangeNotification;
//    }
    // tell us when the video has loaded

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerReadyForDisplayDidChangeNotification
                                                  object:_player];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(splashLoadStateDidChange:)
                                                 name:MPMoviePlayerReadyForDisplayDidChangeNotification
                                               object:_player];

    // tell us when the video has finished playing
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(splashPlaybackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];


    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMovieDurationAvailable:)
                                                 name:MPMovieDurationAvailableNotification
                                               object:_player];

    [_player setContentURL:url];
    [_player prepareToPlay];
}

- (void)MPMovieDurationAvailable:(NSNotification *)notification {
    MPMoviePlayerController *playerController = [notification object];
//    videoDuration = playerController.duration;
    LLog(@"duration = %f", videoDuration);

}

- (void)splashLoadStateDidChange:(NSNotification *)notification {
    // we don't need this again
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerReadyForDisplayDidChangeNotification
                                                  object:_player];

    // the video has loaded so we can safely add the player to the window now
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [self.view addSubview:_player.view];
    // and play it
    [_player play];

    LLog(@"%s", sel_getName(_cmd));

    if (durationOfQuarter > videoDuration) {
        [self performSelector:@selector(beginNewQuestion) withObject:self afterDelay:videoDuration];
    } else {
        if (quaNum > 4) {
            [self performSelector:@selector(showTheEndView) withObject:self afterDelay:videoDuration];
        } else {
            [self performSelector:@selector(BoxScoreDisplay) withObject:self afterDelay:videoDuration];
        }
    }

    // tell the delegate that the video has loaded, running in the background to prevent
    // it from causing studders.
//    [_delegate performSelectorInBackground:@selector(splashVideoLoaded:) withObject:self];
}

- (void)splashPlaybackStateDidChange:(NSNotification *)notification {
    // first time this is called, playback state will be MPMoviePlaybackStatePlaying
    // so we ignore that case.
    // second time, upon finish of playback, state will be MPMoviePlaybackStatePaused
    // if interrupted, state will be MPMoviePlaybackStatePaused
    // both of those cases are treated as if splash playback finished
    // MPMoviePlaybackStateInterrupted, MPMoviePlaybackStateStopped are added
    // to the or condition as a precaution
    if (_player.playbackState == MPMoviePlaybackStatePlaying) {
        return;
    }

    // we don't need this again
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];

    // we've played so stop us un case we haven't stopped ourselves.
    [_player stop];

    // tell our delegate that we're done playing
//    [_delegate splashVideoComplete:self];

    // take our player out of the window, we're done with it
    [_player.view removeFromSuperview];
    _player = nil;

    [self splashVideoPlayFinished];
//    [UIApplication sharedApplication].delegate.window.transform = CGAffineTransformIdentity;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
