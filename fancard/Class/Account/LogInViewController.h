//
//  LogInViewController.h
//  fancard
//
//  Created by MEETStudio on 15-9-11.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "BaseViewController.h"
#import "GIDSignIn.h"
#import <FBSDKLoginKit/FBSDKLoginButton.h>

@interface LogInViewController : BaseViewController <GIDSignInDelegate, GIDSignInUIDelegate>

@end
