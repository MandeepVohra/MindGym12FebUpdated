//
// Created by demo on 11/4/15.
// Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfo;

@interface PushBean : NSObject
@property(nonatomic, strong) NSString *uid;       //sender
@property(nonatomic, strong) NSString *toUid;     //receiver
@property(nonatomic, strong) NSString *message;   //when action = score，message = currentScore
/* action:
 *
 *    challenge :send challenge
 *    accept    :accept challenge
 *    score     :send score
 *    begin     :begin game
 */
@property(nonatomic, strong) NSString *action;    //
@property(nonatomic, strong) NSString *pushTime;  //action time

@property(nonatomic, strong) UserInfo *userInfo;

@property(nonatomic, assign) int currentScore;  //The questions in addition to score a device

@end