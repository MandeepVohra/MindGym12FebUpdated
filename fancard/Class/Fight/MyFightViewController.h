//
//  MyFightViewController.h
//  fancard
//
//  Created by MEETStudio on 15-8-28.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "BaseViewController.h"
#import "QuestionModels.h"
#import "XOSplashVideoController.h"

@interface MyFightViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate> {

}

@property(nonatomic, strong) QuestionModels *question;

//answer label
@property(strong, nonatomic) UILabel *answer1;
@property(strong, nonatomic) UILabel *answer2;
@property(strong, nonatomic) UILabel *answer3;

@property(assign, nonatomic) NSInteger fid;
@property(assign, nonatomic) BOOL isGuest;

@property(strong, nonatomic) NSString *oppAvatar;
@property(strong, nonatomic) NSString *opponentName;

@end
