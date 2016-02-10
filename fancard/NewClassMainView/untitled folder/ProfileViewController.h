//
//  ProfileViewController.h
//  fancard
//
//  Created by Mandeep on 03/02/16.
//  Copyright © 2016 MEETStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mconfig.h"
@interface ProfileViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>{
    UIView *_titleView;
    UIButton *_backButton;
    NSString *stringCompare;
    UIImage *imagePick;
}
@property (nonatomic,retain) UIImageView *ProfilePic,*BackroundPic;
@end
