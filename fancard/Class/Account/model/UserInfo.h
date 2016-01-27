//
// Created by demo on 12/10/15.
// Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LanbaooBaseModel.h"

//return @{
//@"firstName"   :@"firstname",
//@"lastName"    :@"lastname",
//@"email"       :@"email",
//@"userId"      :@"id",
//@"level"       :@"level",
//@"lostNum"     :@"number_lost",
//@"winNum"      :@"number_win",
//@"tieNum"      :@"number_tie",
//@"todayPoints" :@"points_today",
//@"totalPoints" :@"points_total"
//};

@interface UserInfo : LanbaooBaseModel

@property(strong, nonatomic) NSString *avatar;
@property(strong, nonatomic) NSString *email;
@property(strong, nonatomic) NSString *firstname;
@property(strong, nonatomic) NSString *lastname;
@property(strong, nonatomic) NSString *id;
@property(strong, nonatomic) NSString *type;
@property(strong, nonatomic) NSString *lastFrdFight;
@property(strong, nonatomic) NSString *lastBotFight;
@property(assign, nonatomic) NSInteger level;

@property(assign, nonatomic) NSInteger number_lost;
@property(assign, nonatomic) NSInteger number_win;
@property(assign, nonatomic) NSInteger number_week_lost;
@property(assign, nonatomic) NSInteger number_week_win;
@property(assign, nonatomic) NSInteger number_tie;
@property(assign, nonatomic) NSInteger points_today;
@property(assign, nonatomic) NSInteger points_total;
@property(assign, nonatomic) NSInteger points_week;

@property(assign, nonatomic) NSInteger totalPoints;
@property(assign, nonatomic) NSInteger winCount;
@property(assign, nonatomic) NSInteger loseCount;
@property(assign, nonatomic) NSInteger totalCount;

@property(strong, nonatomic) NSString *rank;

@end