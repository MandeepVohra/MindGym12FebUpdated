//
//  AppDelegate.h
//  fancard
//
//  Created by MEETStudio on 15-8-27.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMenuController.h"
#import "XOSplashVideoController.h"
#import "MainViewController.h"
#import "GIDSignIn.h"

@interface NFAppDelegate : UIResponder <UIApplicationDelegate, XOSplashVideoDelegate>

@property(strong, nonatomic) UIWindow *window;
@property(strong, nonatomic) DDMenuController *menuCtrl;
@end

