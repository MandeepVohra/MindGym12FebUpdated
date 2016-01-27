//
//  LevelsViewController.m
//  fancard
//
//  Created by MEETStudio on 15-9-9.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <LKDBHelper/NSObject+LKDBHelper.h>
#import "LevelsViewController.h"
#import "Mconfig.h"
#import "levelsCell.h"
#import "CMOpenALSoundManager+Singleton.h"
#import "UserInfo.h"

#define kZeroWon @"kZeroWon"
#define PROSPECT @"PROSPECT"
#define ROOKIE   @"ROOKIE"
#define STARTER  @"STARTER"
#define ALLSTAR  @"ALL-STAR"
#define MVP      @"MVP"

@interface LevelsViewController () <UITableViewDataSource, UITableViewDelegate> {
    UIButton *_backButton;
    UIImageView *_upperImage;
    UITableView *_tableView;

    NSArray *_winsNumArray;
    NSArray *_levelNameArray;
    NSArray *_perArray1;         //permission
    NSArray *_perArray2;

    NSMutableArray *_starsArray;

    UIImage *_lockerImage;
    UIImage *_unlockedImage;
}

@end

@implementation LevelsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[CMOpenALSoundManager singleton] playBackgroundMusic:@"Gym Levels.mp3"];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    [self addLeftBtnArrow];
    self.myTitle.text = @"Levels";

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

    _winsNumArray = @[@"1", @"5", @"25", @"75", @"125"];

    _levelNameArray = @[@"PROSPECT", @"ROOKIE", @"STARTER", @"ALL-STAR", @"MVP"];

    _perArray1 = @[@"Challenge Friends",
            @"Professional Arena",
            @"Arena Upgrades",
            @"More Arena Upgrades",
            @"MindGym Arena"
    ];

    _perArray2 = @[@"Position yourself to get Drafted!",
            @"Challenge Verified Accounts",
            @"New Music",
            @"Trick Shots",
            @"Incredible Dunks"
    ];

    _lockerImage = [UIImage imageNamed:@"icon_locker.png"];
    _unlockedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_lock" ofType:@"png"]];
}

- (NSString *)myLevel:(long)winNumber {
    NSString *level = kZeroWon;
    if (winNumber == 0) {
        level = kZeroWon;

    } else if (winNumber > 0 && winNumber < 5) {
        level = PROSPECT;

    } else if (winNumber >= 5 && winNumber < 25) {
        level = ROOKIE;

    } else if (winNumber >= 25 && winNumber < 75) {
        level = STARTER;

    } else if (winNumber >= 75 && winNumber < 125) {
        level = ALLSTAR;

    } else if (winNumber >= 125) {
        level = MVP;
    }
    return level;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"levelsCell";
    levelsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[levelsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.labelWins.text = @"WINS";
    cell.locks.image = _lockerImage;
    if (indexPath.row == 0) {
        cell.labelWins.text = @"WIN";
    }

    UserInfo *userInfo = [UserInfo searchSingleWithWhere:nil orderBy:nil];
    if (!userInfo) {
        userInfo = [[UserInfo alloc] init];
    }

    NSString *myLevel = [self myLevel:userInfo.number_win];
    if ([myLevel isEqualToString:PROSPECT] && indexPath.row == 0) {
        cell.locks.image = [UIImage imageNamed:@"icon_lock"];
        cell.leftView.backgroundColor = kMyBlue;
        cell.levelName.textColor = kMyBlue;

    } else if ([myLevel isEqualToString:ROOKIE] && (indexPath.row == 0 || indexPath.row == 1)) {
        cell.locks.image = [UIImage imageNamed:@"icon_lock"];
        cell.leftView.backgroundColor = kMyBlue;
        cell.levelName.textColor = kMyBlue;

    } else if ([myLevel isEqualToString:STARTER] && indexPath.row != 3 && indexPath.row != 4) {
        cell.locks.image = [UIImage imageNamed:@"icon_lock"];
        cell.leftView.backgroundColor = kMyBlue;
        cell.levelName.textColor = kMyBlue;

    } else if ([myLevel isEqualToString:ALLSTAR] && indexPath.row != 4) {
        cell.locks.image = [UIImage imageNamed:@"icon_lock"];
        cell.leftView.backgroundColor = kMyBlue;
        cell.levelName.textColor = kMyBlue;

    } else if ([myLevel isEqualToString:MVP]) {
        cell.locks.image = [UIImage imageNamed:@"icon_lock"];
        cell.leftView.backgroundColor = kMyBlue;
        cell.levelName.textColor = kMyBlue;
    }

    cell.labelWinNum.text = _winsNumArray[indexPath.row];
    cell.levelName.text = _levelNameArray[indexPath.row];
    [cell.myStarRateView starNum:(indexPath.row + 1)];
    cell.privilege1.text = _perArray1[indexPath.row];
    cell.privilege2.text = _perArray2[indexPath.row];
    if (indexPath.row == 4) {
        cell.labelWinNum.font = [UIFont fontWithName:kAsapBoldFont size:23.0f];
        NSString *str = _perArray1[4];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
        [string addAttribute:NSForegroundColorAttributeName value:kMyBlue range:[str rangeOfString:@"Gym"]];
        [cell.privilege1 setAttributedText:string];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (kScreenHeight - 44) / 5;
}

- (void)backAction {
    if ([[CMOpenALSoundManager singleton] isBackGroundMusicPlaying]) {
        [[CMOpenALSoundManager singleton] stopBackgroundMusic];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
