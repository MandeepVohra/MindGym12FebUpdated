//
//  ETGlobal.h
//  fancard
//
//  Created by MEETStudio on 15-9-17.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETGlobal : NSObject

@property(strong, nonatomic) NSString *avatar;
@property(strong, nonatomic) NSString *email;
@property(strong, nonatomic) NSString *firstName;
@property(strong, nonatomic) NSString *lastName;
@property(assign, nonatomic) NSInteger level;
@property(assign, nonatomic) NSInteger userId;

@property(assign, nonatomic) NSInteger lostNum;
@property(assign, nonatomic) NSInteger winNum;
@property(assign, nonatomic) NSInteger tieNum;
@property(assign, nonatomic) NSInteger todayPoints;
@property(assign, nonatomic) NSInteger totalPoints;

@property(strong, nonatomic) NSMutableArray *allQuizs;       //quiz
@property(strong, nonatomic) NSMutableArray *challengerInfo;

+ (ETGlobal *)sharedGlobal;

+ (void)map;

@end
