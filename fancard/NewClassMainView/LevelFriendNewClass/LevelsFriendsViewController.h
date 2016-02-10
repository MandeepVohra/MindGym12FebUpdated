//
//  LevelsFriendsViewController.h
//  fancard
//
//  Created by Mandeep on 03/02/16.
//  Copyright © 2016 MEETStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LKDBHelper/NSObject+LKDBHelper.h>
#import "NSDate+FormatDateString.h"
#import "NSString+StringFormatDate.h"
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface LevelsFriendsViewController : UIViewController
{
    UIView *_titleView;
    UIButton *_backButton;
    int userUserId;
    int useridMY;
    NSString *stringSearch,*whichApi;
}
@end
