//
//  AppDelegate.m
//  fancard
//
//  Created by MEETStudio on 15-8-27.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "NFAppDelegate.h"
#import "HomeViewController.h"
#import "AnswerViewController.h"
#import "TrainerViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <SimpleAuth/SimpleAuth.h>
#import "Mconfig.h"
#import <APService.h>
#import <DCIntrospect-ARC/DCIntrospect.h>
#import "CMOpenALSoundManager.h"
#import "CMOpenALSoundManager+Singleton.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import <Google/Google/GGLContext.h>
#import "MySocket.h"
#import "NSDictionary+NotNULL.h"
#import "LanbaooPrefs.h"
#import "UserInfo.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>

@interface NFAppDelegate () {

}

@end

@implementation NFAppDelegate

#pragma mark - Private

//config Twitter
- (void)configureAuthorizaionProviders {
    SimpleAuth.configuration[@"twitter-web"] = @{@"consumer_key" : consumer_key,
            @"consumer_secret" : consumer_secret};
}

//get user rank
- (void)_getUserRank {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"command" : @"rank_list_total"};

    [manager GET:kServerURL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//             NSLog(@"JSON: %@", responseObject);
             int userId = [LanbaooPrefs sharedInstance].userId.intValue;
             int rank = 999;
             NSMutableArray *arrayDic = [responseObject objectForKey:@"data"];
             NSArray *userArray = [UserInfo objectArrayWithKeyValuesArray:arrayDic];
             for (int i = 0; i < userArray.count; i++) {
                 UserInfo *tops = userArray[i];
                 if (tops.id.intValue == userId) {
                     rank = i + 1;
                 }
//                 NSLog(@"userid:%d",tops.id);
             }

             if (rank > 999) {
                 rank = 999;
             }
             [LanbaooPrefs sharedInstance].rank = rank;

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
}

//Audio file array initialization
- (void)initSoundFileArray {
    if ([CMOpenALSoundManager singleton]) {
        [CMOpenALSoundManager singleton].soundEffectsVolume = 1.0f;
        [CMOpenALSoundManager singleton].soundFileNames = @[
                kTimeRunningOut,
                kCountDown,
                kDribble,
                kWhistle,
                kBucketsFaDays,
                kBallin,
                kAfter3rdQua,
                kWelcome,
                kChallengeAlert,
                kSendChallenge,
                kBeenWaiting
        ];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];

    [[MySocket singleton] initWebSocket];  //init webSocket
    [self initSoundFileArray];                //Audio file array initialization
    [self _getUserRank];                      //get player rank

    if ([LanbaooPrefs sharedInstance].userId) {
        //Sign up push notifications
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                        UIRemoteNotificationTypeSound |
                        UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    [APService setupWithOption:launchOptions];

    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter addObserver:self selector:@selector(networkDidSetup:) name:kJPFNetworkDidSetupNotification object:nil];
//    [defaultCenter addObserver:self selector:@selector(networkDidClose:) name:kJPFNetworkDidCloseNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidRegister:) name:kJPFNetworkDidRegisterNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];
//    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
//    [defaultCenter addObserver:self selector:@selector(serviceError:) name:kJPFServiceErrorNotification object:nil];


    //Setting the global navigation bar color and font color
    [[UINavigationBar appearance] setBarTintColor:KNewHeader];
    [[UINavigationBar appearance] setTintColor:[UIColor purpleColor]];

    NSURL *portraitUrl = [[NSBundle mainBundle] URLForResource:@"FC-Stamp-2" withExtension:@"mp4"];

    XOSplashVideoController *controller =
            [[XOSplashVideoController alloc] initWithVideoPortraitUrl:portraitUrl
                                                    portraitImageName:nil
                                                         landscapeUrl:nil
                                                   landscapeImageName:nil
                                                             delegate:self];

    self.window.rootViewController = controller;

//    MyFightViewController *vc = [[MyFightViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
#if TARGET_IPHONE_SIMULATOR
    [[DCIntrospect sharedIntrospector] start];
#endif

    [self configureAuthorizaionProviders];
    [FBSDKLoginButton class];

    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
//    [[Twitter sharedInstance] startWithConsumerKey:@"A6gLd4bX2F5MPc4Tlsgm3h5ep" consumerSecret:@"UHdSLjMmkKT9jO2ThxFtThnyoVckLtowbeqhz261orMIy3UpQ4"];
    [Fabric with:@[[Twitter class]]];

//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(userDefaultsDidChange:)
//                                                 name:NSUserDefaultsDidChangeNotification
//                                               object:nil];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults addObserver:self forKeyPath:@"userId" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [userDefaults addObserver:self forKeyPath:@"userId" options:NSKeyValueObservingOptionNew context:nil];

    return YES;
}

- (void)userDefaultsDidChange:(NSNotification *)userDefaultsDidChange {

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"userId change %@", change);
    NSString *uid = [change getString:@"new"];
    if (uid.length > 0) {
        [[MySocket singleton] initWebSocket];
    } else {
        [[MySocket singleton].sRWebSocket close];
    }
}

- (void)splashVideoComplete:(XOSplashVideoController *)splashVideo {
    MainViewController *main = [[MainViewController alloc] init];
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:main];
    [navCtrl.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.window.rootViewController = navCtrl;
}

- (void)splashVideoLoaded:(XOSplashVideoController *)splashVideo {
 //   HomeViewController *homeCtrl = [[HomeViewController alloc] init];
   // UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:homeCtrl];
    
    
    
    
   // AnswerViewController *leftCtrl = [[AnswerViewController alloc] init];
    //TrainerViewController *rightCtrl = [[TrainerViewController alloc] init];

   // _menuCtrl = [[DDMenuController alloc] initWithRootViewController:navCtrl];

    //_menuCtrl.leftViewController = leftCtrl;
    //_menuCtrl.rightViewController = rightCtrl;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    //    [APService stopLogPageView:@"aa"];
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the application
    // and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.

    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [LanbaooPrefs sharedInstance].challengerId = nil;
}

- (void)                             application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

//    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [APService registerDeviceToken:deviceToken];
}

- (void)                             application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1

- (void)                application:(UIApplication *)application
didRegisterUserNotificationSettings:
        (UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)       application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
      forLocalNotification:(UILocalNotification *)notification
         completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)       application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
     forRemoteNotification:(NSDictionary *)userInfo
         completionHandler:(void (^)())completionHandler {
}

#endif

- (void)         application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
    NSLog(@"Notified:%@", [self logDic:userInfo]);

}

- (void)         application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
      fetchCompletionHandler:
              (void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    NSLog(@"Notified:%@", [self logDic:userInfo]);


    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)        application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
            [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                         withString:@"\\U"];
    NSString *tempStr2 =
            [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
            [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
            [NSPropertyListSerialization propertyListFromData:tempData
                                             mutabilityOption:NSPropertyListImmutable
                                                       format:NULL
                                             errorDescription:NULL];
    return str;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"URL scheme:%@", [url scheme]);
    //call-back URL
    if ([[url scheme] containsString:@"fb"]) {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    } else {
//        return [GPPURLHandler handleURL:url
//                      sourceApplication:sourceApplication
//                             annotation:annotation];
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation];


    }
    return YES;
}

- (void)networkDidRegister:(NSNotification *)notification {
    LLog(@"%@", [notification userInfo]);
    LLog(@"registered");
    if ([LanbaooPrefs sharedInstance].userId) {

        [APService setAlias:[NSString stringWithFormat:@"%@%@", @"user", [LanbaooPrefs sharedInstance].userId]
           callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                     object:self];
    }
}

- (void)networkDidLogin:(NSNotification *)notification {
    LLog(@"Has logged");
    if ([LanbaooPrefs sharedInstance].userId) {

        [APService setAlias:[NSString stringWithFormat:@"%@%@", @"user", [LanbaooPrefs sharedInstance].userId]
           callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                     object:self];

    }
    if ([APService registrationID]) {
        LLog(@"get RegistrationID = %@", [APService registrationID]);
    }
}


- (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias {
    LLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags, alias);
}

@end
