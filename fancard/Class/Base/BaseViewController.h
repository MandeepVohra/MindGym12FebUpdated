//
//  BaseViewController.h
//  fancard
//
//  Created by MEETStudio on 15-8-27.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NFAppDelegate.h"
#import "MBProgressHUD.h"
#import "PushBean.h"

@interface BaseViewController : UIViewController {
    int page;
    int pageSize;
    BOOL hasNextPage;
    BOOL getHttpOK;
    BOOL isNetErr;
}

@property(nonatomic, strong) UILabel *myTitle;
@property(nonatomic, strong) MBProgressHUD *hud;

- (void)didReceiveMessage:(NSNotification *)notification;

- (NFAppDelegate *)appDelegate;

- (void)addLeftBtnArrow;

- (void)backPressed;



//HUD
- (void)showHUD:(NSString *)title isDim:(BOOL)isDim;

- (void)showHUdComplete:(NSString *)title;

- (void)showHUdCompleteWithTitle:(NSString *)title;

- (void)showHit:(NSString *)hitText;

- (void)hideHUD;

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias;
@end
