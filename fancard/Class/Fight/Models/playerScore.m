//
//  playerScore.m
//  fancard
//
//  Created by MEETStudio on 15-10-17.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "playerScore.h"
#import <MJExtension/MJExtension.h>

@implementation playerScore

+ (void)map {
    [playerScore setupReplacedKeyFromPropertyName:^NSDictionary * {
        return @{
                @"playerId" : @"id",
                @"score" : @"score"
        };
    }];
}

@end
