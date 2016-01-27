//
//  emailSignInVC.h
//  fancard
//
//  Created by MEETStudio on 15-9-21.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "BaseViewController.h"
#import "MTextField.h"

@interface emailSignInVC : BaseViewController <UITextFieldDelegate> {
    
    UIImageView *myImage;
    
    MTextField *emailTF;
    MTextField *passwordTF;

    UIImageView *ballDone;
    UIButton *done;

    NSString *email;
    NSString *password;
}
@end
