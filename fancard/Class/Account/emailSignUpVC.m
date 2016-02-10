//
//  emailSignUpVC.m
//  fancard
//
//  Created by MEETStudio on 15-9-21.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "emailSignUpVC.h"
#import "Mconfig.h"
#import <AFNetworking/AFNetworking.h>
#import <PureLayout/PureLayout.h>
#import <MJExtension/MJExtension.h>
#import <TPKeyboardAvoiding/TPKeyboardAvoidingScrollView.h>
#import <LKDBHelper/NSObject+LKDBHelper.h>
#import "emailSignInVC.h"
#import "UITextField+Custom.h"
#import "CMOpenALSoundManager.h"
#import "CMOpenALSoundManager+Singleton.h"
#import "LanbaooPrefs.h"
#import "UserInfo.h"
#import "APService.h"

//#define kRowHeight 52.0f

@interface emailSignUpVC ()

@end

@implementation emailSignUpVC {
    float kRowHeight;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    done.enabled = YES;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    kRowHeight = kScreenHeight > 480 ? 52.0f : 36.0f;
    self.navigationController.navigationBar.hidden = NO;
    [self addLeftBtnArrow];
    self.myTitle.text = @"Sign Up";

    TPKeyboardAvoidingScrollView *scroll = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 88)];
    scroll.bounds = scroll.frame;
    scroll.contentInset = UIEdgeInsetsMake(0, 0, -50.0f, 0);

    scroll.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scroll];
    UIView *box = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 88)];
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

    firstNameTF = [[MTextField alloc] init];
    firstNameTF.delegate = self;
    [firstNameTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];

    firstNameTF.backgroundColor = [UIColor clearColor];
    [firstNameTF customSomething:@"First Name"];
    [box addSubview:firstNameTF];
    [firstNameTF autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [firstNameTF autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [firstNameTF autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:myImage withOffset:0];
    [firstNameTF autoSetDimension:ALDimensionHeight toSize:kRowHeight];

    lastNameTF = [[MTextField alloc] init];
    lastNameTF.delegate = self;
    [lastNameTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [lastNameTF customSomething:@"Last Name"];
    lastNameTF.backgroundColor = [UIColor clearColor];
    [box addSubview:lastNameTF];
    [lastNameTF autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [lastNameTF autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [lastNameTF autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:firstNameTF];
    [lastNameTF autoSetDimension:ALDimensionHeight toSize:kRowHeight];

    emailTF = [[MTextField alloc] init];
    emailTF.delegate = self;

    [emailTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    emailTF.backgroundColor = [UIColor clearColor];
    [emailTF customSomething:@"Email"];
    [box addSubview:emailTF];
    [emailTF autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [emailTF autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [emailTF autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lastNameTF];
    [emailTF autoSetDimension:ALDimensionHeight toSize:kRowHeight];

    passwordTF = [[MTextField alloc] init];
    passwordTF.delegate = self;
    [passwordTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    passwordTF.secureTextEntry = YES;
    passwordTF.backgroundColor = [UIColor clearColor];
    [passwordTF customSomething:@"Password"];
    [box addSubview:passwordTF];
    [passwordTF autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [passwordTF autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [passwordTF autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:emailTF];
    [passwordTF autoSetDimension:ALDimensionHeight toSize:kRowHeight];

    hintView = [[UIView alloc] init];
    hintView.backgroundColor = [UIColor colorWithRed:44.0/255.0 green:151.0/255.0 blue:223.0/255.0 alpha:1.0];
    [self.view addSubview:hintView];
    [hintView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [hintView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [hintView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [hintView autoSetDimension:ALDimensionHeight toSize:44.0f];

    labelHint = [[UILabel alloc] init];
    labelHint.backgroundColor = [UIColor clearColor];
    labelHint.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSignIn)];
    [labelHint addGestureRecognizer:tap];
    NSString *str = @"Already have an account? Sign In";
    labelHint.text = str;
    labelHint.textColor = [UIColor whiteColor];
    labelHint.font = [UIFont fontWithName:kAsapRegularFont size:15.0f];
    labelHint.textAlignment = NSTextAlignmentCenter;
    [hintView addSubview:labelHint];
    [labelHint autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [labelHint autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [labelHint autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [labelHint autoPinEdgeToSuperviewEdge:ALEdgeRight];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:kAsapBoldFont size:16.0f] range:[str rangeOfString:@"Sign In"]];
    [labelHint setAttributedText:string];

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
    done.selected = NO;
    done.titleLabel.font = [UIFont fontWithName:kAsapBoldFont size:25.0f];
    [box addSubview:done];
    [done autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:passwordTF withOffset:0];
    [done autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:ballDone withOffset:0];
    [done autoSetDimension:ALDimensionHeight toSize:50.0f];
    [done autoSetDimension:ALDimensionWidth toSize:100.0f];
    [done addTarget:self action:@selector(SignUpButton) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - textFieldChanged

- (void)textFieldChanged:(UITextField *)textField {
    textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
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
    if (firstNameTF.text.length > 0 && lastNameTF.text.length > 0 && emailTF.text.length > 0 && passwordTF.text.length > 0) {
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        return YES;
    }
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (firstNameTF == textField || lastNameTF == textField) {
        if ([toBeString length] > 11) {
            textField.text = [toBeString substringToIndex:11];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"More than the maximum count" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    return YES;
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

- (void)toSignIn {
    if ([CMOpenALSoundManager singleton]) {
        [[CMOpenALSoundManager singleton] playSoundWithID:2];
    }
    emailSignInVC *signin = [[emailSignInVC alloc] init];
    [self.navigationController pushViewController:signin animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)SignUpButton {
    if ([self isReadyToSignUp]) {

        firstName = firstNameTF.text;
        lastName = lastNameTF.text;
        _email = emailTF.text;
        password = passwordTF.text;
        if ([self validateEmail:_email]) {
            [self postTokenMethod];
        } else {
            NSString *title = @"Illegal E-mail";

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:title delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }

    } else {
        NSString *title = @"Please Fill\n The Blank Space";

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:title delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];

        [[CMOpenALSoundManager singleton] playSoundWithID:3];
    }
}

- (void)postTokenMethod {
    [self.view endEditing:YES];
    [self showHUD:@"Please wait..." isDim:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
            @"command" : @"register",
            @"email" : _email,
            @"password" : password,
            @"firstname" : firstName,
            @"lastname" : lastName
    };

    [manager POST:kServerURL
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {

              [self hideHUD];
              [LanbaooPrefs sharedInstance].loginMail = _email;

              NSLog(@"JSON:%@", responseObject);
              NSDictionary *userModel = [responseObject objectForKey:@"data"];

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

                  [self performSelector:@selector(toHome) withObject:self afterDelay:1.2f];
              } else {
                  NSString *title = @"Account already exists, please Sign in.";
                  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:title delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                  [alertView show];
              }

          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error:%@", error);
                [self hideHUD];
                NSString *title = @"Please check the network Settings";

                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:title delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
            }];
}

- (void)toHome {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
