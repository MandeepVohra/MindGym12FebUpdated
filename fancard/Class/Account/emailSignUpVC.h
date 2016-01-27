//
//  emailSignUpVC.h
//  fancard
//
//  Created by MEETStudio on 15-9-21.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "BaseViewController.h"
#import "MTextField.h"

@interface emailSignUpVC : BaseViewController <UITextFieldDelegate> {
    
    UIImageView *myImage;   
        
    MTextField *firstNameTF;
    MTextField *lastNameTF;
    MTextField *emailTF;
    MTextField *passwordTF;
    
    UIView *hintView;
    UILabel *labelHint;
    
    UIImageView *ballDone;
    UIButton *done;
    
    NSString *firstName;
    NSString *lastName;
    NSString *_email;
    NSString *password;
}

@end
