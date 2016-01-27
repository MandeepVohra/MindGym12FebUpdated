//
// Created by vagrant on 10/4/14.
// Copyright (c) 2014 lanbaoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAPreferences.h"


@interface LanbaooPrefs : PAPreferences

@property(nonatomic, assign) NSString *userId;
@property(nonatomic, assign) NSString *userName;
@property(nonatomic, assign) NSString *loginMail;
@property(nonatomic, assign) NSString *fid;
@property(nonatomic, assign) NSInteger botId;
@property(nonatomic, assign) NSInteger challengerId;
@property(nonatomic, assign) NSInteger rank;
@property(nonatomic, assign) BOOL musicOff;
@property(nonatomic, assign) BOOL soundOff;
@property(nonatomic, assign) BOOL notificationOff;
@property(nonatomic, assign) double gapTime;

@end