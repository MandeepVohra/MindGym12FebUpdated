//
//  LeftViewController.m
//  fancard
//
//  Created by MEETStudio on 15-8-27.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "AnswerViewController.h"
#import "Mconfig.h"
#import "UIFactory.h"
#import "AnswerCell.h"
#import "UIButton+Extra.h"
#import "LanbaooPrefs.h"
#import "NSDate+FormatDateString.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, AnswerType) {
    botType = 2,
    friendType = 1,
};

typedef NS_ENUM(NSInteger, QuaterType) {
    quarterOne = 0,
    quarterTwo = 1,
    quarterThree = 2,
    quarterFour = 3,
};

@interface AnswerViewController () <UITableViewDataSource, UITableViewDelegate> {
    //top view
    UIView *_titleView;
    UIButton *_backButton;

    UIButton *_vsRandom;
    UIButton *_vsFriend;

    UITableView *_tableView;
    NSMutableArray *_friendQestionArr;
    NSMutableArray *_randomQestionArr;
    NSMutableArray *_questionArr;

    PagedFlowView *hFlowView;
    UIButton *selectedButton;

    AnswerType answerType;
    QuaterType quaterType;
}

@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    answerType = botType;

    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    _titleView.backgroundColor = [UIColor colorWithRed:162 / 255.0 green:0 blue:20 / 255.0 alpha:1.0f];
    [self.view addSubview:_titleView];
    _backButton = [UIFactory createButtonWithFrame:CGRectMake(5, 10, 44, 30)
                                            Target:self
                                          Selector:@selector(backToRootVC)
                                             Image:@"Btn_back"
                                      ImagePressed:@"Btn_back"];
    [_titleView addSubview:_backButton];

    _vsFriend = [UIFactory createButtonWithFrame:CGRectMake(kScreenWidth / 2, 14, 80, 30)
                                           Title:@"VS FRIEND"
                                          Target:self
                                        Selector:@selector(friendAction)];
    _vsFriend.backgroundColor = [UIColor clearColor];
    [_vsFriend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _vsFriend.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [_titleView addSubview:_vsFriend];

    _vsRandom = [UIFactory createButtonWithFrame:CGRectMake(kScreenWidth / 2 - 80, 14, 80, 30)
                                           Title:@"VS RANDOM"
                                          Target:self
                                        Selector:@selector(randomAction)];
    _vsRandom.backgroundColor = [UIColor clearColor];
    [_vsRandom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _vsRandom.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [_titleView addSubview:_vsRandom];

    UIImageView *box = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 44)];
    box.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pic_backgrd_Ans" ofType:@"png"]];

    box.userInteractionEnabled = YES;
    [self.view addSubview:box];

//    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
//    colorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.2f];
//    [box addSubview:colorView];

    hFlowView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
    hFlowView.delegate = self;
    hFlowView.dataSource = self;
//    hFlowView.pageControl = hPageControl;
    hFlowView.minimumPageAlpha = 1;
    hFlowView.minimumPageScale = 0.7;
//    [box addSubview:hFlowView];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 44 - 0) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    [box addSubview:_tableView];
    [self.view addSubview:_tableView];

    _tableView.tableHeaderView = hFlowView;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self getYesterdayQuizs];
}


- (void)backToRootVC {
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowRootVCNotification object:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Delegate

- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView; {
    return CGSizeMake(kScreenWidth / 3.0f, kScreenWidth / 12.0f);
}

- (void)flowView:(PagedFlowView *)flowView currentPageAtIndex:(NSInteger)index {

//    selectedButton.selected = NO;
//
//    UIButton *uiButton = (UIButton *) [flowView dequeueCell:index];
//    uiButton.selected = YES;
//
//    selectedButton = uiButton;
}


- (void)flowView:(PagedFlowView *)flowView didScrollToPageAtIndex:(NSInteger)index {
    NSLog(@"Scrolled to page # %d", index);

//    selectedButton.selected = NO;
//
//    UIButton *uiButton = (UIButton *) [flowView dequeueCell:index];
//    uiButton.selected = YES;
//
//    selectedButton = uiButton;
    QuaterType value;
    [@(index) getValue:&value];
    quaterType = value;

//    [self showHUD:@"Loading..." isDim:NO];
    [self getYesterdayQuizs];

}

- (void)flowView:(PagedFlowView *)flowView didTapPageAtIndex:(NSInteger)index {
    NSLog(@"Tapped on page # %d", index);

    [flowView scrollToPage:index];
//    QuaterType value;
//    [@(index) getValue:&value];
//    quaterType = value;
//
//    [self showHUD:@"Loading..." isDim:NO];
//    [self getYesterdayQuizs];

}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Datasource

- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView {
    return 4;
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
        uiButton.layer.cornerRadius = 2.0f / [UIScreen mainScreen].scale;
        uiButton.layer.masksToBounds = YES;

//        [uiButton setTitleColor:UIColorHex(0x1E1EF4) forState:UIControlStateNormal];
//        [uiButton setTitleColor:UIColorHex(0xFFFFFF) forState:UIControlStateSelected];
//
//        [uiButton setBackgroundColor:UIColorHex(0xB2B2B2) forState:UIControlStateNormal];
//        [uiButton setBackgroundColor:UIColorHex(0x1E1EF4) forState:UIControlStateSelected];

        [uiButton setTitleColor:UIColorHex(0xFFFFFF) forState:UIControlStateNormal];
        [uiButton setBackgroundColor:UIColorHexAlpha(0x000000, 0.4) forState:UIControlStateNormal];

    }

    if (index == 0) {
        [uiButton setTitle:@"1st Quarter" forState:UIControlStateNormal];
    } else if (index == 1) {
        [uiButton setTitle:@"2nd Quarter" forState:UIControlStateNormal];
    } else if (index == 2) {
        [uiButton setTitle:@"3rd Quarter" forState:UIControlStateNormal];
    } else {
        [uiButton setTitle:@"4th Quarter" forState:UIControlStateNormal];
    }

    return uiButton;

}

//get yesterday quiz
- (void)getYesterdayQuizs:(NSString *)year month:(NSString *)momth day:(NSString *)day {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
            @"command" : @"get_yesterday_quiz",
            @"year" : year,
            @"month" : momth,
            @"day" : day
    };
    [manager GET:kServerURL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {

//              NSLog(@"JSON:%@", responseObject);
             [BrowseAnsModel map];

             NSDictionary *Dic = [responseObject objectForKey:@"data"];
             NSDictionary *friend = [Dic objectForKey:@"friend"];
             NSDictionary *random = [Dic objectForKey:@"random"];

             _friendQestionArr = [BrowseAnsModel objectArrayWithKeyValuesArray:friend];
             _randomQestionArr = [BrowseAnsModel objectArrayWithKeyValuesArray:random];
             _questionArr = _randomQestionArr;
             [_tableView reloadData];

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error:%@", error);
//              [self getYesterdayQuizs:@"2015" month:@"10" day:@"26"];
            }];
}

//getYesterdayQuizs
- (void)getYesterdayQuizs {

    NSString *uid = [LanbaooPrefs sharedInstance].userId;

    [self hideHUD];
    [self showHUD:@"Loading..." isDim:NO];

    if (uid.length == 0) {
        [self hideHUD];
        return;
    }

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
            @"command" : @"last_game",
            @"uid" : uid,
            @"type" : @(answerType),
            @"quarter" : @(quaterType),
            @"date" : [[NSDate new] getDateStrWithFormat:kDateFormat]
    };
    [manager GET:kServerURL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {

             [self hideHUD];
//              NSLog(@"JSON:%@", responseObject);
             [BrowseAnsModel map];

             NSDictionary *dic = (NSDictionary *) [responseObject objectForKey:@"data"];
//             NSDictionary *friend = [Dic objectForKey:@"friend"];
//             NSDictionary *random = [Dic objectForKey:@"random"];
             _questionArr = [[NSMutableArray alloc] init];
             if (dic && [dic[@"result"] isKindOfClass:[NSArray class]]) {
                 _questionArr = [BrowseAnsModel objectArrayWithKeyValuesArray:dic[@"result"]];
             }

//             _friendQestionArr = [BrowseAnsModel objectArrayWithKeyValuesArray:friend];
//             _randomQestionArr = [BrowseAnsModel objectArrayWithKeyValuesArray:random];
//             _questionArr = _randomQestionArr;
             [_tableView reloadData];

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self hideHUD];
                NSLog(@"Error:%@", error);
                [self showHUdComplete:@"network error"];

//              [self getYesterdayQuizs:@"2015" month:@"10" day:@"26"];
            }];
}

- (void)friendAction {
//    _questionArr = _friendQestionArr;
//    [_tableView reloadData];
//    [self showHUD:@"Loading..." isDim:NO];

    answerType = friendType;
    [self getYesterdayQuizs];
    [_vsFriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_vsRandom setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)randomAction {
//    _questionArr = _randomQestionArr;
//    [_tableView reloadData];
//    [self showHUD:@"Loading..." isDim:NO];

    answerType = botType;
    [self getYesterdayQuizs];
    [_vsFriend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_vsRandom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_questionArr) {
        return _questionArr.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"AnswerCell";
    AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AnswerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.titleLabel.text = [NSString stringWithFormat:@"Question %ld", (indexPath.row + 1)];

    BrowseAnsModel *quizs = _questionArr[indexPath.row];
    cell.question = quizs;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
