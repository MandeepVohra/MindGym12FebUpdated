//  LogInViewController.m
//  fancard
//  thirdpaty login
//  Created by MEETStudio on 15-9-11.

//  Copyright (c) 2015 MEETStudio. All rights reserved.
//
#import "LogInViewController.h"
#import "Mconfig.h"
#import "UIViewExt.h"
#import <GoogleSignIn/GIDGoogleUser.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "emailSignUpVC.h"
#import "CMOpenALSoundManager.h"
#import "CMOpenALSoundManager+Singleton.h"
#import "FacebookUser.h"
#import "SingUpUser.h"
#import "GIDProfileData.h"
#import "UserInfo.h"
#import "NSObject+LKDBHelper.h"
#import "LanbaooPrefs.h"
#import "APService.h"
#import <TwitterKit/Twitter.h>
#import <TwitterKit/TWTRUser.h>


@interface LogInViewController () {

    UIImageView *_loginView;

    UIButton *_facebook;
    UIButton *_twitter;
    UIButton *_google;
    UIButton *_email;

    NSString *token;       //  platform uniquely identifies
    int platform;          //  1:FaceBook 2:Twitter 3:Google
}

@end

@implementation LogInViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = NO;
    [self addLeftBtnArrow];
    self.myTitle.text = @"Log In";

    _loginView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44)];
    NSString *loginPath = [[NSBundle mainBundle] pathForResource:@"signin" ofType:@"png"];
    _loginView.image = [UIImage imageWithContentsOfFile:loginPath];
    _loginView.userInteractionEnabled = YES;
    [self.view addSubview:_loginView];

    //Facebook
    _facebook = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _loginView.height / 4)];
    _facebook.backgroundColor = [UIColor clearColor];
    [_facebook addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_loginView addSubview:_facebook];

    //Twitter
    _twitter = [[UIButton alloc] initWithFrame:CGRectMake(0, _facebook.bottom, kScreenWidth, _loginView.height / 4)];
    _twitter.backgroundColor = [UIColor clearColor];
    [_twitter addTarget:self action:@selector(TwtSignIn) forControlEvents:UIControlEventTouchUpInside];
    [_loginView addSubview:_twitter];

    //Google
    _google = [[UIButton alloc] initWithFrame:CGRectMake(0, _twitter.bottom, kScreenWidth, _loginView.height / 4)];
    _google.backgroundColor = [UIColor clearColor];
    [_google addTarget:self action:@selector(signInGoogle) forControlEvents:UIControlEventTouchUpInside];
    [_loginView addSubview:_google];

    //email
    _email = [[UIButton alloc] initWithFrame:CGRectMake(0, _google.bottom, kScreenWidth, _loginView.height / 4)];
    _email.backgroundColor = [UIColor clearColor];
    [_email addTarget:self action:@selector(clickToEmail) forControlEvents:UIControlEventTouchUpInside];
    [_loginView addSubview:_email];
}

- (void)backPressed {
    if ([CMOpenALSoundManager singleton]) {
        [[CMOpenALSoundManager singleton] playSoundWithID:2];
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

- (void)clickToEmail {
    emailSignUpVC *email = [[emailSignUpVC alloc] init];
    [self.navigationController pushViewController:email animated:YES];
}

//Facebook Login
- (void)loginButtonClicked {

    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    NSArray *permissionsArray = @[@"email", @"public_profile", @"user_friends"];
    [login logInWithReadPermissions:permissionsArray handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
            NSLog(@"error %@", error);
        } else if (result.isCancelled) {
            // Handle cancellations
            NSLog(@"Cancelled");
        } else {
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
                [self fetchUserInfo];
            }
        }
    }];

}

- (void)fetchUserInfo {

    if ([FBSDKAccessToken currentAccessToken]) {

        [self showHUD:@"" isDim:YES];
        NSLog(@"Token is available");

//        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" parameters:nil]
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields" : @"id,name,link,first_name,last_name,picture.type(large),email,birthday,bio,friends,friendlists"}]
                startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        NSLog(@"Fetched User Information:%@", result);

                        FacebookUser *facebookUser = [FacebookUser objectWithKeyValues:result];

                        SingUpUser *singUpUser = [[SingUpUser alloc] init];
                        singUpUser.firstname = facebookUser.first_name;
                        singUpUser.lastname = facebookUser.last_name;
                        singUpUser.avatar = (facebookUser.picture && facebookUser.picture.data) ? facebookUser.picture.data.url : @"";
                        singUpUser.token = facebookUser.id;
                        singUpUser.command = @"third_platform";
                        singUpUser.platform = @"3";

                        [self postTokenMethod:singUpUser.keyValues];

                    }
                    else {
                        NSLog(@"Error %@", error);
                        [self hideHUD];
                    }
                }];

    } else {
        [self hideHUD];
        NSLog(@"User is not Logged in");
    }

//    // For more complex open graph stories, use `FBSDKShareAPI`
//// with `FBSDKShareOpenGraphContent`
///* make the API call */
//    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
//            initWithGraphPath:@"/me/friends"
//                   parameters:nil
//                   HTTPMethod:@"GET"];
//    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
//            id result,
//            NSError *error) {
//        // Handle the result
//        LLog(@"/me/friends result = %@", result);
//    }];
}


//Twitter login
- (void)TwtSignIn {

    [self showHUD:@"" isDim:YES];
//    [SimpleAuth authorize:@"twitter" completion:^(id responseObject, NSError *error) {
//        NSDictionary *result = responseObject;
//        LLog(@"error = %@\n%@", error, result);
//        if (!error) {
//            SingUpUser *singUpUser = [[SingUpUser alloc] init];
////            singUpUser.firstname = facebookUser.first_name;
////            singUpUser.lastname = facebookUser.last_name;
////            singUpUser.avatar = (facebookUser.picture && facebookUser.picture.data) ? facebookUser.picture.data.url : @"";
////            singUpUser.token = facebookUser.id;
//            singUpUser.command = @"third_platform";
//            singUpUser.platform = @"3";
//
//            [self postTokenMethod:singUpUser.keyValues];
//        }
//
//    }];

//    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"iFJrhBed9KVOXbrcc7zJ03yFz"
//                                                            consumerSecret:@"KHLT2Ugq99Y2HtlgX8wj3I53YRKaFRZwuYl50YzmjPuwfbq68F"];
//
//
//
//    [twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
//
//        LLog(@"username = %@ ID=%@", username , userID);
//        [twitter getUserTimelineWithScreenName:username
//                                  successBlock:^(NSArray *statuses) {
//                                      // ...
//                                      LLog(@"statuses = %@", statuses);
//                                  } errorBlock:^(NSError *error) {
//                    // ...
//                }];
//
//    } errorBlock:^(NSError *error) {
//        // ...
//        LLog(@"error = %@", error);
//    }];


    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            LLog(@"logged in user with id %@", session.userID);

            /* Get user info */
            [[[Twitter sharedInstance] APIClient] loadUserWithID:[session userID]
                                                      completion:^(TWTRUser *user,
                                                              NSError *error) {
                                                          // handle the response or error
                                                          if (![error isEqual:nil]) {
                                                              LLog(@"Twitter info   -> user = %@ ", user.keyValues);

                                                              SingUpUser *singUpUser = [[SingUpUser alloc] init];
                                                              singUpUser.firstname = user.screenName;
                                                              singUpUser.lastname = @"";
                                                              singUpUser.avatar = user.profileImageURL;
                                                              singUpUser.token = user.userID;
                                                              singUpUser.command = @"third_platform";
                                                              singUpUser.platform = @"2";

                                                              [self postTokenMethod:singUpUser.keyValues];

                                                          } else {
                                                              LLog(@"Twitter error getting profile : %@", [error localizedDescription]);
                                                              [self hideHUD];
                                                          }
                                                      }];

        } else {
            // log error
            [self hideHUD];
            LLog(@"error = %@", error);
        }
    }];

}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {

}

#pragma mark - GPPSignInDelegate

//- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
//                   error:(NSError *)error {
//        NSLog(@"Received error %@ and auth object %@",error, auth);
//
//
//    GIDSignIn *gppSignIn = [GPPSignIn sharedInstance];
//
//    LLog(@"gppSignIn = %@", gppSignIn.keyValues);
//
//    LLog(@"googlePlusUser = %@", gppSignIn.googlePlusUser.keyValues);
//
//    LLog(@"gppSignIn.googlePlusUser = %@", gppSignIn.googlePlusUser.name.familyName);
//
//    if (error) {
//
//    } else {
//        token = [GPPSignIn sharedInstance].userID;
//
//        NSLog(@"token:%@", token);
//        platform = 3;
//        [self postTokenMethod];
//        [self refreshInterfaceBasedOnSignIn];
//    }
//}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    LLog(@"signIn = %@", signIn.keyValues);
    LLog(@"GIDGoogleUser = %@", user.keyValues);

    if (user) {
        SingUpUser *singUpUser = [[SingUpUser alloc] init];
        NSMutableArray *array = [[user.profile.name componentsSeparatedByString:@" "] mutableCopy];
        if (array) {
            if (array.count == 1) {
                singUpUser.firstname = array[0];
                singUpUser.lastname = @"";
            }
            if (array.count == 2) {
                singUpUser.firstname = array[0];
                singUpUser.lastname = array[1];
            } else {
                singUpUser.firstname = array[0];
                [array removeObjectAtIndex:0];
                singUpUser.lastname = [array componentsJoinedByString:@" "];
            }
        }
        singUpUser.token = user.userID;
        singUpUser.command = @"third_platform";
        singUpUser.platform = @"1";

        [self postTokenMethod:singUpUser.keyValues];
    } else {
        [self hideHUD];
    }
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {

}


- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {

}

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signInGoogle {
    GIDSignIn *gidSignIn = [GIDSignIn sharedInstance];
//    [gidSignIn signOut];
    gidSignIn.shouldFetchBasicProfile = YES;
//    gidSignIn.shouldFetchGoogleUserEmail = YES;
//    gidSignIn.shouldFetchGoogleUserID = YES;
    gidSignIn.clientID = kClientId;
//    gidSignIn.scopes = @[kGTLAuthScopePlusLogin,kGTLAuthScopePlusMe,kGTLAuthScopePlusUserinfoEmail,kGTLAuthScopePlusUserinfoProfile];
//    gidSignIn.scopes = @[@"profile"];
    gidSignIn.delegate = self;
    gidSignIn.uiDelegate = self;
    [gidSignIn signIn];
    [self showHUD:@"" isDim:YES];
}

- (void)refreshInterfaceBasedOnSignIn {
//    if ([[GPPSignIn sharedInstance] authentication]) {
//
//    }
}

- (void)postTokenMethod:(NSDictionary *)parameters {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"third_platform",@"command",
//                                @(platform),@"platform",
//                                token,@"token",
//                                nil];
//    NSDictionary *parameters = @{
//            @"command" : @"third_platform",
//            @"platform" : @(platform),
//            @"token" : token
//    };
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    LLog(@"parameters = %@", parameters);
    [manager POST:kServerURL
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {

              [self hideHUD];
              NSLog(@"postToken JSON:%@", responseObject);
              NSDictionary *userModel = (NSDictionary *) [responseObject objectForKey:@"data"];

              UserInfo *userInfo = [UserInfo objectWithKeyValues:userModel];
              [userInfo updateToDB];

              [LanbaooPrefs sharedInstance].userId = userInfo.id;
              [LanbaooPrefs sharedInstance].userName = [NSString stringWithFormat:@"%@ %@", userInfo.firstname, userInfo.lastname];

              [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                              UIRemoteNotificationTypeSound |
                              UIRemoteNotificationTypeAlert)
                                                 categories:nil];

              if ([LanbaooPrefs sharedInstance].userId) {

                  [APService setAlias:[NSString stringWithFormat:@"%@%@", @"user", [LanbaooPrefs sharedInstance].userId]
                     callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                               object:self];

              }

              [self _homeAction];
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self hideHUD];
                NSLog(@"Error:%@", error);
            }];
}

- (void)_homeAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
