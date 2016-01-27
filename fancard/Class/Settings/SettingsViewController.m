//
//  SettingsViewController.m
//  fancard
//
//  Created by MEETStudio on 15-8-27.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <LKDBHelper/LKDBHelper.h>
#import "SettingsViewController.h"
#import "Mconfig.h"
#import "SettingsCell.h"
#import "CMOpenALSoundManager+Singleton.h"
#import "UIButton+Extra.h"
#import "UserInfo.h"
#import "LanbaooPrefs.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (![LanbaooPrefs sharedInstance].musicOff) {
        [[CMOpenALSoundManager singleton] playBackgroundMusic:@"Settings.mp3"];
    }

//    if (![LanbaooPrefs sharedInstance].musicOff) {
//        [[CMOpenALSoundManager singleton] playBackgroundMusic:@"Mind-Gym-Main.mp3"];
//    }

    [_tableView reloadData];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    [self addLeftBtnArrow];
    self.myTitle.text = @"Settings";

//bottom view
    _caption = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    _caption.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"caption" ofType:@"png"]];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

    _tableView.tableHeaderView = _titleView;
    _tableView.tableFooterView = _caption;

    UIImage *noti = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_notifications" ofType:@"png"]];
    UIImage *music = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_music" ofType:@"png"]];
    UIImage *sound = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_sound" ofType:@"png"]];
    UIImage *howPlay = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_play" ofType:@"png"]];
    UIImage *contact = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_contact" ofType:@"png"]];
    UIImage *terms = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_terms" ofType:@"png"]];
    UIImage *privacy = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_privacy" ofType:@"png"]];
    UIImage *logout = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_log" ofType:@"png"]];
    _iconArray = @[noti, music, sound, howPlay, contact, terms, privacy, logout];

    cellHeight = (kScreenHeight - (44 + 80 + 20)) / 8;
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = NSStringFromClass([SettingsCell class]);
    SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SettingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

        cell.backgroundColor = [UIColor colorWithRed:178 / 255.0 green:178 / 255.0 blue:178 / 255.0 alpha:1.0f];
        NSArray *funcArray = @[@"Notifications", @"Music", @"Sound FX", @"How to Play", @"Contact Us", @"Terms of Use", @"Privacy Policy", @"Log Out"];

        cell.iconView.image = _iconArray[indexPath.section];
        cell.funcListLabel.text = funcArray[indexPath.section];
    }
    if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2) {

        UIView *white = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 50, 0, 50, cellHeight)];
        white.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:white];

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kScreenWidth - 90, -1, 80, cellHeight + 2);
        [btn setBackgroundColor:[UIColor blueColor]];

        [btn.layer setMasksToBounds:YES];
        [btn setTitle:@"ON" forState:UIControlStateNormal];
        [btn setTitle:@"OFF" forState:UIControlStateSelected];
        [btn setBackgroundColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn.layer setCornerRadius:cellHeight / 2 + 1];
        [btn.layer setBorderWidth:3.0f];
        [btn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [cell.contentView addSubview:btn];
        if (indexPath.section == 0) {
            btn.selected = [LanbaooPrefs sharedInstance].notificationOff;
            [btn addTarget:self action:@selector(notificationControl:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (indexPath.section == 1) {
            btn.selected = [LanbaooPrefs sharedInstance].musicOff;
            [btn addTarget:self action:@selector(musicControl:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (indexPath.section == 2) {
            btn.selected = [LanbaooPrefs sharedInstance].soundOff;
            [btn addTarget:self action:@selector(soundControl:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return cell;
}

- (void)notificationControl:(UIButton *)btn {
    btn.selected = !btn.selected;
    [LanbaooPrefs sharedInstance].notificationOff = btn.selected;
}

- (void)musicControl:(UIButton *)btn {
    btn.selected = !btn.selected;
    [LanbaooPrefs sharedInstance].musicOff = btn.selected;

    if (btn.selected) {
        if ([[CMOpenALSoundManager singleton] isBackGroundMusicPlaying]) {
            [[CMOpenALSoundManager singleton] stopBackgroundMusic];
        }
    } else {
        [[CMOpenALSoundManager singleton] playBackgroundMusic:@"Settings.mp3"];
    }
}

- (void)soundControl:(UIButton *)btn {
    btn.selected = !btn.selected;
    [LanbaooPrefs sharedInstance].soundOff = btn.selected;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (kScreenHeight - (50 + 80 + 20)) / 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //logout
    if (indexPath.section == 7) {
        if ([[CMOpenALSoundManager singleton] isBackGroundMusicPlaying]) {
            [[CMOpenALSoundManager singleton] stopBackgroundMusic];
        }
        [[CMOpenALSoundManager singleton] purgeSounds];
        NSLog(@"######select LogOut");

        LKDBHelper *globalHelper = [UserInfo getUsingLKDBHelper];
        [globalHelper dropTableWithClass:[UserInfo class]];

        [LanbaooPrefs sharedInstance].userId = nil;
//        [self resetDefaults];
        [self backPressed];
//        LogInViewController *logIn = [[LogInViewController alloc] init];
//        [self.navigationController pushViewController:logIn animated:YES];
    }
}

- (void)resetDefaults {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
