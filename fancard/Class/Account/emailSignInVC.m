//
//  emailSignInVC.m
//  fancard
//
//  Created by MEETStudio on 15-9-21.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "emailSignInVC.h"
#import "Mconfig.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import <TPKeyboardAvoiding/TPKeyboardAvoidingScrollView.h>
#import <PureLayout/PureLayout.h>
#import <LKDBHelper/NSObject+LKDBHelper.h>
#import "UITextField+Custom.h"
#import "CMOpenALSoundManager.h"
#import "CMOpenALSoundManager+Singleton.h"
#import "UserInfo.h"
#import "LanbaooPrefs.h"
#import "APService.h"

#define kRowHeight 52.0f

@interface emailSignInVC ()

@end

@implementation emailSignInVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    done.enabled = YES;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    [self addLeftBtnArrow];
    self.myTitle.text = @"Sign In";

    TPKeyboardAvoidingScrollView *scroll = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44)];
    NSLog(@"%f", kScreenHeight - 88);
    scroll.bounds = scroll.frame;

    scroll.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scroll];
    UIView *box = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44)];
    box.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:box];

    CGSize imageSize = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_signUp" ofType:@"png"]].size;
    float myheight = kScreenWidth * imageSize.height / imageSize.width;
    myImage = [[UIImageView alloc] init];
    myImage.backgroundColor = [UIColor orangeColor];
    [box addSubview:myImage];
    myImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_signUp" ofType:@"png"]];
    [myImage autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [myImage autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [myImage autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [myImage autoSetDimension:ALDimensionHeight toSize:myheight];

    emailTF = [[MTextField alloc] init];
    emailTF.backgroundColor = [UIColor clearColor];
    emailTF.delegate = self;
    [emailTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [emailTF customSomething:@"Email"];
    [box addSubview:emailTF];
    [emailTF autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [emailTF autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [emailTF autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:myImage withOffset:0];
    [emailTF autoSetDimension:ALDimensionHeight toSize:kRowHeight];

    if ([LanbaooPrefs sharedInstance].loginMail) {
        emailTF.text = [LanbaooPrefs sharedInstance].loginMail;
    }

    passwordTF = [[MTextField alloc] init];
    [passwordTF customSomething:@"Password"];
    passwordTF.delegate = self;
    [passwordTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    passwordTF.secureTextEntry = YES;
    passwordTF.backgroundColor = [UIColor clearColor];
    [box addSubview:passwordTF];
    [passwordTF autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [passwordTF autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [passwordTF autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:emailTF];
    [passwordTF autoSetDimension:ALDimensionHeight toSize:kRowHeight];

    ballDone = [[UIImageView alloc] init];
    [ballDone setImage:[UIImage imageNamed:@"ball_signUp"]];
    [box addSubview:ballDone];
    [ballDone autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:12.0f];
    [ballDone autoSetDimension:ALDimensionWidth toSize:30.0f];
    [ballDone autoSetDimension:ALDimensionHeight toSize:30.0f];
    [ballDone autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:passwordTF withOffset:10.0f];
    ballDone.hidden = YES;

    done = [[UIButton alloc] init];
    done.backgroundColor = [UIColor clearColor];
    done.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [done setTitle:@"DONE" forState:UIControlStateNormal];
    [done setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [done setTitleColor:kMyRedColor forState:UIControlStateSelected];
    done.titleLabel.font = [UIFont fontWithName:kAsapBoldFont size:25.0f];
    [box addSubview:done];
    [done autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:passwordTF withOffset:0];
    [done autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:ballDone withOffset:0];
    [done autoSetDimension:ALDimensionHeight toSize:50.0f];
    [done autoSetDimension:ALDimensionWidth toSize:100.0f];
    [done addTarget:self action:@selector(SignInButton) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - textFieldChanged and display the ball

- (void)textFieldChanged:(UITextField *)textField {
    if ([textField isEditing]) {
        ballDone.hidden = YES;
        done.selected = NO;
    }

    if ([self isReadyToSignUp]) {
//        ballDone.hidden = NO;
        done.selected = YES;
    } else {
        ballDone.hidden = YES;
        done.selected = NO;
    }
}

- (BOOL)isReadyToSignUp {
    if (emailTF.text.length > 0 && passwordTF.text.length > 0) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.leftView.hidden = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.leftView.hidden = YES;

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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)SignInButton {
    if ([self isReadyToSignUp]) {
        done.enabled = NO;
        email = emailTF.text;
        password = passwordTF.text;
        [self postTokenMethod];
    }
    else {
        [[CMOpenALSoundManager singleton] playSoundWithID:3];
        NSString *title = @"Please Fill\n The Blank Space";

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:title delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }
}

- (void)postTokenMethod {
    [self.view endEditing:YES];
    [self showHUD:@"Please wait..." isDim:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
            @"command" : @"login",
            @"username" : email,
            @"password" : password
    };

    [manager POST:kServerURL
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {

              [self hideHUD];
              [LanbaooPrefs sharedInstance].loginMail = email;

              NSLog(@"JSON:%@", responseObject);

              NSDictionary *userModel = (NSDictionary *) [responseObject objectForKey:@"data"];

              UserInfo *userInfo = [UserInfo objectWithKeyValues:userModel];
              if (userInfo.email.length > 0) {
                  [userInfo updateToDB];

                  [LanbaooPrefs sharedInstance].userId = userInfo.id;
                  [LanbaooPrefs sharedInstance].userName = [NSString stringWithFormat:@"%@ %@", userInfo.firstname, userInfo.lastname];

                  [self showHUdComplete:@"Successful"];

                  [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                  UIRemoteNotificationTypeSound |
                                  UIRemoteNotificationTypeAlert)
                                                     categories:nil];

                  if ([LanbaooPrefs sharedInstance].userId) {

                      [APService setAlias:[NSString stringWithFormat:@"%@%@", @"user", [LanbaooPrefs sharedInstance].userId]
                         callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                                   object:self];

                  }

                  [self performSelector:@selector(toHome) withObject:self afterDelay:1.3f];
              } else {

                  NSString *title = @"Account or password error";
                  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:title delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                  [alertView show];
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error:%@", error);
                NSString *title = @"Network error";
                [self hideHUD];
                done.enabled = YES;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:title delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
            }];
}

- (void)toHome {

    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                    UIRemoteNotificationTypeSound |
                    UIRemoteNotificationTypeAlert)
                                       categories:nil];

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
