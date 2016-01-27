//
//  BaseViewController.m
//  fancard
//
//  Created by MEETStudio on 15-8-27.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "BaseViewController.h"
#import "CMOpenALSoundManager+Singleton.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "Mconfig.h"
#import <MJExtension/MJExtension.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)loadView {
    [super loadView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 20);
    //        [self.navigationController.navigationBar setBarTintColor:UIColorHex(colorMain)];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }

    self.fd_interactivePopDisabled = YES;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

//    [[CMOpenALSoundManager singleton] purgeSounds];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    getHttpOK = NO;
    isNetErr = NO;
//    self.view.backgroundColor = [UIColor whiteColor];

    page = 1;
    pageSize = 10;
    hasNextPage = YES;

    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessage:) name:kSocketNotification object:nil];
}

- (void)didReceiveMessage:(NSNotification *)notification {
    NSString *message = [notification object];
    PushBean *pushBean = [PushBean objectWithKeyValues:message];
    if (pushBean) {
        NSString *action = pushBean.action;
        if (action.length > 0 && [action isEqualToString:@"challenge"]) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hud.mode = MBProgressHUDModeCustomView;
            self.hud.labelText = @"new challenger!";
            [self.hud setMode:MBProgressHUDModeText];
            [self.hud hide:1 afterDelay:1.5];
        }
    }
}

- (NFAppDelegate *)appDelegate {
    NFAppDelegate *appDelegate = (NFAppDelegate *) [UIApplication sharedApplication].delegate;
    return appDelegate;
}

- (void)addLeftBtnArrow {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:@"" forState:UIControlStateNormal];
    UIImage *btnImg = [UIImage imageNamed:@"Btn_back.png"];
    [btn setImage:btnImg forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    //    [btn setImageEdgeInsets:UIEdgeInsetsMake(5.0, 0.0, 5.0, 0.0)];
    [btn setContentEdgeInsets:UIEdgeInsetsMake(9.0, 0, 0, 0)];

    UIBarButtonItem *btnLeft = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                 target:self action:@selector(backPressed)];
//-------hejie-------
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleView;

    self.myTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 100, 34)];
    [self.navigationItem.titleView addSubview:_myTitle];
    _myTitle.textColor = [UIColor whiteColor];
    _myTitle.textAlignment = NSTextAlignmentCenter;
    _myTitle.font = [UIFont fontWithName:kAsapBoldFont size:20.0f];
    _myTitle.backgroundColor = [UIColor clearColor];

    negativeSpacer.width = iOS7 ? -10 : 0;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, btnLeft];

}

- (void)backPressed {
    if ([CMOpenALSoundManager singleton]) {
        if ([[CMOpenALSoundManager singleton] isBackGroundMusicPlaying]) {
            [[CMOpenALSoundManager singleton] stopBackgroundMusic];
        }
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"soundBtn"]) {
            [[CMOpenALSoundManager singleton] playSoundWithID:2];
        }
    }
    NSInteger n = [self.navigationController.childViewControllers count];
    if (n > 1) {
        //push
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        //present
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showHUD:(NSString *)title isDim:(BOOL)isDim {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = isDim;
    self.hud.labelText = title;
}

- (void)showHUdComplete:(NSString *)title {
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    if (title.length > 0) {
        self.hud.labelText = title;
    }
    [self.hud hide:YES afterDelay:1.0f];
}

- (void)showHUdCompleteWithTitle:(NSString *)title {
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    self.hud.mode = MBProgressHUDModeCustomView;
    if (title.length > 0) {
        self.hud.labelText = title;
    }
    [self.hud hide:YES afterDelay:1.0f];
}

- (void)showHit:(NSString *)hitText {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [hud setRemoveFromSuperViewOnHide:YES];
//    hud.color = UIColorHexAlpha(colorMain, 0.8);
    hud.opacity = 0.6f;
    [self.view addSubview:hud];
    if (hitText.length <= 7) {
        hud.labelText = hitText;
    } else {
        hud.detailsLabelText = hitText;
    }
    [hud setMode:MBProgressHUDModeText];
    hud.labelFont = [UIFont systemFontOfSize:14];
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [hud removeFromSuperview];
    }];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias {
    LLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags, alias);
}

- (void)hideHUD {
    [self.hud hide:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
