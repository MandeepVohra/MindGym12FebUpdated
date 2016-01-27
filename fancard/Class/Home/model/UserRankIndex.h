//
// Created by demo on 12/15/15.
// Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
//
//"totalPoints": "240",
//"winCount": "1",
//"loseCount": "0",
//"totalCount": "1",
//"rank": "7"

@interface UserRankIndex : NSObject
@property(nonatomic, assign) NSInteger totalPoints;
@property(nonatomic, assign) NSInteger winCount;
@property(nonatomic, assign) NSInteger loseCount;
@property(nonatomic, assign) NSInteger totalCount;
@property(nonatomic, assign) NSInteger points_week;
@property(nonatomic, assign) NSInteger rank;
@property(nonatomic, strong) NSString *lastFrdFight;
@property(nonatomic, strong) NSString *lastBotFight;
@end