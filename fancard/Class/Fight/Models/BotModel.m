//
//  BotModel.m
//  fancard
//
//  Created by MEETStudio on 15-9-23.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "BotModel.h"
#import <MJExtension/MJExtension.h>

@implementation BotModel
+ (void)map {
    [BotModel setupReplacedKeyFromPropertyName:^NSDictionary * {
        return @{
                @"botId" : @"id",
                @"firstName":@"firstname",
                @"lastName":@"lastname",
                @"winNum":@"number_win",
                @"lostNum":@"number_lost",
                @"tieNum":@"number_tie",
                @"totalPoints":@"points_total"                
        };
    }];
}
@end
