//
//  ETGlobal.m
//  fancard
//
//  Created by MEETStudio on 15-9-17.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "ETGlobal.h"
#import <MJExtension/MJExtension.h>

static ETGlobal *_sharedGlobal = nil;

@implementation ETGlobal

+ (ETGlobal *)sharedGlobal {
    if (!_sharedGlobal) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedGlobal = [[ETGlobal alloc] init];
        });
    }
    return _sharedGlobal;
}

+ (void)map {
    [ETGlobal setupReplacedKeyFromPropertyName:^NSDictionary * {
        return @{
                @"firstName"   :@"firstname",
                @"lastName"    :@"lastname",
                @"email"       :@"email",
                @"userId"      :@"id",
                @"level"       :@"level",
                @"lostNum"     :@"number_lost",
                @"winNum"      :@"number_win",
                @"tieNum"      :@"number_tie",
                @"todayPoints" :@"points_today",
                @"totalPoints" :@"points_total"
        };
    }];
}

@end
