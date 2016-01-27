//
//  BotModel.h
//  fancard
//
//  Created by MEETStudio on 15-9-23.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BotModel : NSObject

@property(assign, nonatomic) NSInteger botId;
@property(strong, nonatomic) NSString *firstName;
@property(strong, nonatomic) NSString *lastName;
@property(assign, nonatomic) int winNum;
@property(assign, nonatomic) int lostNum;
@property(assign, nonatomic) int tieNum;
@property(assign, nonatomic) int totalPoints;

+ (void)map;

@end
