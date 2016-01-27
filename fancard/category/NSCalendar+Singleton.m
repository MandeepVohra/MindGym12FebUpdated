//
// Created by vagrant on 4/27/15.
// Copyright (c) 2015 lanbaoo. All rights reserved.
//

#import "NSCalendar+Singleton.h"


@implementation NSCalendar (Singleton)
+ (instancetype)singleton {
    static dispatch_once_t pred = 0;
    static NSCalendar *calendar = nil;
    dispatch_once(&pred, ^{
        calendar = [NSCalendar currentCalendar];
    });
    return calendar;
}

@end