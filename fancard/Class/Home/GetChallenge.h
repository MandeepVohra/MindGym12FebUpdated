//
//  GetChallenge.h
//  fancard
//
//  Created by MEETStudio on 15-10-15.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MDelegate.h"

@interface GetChallenge : UIView <UITableViewDataSource, UITableViewDelegate, AcceptChallengeDelegate>

@property(assign, nonatomic) id <ResponseDelegate> reDelegate;

@property(strong, nonatomic) UIView *chaNumView;  //challenges number
@property(strong, nonatomic) UILabel *chaNumLb;

@property(strong, nonatomic) UITableView *chaMessage;
@property(assign, nonatomic) NSInteger chaNum;

- (void)setInfo:(NSArray *)challenger;

@end


//tableViewCell
@interface Cell : UITableViewCell

@property(assign, nonatomic) id <AcceptChallengeDelegate> acDelegate;

@property(strong, nonatomic) UIView *cellView;
@property(strong, nonatomic) UIImageView *oppUserPhoto;
@property(strong, nonatomic) UILabel *oppUserName;
@property(strong, nonatomic) UIButton *accept;
@property(strong, nonatomic) UILabel *whiteLine;
@property(strong, nonatomic) UserInfo *challenger;

@end
