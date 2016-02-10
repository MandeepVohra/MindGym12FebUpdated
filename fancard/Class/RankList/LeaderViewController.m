//
//  LeaderViewController.m
//  fancard
//  Leaderboard

//  Created by MEETStudio on 15-8-27.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "LeaderViewController.h"
#import "UIFactory.h"
#import "Mconfig.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "VSInfoViewController.h"
#import "CMOpenALSoundManager+Singleton.h"
#import "UIViewExt.h"
#import "NSDate+FormatDateString.h"
#import <PureLayout/PureLayout.h>
#import <LKDBHelper/NSObject+LKDBHelper.h>
#import <MJRefresh/MJRefreshComponent.h>
#import <MJRefresh/MJRefreshAutoNormalFooter.h>
#import <MJRefresh/MJRefreshNormalHeader.h>
#import "MySocket.h"
#import "UIButton+Extra.h"
#import "UserInfo.h"
#import "LanbaooPrefs.h"
#import "NSDictionary+NotNULL.h"
#import "LevelsFindFriendViewController.h"
#import "NSString+StringFormatDate.h"
#import "LeadersCell.h"


typedef NS_ENUM(NSInteger, RankListTimeType) {
    thisWeekType = 1,
    lastWeekType = 2,
};

typedef NS_ENUM(NSInteger, RanType) {
    top100Type = 1,
    friendType = 2,
    thirdPartType = 3,
};

@interface LeaderViewController () <UITableViewDelegate, UITableViewDataSource,LeadersDelegate,addFriendDelegate> {

//-----------titleView---------------
    UIView *_titleView;
    UIButton *_backButton;
    UIButton *_lastWeek;
    UIButton *_thisWeek;
    UIButton *_findFiend;

//-----------challenger information---------
    int _friendId;

//-------------select button---------------
    UIButton *topButton;
    UIButton *friendButton;
    UIButton *verified;

//------------alert view-----------------
    UIView *_background;
    UIButton *_cancelButton;
    UIView *_challengeView;
    UILabel *_oppNameLabel;
    UIButton *_buttonChallenge;   //send challenge

    NSMutableArray *_userArray;

    int userId;

    UserInfo *_userModel;

    PagedFlowView *hFlowView;
    UIButton *selectedButton;

    RankListTimeType listTimeType;
    RanType rankType;

}

@end

@implementation LeaderViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (![LanbaooPrefs sharedInstance].musicOff) {
        [[CMOpenALSoundManager singleton] playBackgroundMusic:@"Mind-Gym-Main.mp3"];
    }

}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [hFlowView scrollToPage:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    listTimeType = thisWeekType;
    rankType = top100Type;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessage:) name:kSocketNotification object:nil];

    userId = [LanbaooPrefs sharedInstance].userId.intValue;

    if (![LanbaooPrefs sharedInstance].musicOff) {
        [[CMOpenALSoundManager singleton] playBackgroundMusic:@"Weekly Leaders.mp3"];
    }
    self.view.backgroundColor = [UIColor lightGrayColor];

//-----------------------------------title view--------------------------------------
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    _titleView.backgroundColor = [UIColor colorWithRed:162 / 255.0 green:0 blue:20 / 255.0 alpha:1.0f];
    [self.view addSubview:_titleView];
    _backButton = [UIFactory createButtonWithFrame:CGRectMake(5, 10, 44, 30)
                                            Target:self
                                          Selector:@selector(backPressed)
                                             Image:@"Btn_back"
                                      ImagePressed:@"Btn_back"];
    [_titleView addSubview:_backButton];

    _lastWeek = [UIFactory createButtonWithFrame:CGRectMake(kScreenWidth / 2 - 80, 14, 80, 30)
                                           Title:@"LAST WEEK"
                                          Target:self
                                        Selector:@selector(lastweekButton)];
    _lastWeek.backgroundColor = [UIColor clearColor];
    [_lastWeek setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _lastWeek.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [_titleView addSubview:_lastWeek];

    _thisWeek = [UIFactory createButtonWithFrame:CGRectMake(kScreenWidth / 2, 14, 80, 30)
                                           Title:@"THIS WEEK"
                                          Target:self
                                        Selector:@selector(thisweekButton)];
    _thisWeek.backgroundColor = [UIColor clearColor];
    [_thisWeek setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _thisWeek.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [_titleView addSubview:_thisWeek];

    _findFiend = [UIFactory createButtonWithFrame:CGRectMake(kScreenWidth - 44, 0, 44, 44)
                                           Target:self
                                         Selector:@selector(findfriend)
                                            Image:@"findFriend.png"
                                     ImagePressed:@"findFriend.png"];
    [_titleView addSubview:_findFiend];

//-------------------------------select view----------------------------------
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth / 2.5f)];
    buttonView.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:buttonView];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth / 2.5f)];
    imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"leader_head_bg" ofType:@"png"]];
    [buttonView addSubview:imageView];

    CGFloat btnWidth = (roundf(kScreenWidth / 3.0f) - 20.0f);

    hFlowView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 120)];
    hFlowView.delegate = self;
    hFlowView.dataSource = self;
//    hFlowView.pageControl = hPageControl;
    hFlowView.minimumPageAlpha = 1;
    hFlowView.minimumPageScale = 0.7;

    topButton = [UIButton buttonWithType:UIButtonTypeCustom];

    topButton.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
    topButton.layer.cornerRadius = 3;
    topButton.layer.masksToBounds = YES;

//    if (self.isFindFriend) {
//       [topButton setBackgroundColor:[UIColor clearColor]];
//    }else {
//        [topButton setBackgroundColor:[UIColor whiteColor]];
//    }
    topButton.selected = !self.isFindFriend;

    [topButton setTitleColor:UIColorHex(0x1E1EF4) forState:UIControlStateNormal];
    [topButton setTitleColor:UIColorHex(0xFFFFFF) forState:UIControlStateSelected];

    [topButton setBackgroundColor:UIColorHex(0xB2B2B2) forState:UIControlStateNormal];
    [topButton setBackgroundColor:UIColorHex(0x1E1EF4) forState:UIControlStateSelected];

    [topButton setTitle:@"Top100" forState:UIControlStateNormal];
    [topButton setTitle:@"Top100" forState:UIControlStateSelected];
//    [topButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [topButton setTitleColor:kMyRedColor forState:UIControlStateHighlighted];
    topButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    topButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [buttonView addSubview:topButton];
    [topButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0f];
//    [topButton autoPinEdgeToSuperviewEdge:ALEdgeTop  withInset:40.0f];
    [topButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:40.0f];
    [topButton autoSetDimension:ALDimensionWidth toSize:btnWidth];
    [topButton autoSetDimension:ALDimensionHeight toSize:40.0f];
    [topButton addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];

    friendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    friendButton.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
    friendButton.layer.cornerRadius = 3;
    friendButton.layer.masksToBounds = YES;
//    if (self.isFindFriend) {
//        [friendButton setBackgroundColor:[UIColor whiteColor]];
//    }else {
//        [friendButton setBackgroundColor:[UIColor clearColor]];
//    }

    [friendButton setTitleColor:UIColorHex(0x1E1EF4) forState:UIControlStateNormal];
    [friendButton setTitleColor:UIColorHex(0xFFFFFF) forState:UIControlStateSelected];

    [friendButton setBackgroundColor:UIColorHex(0xB2B2B2) forState:UIControlStateNormal];
    [friendButton setBackgroundColor:UIColorHex(0x1E1EF4) forState:UIControlStateSelected];

    friendButton.selected = self.isFindFriend;

    [friendButton setTitle:@"Friends" forState:UIControlStateNormal];
    [friendButton setTitle:@"Friends" forState:UIControlStateSelected];
//    [friendButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [friendButton setTitleColor:kMyRedColor forState:UIControlStateHighlighted];
    friendButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    friendButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [buttonView addSubview:friendButton];
//    [friendButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:120.0f];
//    [friendButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:40.0f];
    [friendButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [friendButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20.0f];
    [friendButton autoSetDimension:ALDimensionWidth toSize:btnWidth];
    [friendButton autoSetDimension:ALDimensionHeight toSize:40.0f];
    [friendButton addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];

    selectedButton = self.isFindFriend ? friendButton : topButton;

    verified = [UIButton buttonWithType:UIButtonTypeCustom];

    verified.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
    verified.layer.cornerRadius = 3;
    verified.layer.masksToBounds = YES;

    [verified setTitleColor:UIColorHex(0x1E1EF4) forState:UIControlStateNormal];
    [verified setTitleColor:UIColorHex(0xFFFFFF) forState:UIControlStateSelected];

    [verified setBackgroundColor:UIColorHex(0xB2B2B2) forState:UIControlStateNormal];
    [verified setBackgroundColor:UIColorHex(0x1E1EF4) forState:UIControlStateSelected];

    [verified setTitle:@"Verified" forState:UIControlStateNormal];
    [verified setTitle:@"Verified" forState:UIControlStateSelected];
//    [verified setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [verified setTitleColor:kMyRedColor forState:UIControlStateHighlighted];
    verified.titleLabel.textAlignment = NSTextAlignmentCenter;
    verified.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [buttonView addSubview:verified];
    [verified autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0f];
//    [verified autoPinEdgeToSuperviewEdge:ALEdgeTop  withInset:40.0f];
    [verified autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:40.0f];
    [verified autoSetDimension:ALDimensionWidth toSize:btnWidth];
    [verified autoSetDimension:ALDimensionHeight toSize:40.0f];
    [verified addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 44) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor lightGrayColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.hidden = YES;

    _tableView.tableHeaderView = buttonView;

//-------------------------------alert view---------------------------------
    _background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:_background];
    _background.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f];
    _background.hidden = YES;

    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(kScreenWidth - 50, 10, 50, 50);
    [_cancelButton setImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
    _cancelButton.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [_background addSubview:_cancelButton];

    _challengeView = [[UIView alloc] init];
    _challengeView.backgroundColor = [UIColor whiteColor];
    [_background addSubview:_challengeView];
    [_challengeView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f];
    [_challengeView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:150.0f];
    [_challengeView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
    [_challengeView autoSetDimension:ALDimensionHeight toSize:220.0f];
    _challengeView.userInteractionEnabled = YES;

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Today's Challenge";
    [titleLabel setTextColor:[UIColor blackColor]];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:kAsapRegularFont size:20.0f];
    [_challengeView addSubview:titleLabel];
    [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40.0f];
    [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40.0f];
    [titleLabel autoSetDimension:ALDimensionHeight toSize:50.0f];

    UIButton *vsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vsButton setTitle:@"vs" forState:UIControlStateNormal];
    [vsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    vsButton.titleLabel.font = [UIFont fontWithName:kAsapBoldFont size:14.0f];
    [vsButton.layer setMasksToBounds:YES];
    [vsButton.layer setCornerRadius:10.0f];
    vsButton.backgroundColor = [UIColor blackColor];
    [_challengeView addSubview:vsButton];
    [vsButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:40.0f];
    [vsButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:132.0f];
    [vsButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:132.0f];
    [vsButton autoSetDimension:ALDimensionHeight toSize:20.0f];

    UILabel *line1 = [[UILabel alloc] init];
    line1.backgroundColor = [UIColor blackColor];
    [_challengeView addSubview:line1];
    [line1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:49.0f];
    [line1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0f];
    [line1 autoSetDimension:ALDimensionWidth toSize:120.0f];
    [line1 autoSetDimension:ALDimensionHeight toSize:1.0f];

    UILabel *line2 = [[UILabel alloc] init];
    line2.backgroundColor = [UIColor blackColor];
    [_challengeView addSubview:line2];
    [line2 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:49.0f];
    [line2 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
    [line2 autoSetDimension:ALDimensionWidth toSize:120.0f];
    [line2 autoSetDimension:ALDimensionHeight toSize:1.0f];

    _oppNameLabel = [[UILabel alloc] init];
    _oppNameLabel.text = @"FirstName LastName";
    [_oppNameLabel setTextColor:kMyBlue];
    _oppNameLabel.textAlignment = NSTextAlignmentCenter;
    _oppNameLabel.font = [UIFont fontWithName:kAsapRegularFont size:23.0f];
    [_challengeView addSubview:_oppNameLabel];
    [_oppNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:50.0f];
    [_oppNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_oppNameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_oppNameLabel autoSetDimension:ALDimensionHeight toSize:50.0f];

    _buttonChallenge = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonChallenge.backgroundColor = [UIColor redColor];
    [_buttonChallenge setTitle:@"Challenge!" forState:UIControlStateNormal];
    [_buttonChallenge setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonChallenge setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    _buttonChallenge.titleLabel.font = [UIFont boldSystemFontOfSize:40.0f];
    [_challengeView addSubview:_buttonChallenge];
    [_buttonChallenge autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:100.0f];
    [_buttonChallenge autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0f];
    [_buttonChallenge autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
    [_buttonChallenge autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:30.0f];
    [_buttonChallenge addTarget:self action:@selector(chanllengeSomebody) forControlEvents:UIControlEventTouchUpInside];

    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.text = @"They will receive a notification to join the match!";
    [hintLabel setTextColor:[UIColor redColor]];
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.font = [UIFont fontWithName:kAsapRegularFont size:12.0f];
    [_challengeView addSubview:hintLabel];
    [hintLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:190.0f];
    [hintLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [hintLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [hintLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];

    [self showHUD:@"Loading..." isDim:NO];
    [self _parseJson];

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTop)];
    [header setTitle:@"pull to refresh" forState:MJRefreshStateIdle];
    [header setTitle:@"" forState:MJRefreshStatePulling];
    [header setTitle:@"loading..." forState:MJRefreshStateRefreshing];
    [header setLastUpdatedTimeKey:[NSString stringWithFormat:@"%@TopTime", NSStringFromClass([self class])]];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreBottom)];
    [footer setTitle:@"click to load more" forState:MJRefreshStateIdle];
    [footer setTitle:@"loading more..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"no more data" forState:MJRefreshStateNoMoreData];

    header.lastUpdatedTimeLabel.hidden = YES;

    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;

    self.tableView.mj_footer.automaticallyHidden = NO;
    self.tableView.mj_footer.hidden = YES;
//    [self.tableView.mj_header beginRefreshing];

//    [self loadHotShareFromPlist];
}


- (void)loadMoreBottom {
    if (hasNextPage) {
        [self _parseJson];
    } else {
        WS(weakSelf)
        int64_t delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        });
    }
}

- (void)refreshTop {
    page = 1;
    hasNextPage = YES;
    getHttpOK = NO;
    isNetErr = NO;
    [self _parseJson];
}

#pragma mark -select button

- (void)changeType:(UIButton *)btn {

    selectedButton.selected = NO;
    btn.selected = YES;
    selectedButton = btn;

    self.isFindFriend = (btn == friendButton);

    if (btn == topButton) {
        rankType = top100Type;
    } else if (btn == friendButton) {
        rankType = friendType;
    } else {
        rankType = thirdPartType;
    }

    [self showHUD:@"Loading..." isDim:NO];

    [self refreshTop];

}

- (void)top100 {
    [topButton setBackgroundColor:[UIColor whiteColor]];
    [friendButton setBackgroundColor:[UIColor clearColor]];
    [verified setBackgroundColor:[UIColor clearColor]];
    self.isFindFriend = NO;
    [self _parseJson];
}

- (void)myFriends {
    [topButton setBackgroundColor:[UIColor clearColor]];
    [friendButton setBackgroundColor:[UIColor whiteColor]];
    [verified setBackgroundColor:[UIColor clearColor]];
    self.isFindFriend = YES;
    [self _parseJson];
}

- (void)verified {
    [topButton setBackgroundColor:[UIColor clearColor]];
    [friendButton setBackgroundColor:[UIColor clearColor]];
    [verified setBackgroundColor:[UIColor whiteColor]];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Delegate

- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView; {
    return CGSizeMake(kScreenWidth / 3.0f, kScreenWidth / 6.0f);
}

- (void)flowView:(PagedFlowView *)flowView currentPageAtIndex:(NSInteger)index {

    selectedButton.selected = NO;

    UIButton *uiButton = (UIButton *) [flowView dequeueCell:index];
    uiButton.selected = YES;

    selectedButton = uiButton;
}


- (void)flowView:(PagedFlowView *)flowView didScrollToPageAtIndex:(NSInteger)index {
    NSLog(@"Scrolled to page # %d", index);

    selectedButton.selected = NO;

    UIButton *uiButton = (UIButton *) [flowView dequeueCell:index];
    uiButton.selected = YES;

    selectedButton = uiButton;

}

- (void)flowView:(PagedFlowView *)flowView didTapPageAtIndex:(NSInteger)index {
    NSLog(@"Tapped on page # %d", index);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Datasource

- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView {
    return 3;
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
//    UIImageView *imageView = (UIImageView *)[flowView dequeueReusableCell];
//    if (!imageView) {
//        imageView = [[UIImageView alloc] init];
//        imageView.layer.cornerRadius = 6;
//        imageView.layer.masksToBounds = YES;
//    }
//    imageView.backgroundColor = [UIColor blueColor];
//    return imageView;

    UIButton *uiButton = (UIButton *) [flowView dequeueReusableCell];
    if (!uiButton) {
        uiButton = [[UIButton alloc] init];
        uiButton.userInteractionEnabled = NO;
        uiButton.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
        uiButton.layer.cornerRadius = 3;
        uiButton.layer.masksToBounds = YES;

        [uiButton setTitleColor:UIColorHex(0x1E1EF4) forState:UIControlStateNormal];
        [uiButton setTitleColor:UIColorHex(0xFFFFFF) forState:UIControlStateSelected];

        [uiButton setBackgroundColor:UIColorHex(0xB2B2B2) forState:UIControlStateNormal];
        [uiButton setBackgroundColor:UIColorHex(0x1E1EF4) forState:UIControlStateSelected];
    }

    if (index == 0) {
        [uiButton setTitle:@"FRIENDS" forState:UIControlStateNormal];
    } else if (index == 1) {
        [uiButton setTitle:@"TOP 100" forState:UIControlStateNormal];
    } else {
        [uiButton setTitle:@"VERIFIED" forState:UIControlStateNormal];
    }

    return uiButton;

}

- (void)_parseJson {
//    _tableView.hidden = YES;
    NSDictionary *parameters = [NSDictionary new];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    if (self.isFindFriend) {
//        parameters = @{
//                @"command" : @"rank_list",
//                @"time":@(listTimeType),
//                @"uid" : @(userId),
//                @"type" : @(rankType)
//        };
//    } else {
//
//    }

    parameters = @{@"command" : @"rank_list",
            @"time" : @(listTimeType),
            @"uid" : @(userId),
            @"type" : @(rankType),
            @"p" : @(page),
            @"s" : @(pageSize),
    };

    [manager GET:kServerURL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             LLog(@"operation.response.URL.absoluteString = %@", operation.response.URL.absoluteString);
             _tableView.hidden = NO;

             if (!_userArray || page == 1) {
                 _userArray = [[NSMutableArray alloc] init];
             }

             [self hideHUD];
//             NSLog(@"JSON: %@", responseObject);
             NSDictionary *dic = (NSDictionary *) [responseObject objectForKey:@"data"];
             NSMutableArray *arrayDic = dic[@"result"];
             NSMutableArray *userArray = [UserInfo objectArrayWithKeyValuesArray:arrayDic];
//             if (_userArray.count == 0) {
//                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
//                                                                     message:@"Add some friends from top100!"
//                                                                    delegate:nil
//                                                           cancelButtonTitle:@"OK"
//                                                           otherButtonTitles:nil];
//                 [alertView show];
//             }

             if (userArray && userArray.count > 0) {
                 [_userArray addObjectsFromArray:userArray];
             }

             [_tableView reloadData];

             NSLog(@"---%lu", (unsigned long) _userArray.count);
//             for (TopHundredModel *tops in _userArray) {
//
//                 NSLog(@"id=%d", tops.id);
//             }

             hasNextPage = [dic getBool:@"hasNext"];
             self.tableView.mj_footer.hidden = (_userArray.count < pageSize);
             if (hasNextPage) {
                 page++;
             }

             if (rankType == top100Type) {
                 if (page > 10) {
                     hasNextPage = NO;
                 }
             }

             [self.tableView.mj_footer endRefreshing];
             [self.tableView.mj_header endRefreshing];

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
//                [self _parseJson];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
                [self showHUdComplete:@"error"];
            }];
}

#pragma mark -
#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _userArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"LeadersCell";
    LeadersCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[LeadersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        if ((7.0 <= [[[UIDevice currentDevice] systemVersion] doubleValue]) &&
                ([[[UIDevice currentDevice] systemVersion] doubleValue] < 8.0)) {
            cell.contentView.height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }

    
    
    
    
    
    
    cell.rankIndex = @(indexPath.row + 1).stringValue;

    UserInfo *tops = _userArray[indexPath.row];
    cell.delegate = self;
    cell.FDelegate = self;
    cell.topModel = tops;

    NSInteger num = tops.points_week;
    if (num >= 999) {
        long h = num % 1000;
        long k = num / 1000;
        cell.numPoints.text = [NSString stringWithFormat:@"%ld,%.3ld", k, h];
    } else {
        cell.numPoints.text = [NSString stringWithFormat:@"%d", tops.points_week];
    }

    [cell.myStarRateView level:tops.number_win];
    NSString *name = [NSString stringWithFormat:@"%@ %@", tops.firstname, tops.lastname];
    NSString *wonLost = [NSString stringWithFormat:@"%d-%d", tops.number_week_win, tops.number_week_lost];
    cell.wonLost.text = wonLost;
    cell.userName.text = [NSString stringWithFormat:@"%ld.%@", (long) indexPath.row + 1, name];
    
    if ((tops.type.intValue == 3) || ((int) userId == tops.id.intValue))
    {
        [cell.sendChallenge setBackgroundImage:[UIImage imageNamed:@"pic_ball_Ans.png"] forState:UIControlStateNormal];
    } else {

        [cell.sendChallenge setBackgroundImage:[UIImage imageNamed:@"pic_ball_Leader.png"] forState:UIControlStateNormal];

        NSDate *dateNow = [NSDate new];
        NSString *dateNowStr = [dateNow getDateStrWithFormat:@"yyyy-MM-dd"];


        NSString *dateStr = tops.lastFrdFight;
        NSDate *dateFight = [dateStr getDateWithFormat:kDateFormat];

        if (dateFight) {
            if ([dateNowStr isEqualToString:[dateFight getDateStrWithFormat:@"yyyy-MM-dd"]]) {
                [cell.sendChallenge setBackgroundImage:[UIImage imageNamed:@"pic_ball_Ans.png"] forState:UIControlStateNormal];
            }
        }

    }
    [cell.sendChallenge addTarget:self action:@selector(SetChallangeMethod:) forControlEvents:UIControlEventTouchUpInside];
//    UIButton *buttonChallenge = [UIButton buttonWithType:UIButtonTypeCustom];
//    [buttonChallenge addTarget:self
//                        action:@selector(SetChallangeMethod:)
//              forControlEvents:UIControlEventTouchUpInside];
//    [buttonChallenge setBackgroundImage:[UIImage imageNamed:@"pic_ball_Leader.png"] forState:UIControlStateNormal];
//    CGSize imageSize = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pic_ball_Leader" ofType:@"png"]].size;
//    float myWidth = 91 * imageSize.width / imageSize.height;
//    [buttonChallenge setTag:indexPath.row];
//    buttonChallenge.frame = CGRectMake(kScreenWidth - myWidth + 35, -3, myWidth, 91);
//    [cell.contentView addSubview:buttonChallenge];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)addFriendByUserModel:(UserInfo *)userModel {
    [self showHUD:@"being added..." isDim:NO];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
            @"command" : @"add_friends",
            @"uid" : @(userId),
            @"fid" : userModel.id
    };
    [manager POST:kServerURL
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {

              NSLog(@"JSON:%@", responseObject);
              NSString *message = [responseObject objectForKey:@"message"];
              if ([message isEqualToString:@"he is your friend,you can not add again"]) {
                  message = @"already your friend!";
                  [self showHUdCompleteWithTitle:message];
              } else {
                  [self showHUdComplete:message];
              }

          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error:%@", error);
                [self showHUdCompleteWithTitle:@"check the network!"];
            }];
}

- (void)toChallenge:(UserInfo *)userModels withRank:rank {

    NSLog(@"challenge");

    int type = userModels.type.intValue;
    _userModel = userModels;
    NSString *alertString = @"alert";

    if (type == 3 || userId == userModels.id.intValue) {
        if (userId == (int) userModels.id) {
            alertString = @"Yourself!";
        } else {
            alertString = @"User has already played VS a Friend today!";
        }
        [[CMOpenALSoundManager singleton] playSoundWithID:3];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:alertString
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    } else {

        UserInfo *userInfo = [UserInfo searchSingleWithWhere:nil orderBy:nil];

        NSString *dateStr = userInfo.lastFrdFight;
        NSDate *dateFight = [dateStr getDateWithFormat:kDateFormat];

        NSDate *dateNow = [NSDate new];
        NSString *dateNowStr = [dateNow getDateStrWithFormat:@"yyyy-MM-dd"];

        if (dateFight) {

            if ([dateNowStr isEqualToString:[dateFight getDateStrWithFormat:@"yyyy-MM-dd"]]) {
                [[CMOpenALSoundManager singleton] playSoundWithID:3];
                [[[UIAlertView alloc] initWithTitle:@"Alert"
                                            message:@"You have already played today."
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];

                return;
            }
        }


        dateStr = userModels.lastFrdFight;
        dateFight = [dateStr getDateWithFormat:kDateFormat];

        if (dateFight) {
            if ([dateNowStr isEqualToString:[dateFight getDateStrWithFormat:@"yyyy-MM-dd"]]) {
                [[[UIAlertView alloc] initWithTitle:@"Alert"
                                            message:@"They have already played today."
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];

                return;
            }
        }

        //alert
        _background.hidden = NO;
        NSString *name = [NSString stringWithFormat:@"%@ %@", userModels.firstname, userModels.lastname];
        _oppNameLabel.text = name;
        _friendModel = userModels;
        _friendModel.rank = rank;
        _friendId = userModels.id.intValue;
    }
}

#pragma mark -
#pragma mark - alert actions

- (void)cancelAction {
    _background.hidden = YES;
}

- (void)chanllengeSomebody {
    if ([CMOpenALSoundManager singleton]) {
        [[CMOpenALSoundManager singleton] playSoundWithID:9];
    }

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
            @"command" : @"challenge_friend",
            @"uid" : @(userId),
            @"fid" : @(_friendId),
    };

    [manager GET:kServerURL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);

             UserInfo *userInfo = [UserInfo searchSingleWithWhere:nil orderBy:nil];

             NSLog(@"challenge");
             PushBean *pushBean = [[PushBean alloc] init];
             pushBean.uid = @(userId).stringValue;
             pushBean.toUid = @(_friendId).stringValue;
             pushBean.userInfo = userInfo;
             pushBean.action = @"challenge";
             double gapTime = [LanbaooPrefs sharedInstance].gapTime;
             NSLog(@"gapTime:%f", gapTime);
             NSDate *tureTime = [[NSDate new] dateByAddingTimeInterval:gapTime];
             NSLog(@"tureTime:%@", tureTime);
             pushBean.pushTime = [tureTime getDateStrWithFormat:kDateFormat];
             if ([MySocket singleton].sRWebSocket.readyState == SR_OPEN) {
                 [[MySocket singleton].sRWebSocket send:pushBean.JSONString];
                 VSInfoViewController *vsCtrl = [[VSInfoViewController alloc] init];
                 vsCtrl.isChallenger = YES;
                 vsCtrl.friendId = _friendId;
                 vsCtrl.friendModel = _friendModel;
                 [self.navigationController pushViewController:vsCtrl animated:YES];
             }

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];

}

#pragma mark -
#pragma mark - titleView Actions

- (void)lastweekButton {
    listTimeType = lastWeekType;

    [self showHUD:@"Loading..." isDim:NO];

    [self refreshTop];

    [_lastWeek setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_thisWeek setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)thisweekButton {
    listTimeType = thisWeekType;

    [self showHUD:@"Loading..." isDim:NO];

    [self refreshTop];

    [_lastWeek setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_thisWeek setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)findfriend {
    LevelsFindFriendViewController *controller = [[LevelsFindFriendViewController alloc] init];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.view.window.rootViewController presentViewController:controller animated:YES completion:nil];

//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
//    [self presentViewController:nav animated:YES completion:nil];
}


-(void)SetChallangeMethod:(UIButton *)butt{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
