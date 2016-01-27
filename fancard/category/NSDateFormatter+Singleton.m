//
// Created by vagrant on 4/27/15.
// Copyright (c) 2015 lanbaoo. All rights reserved.
//

#import "NSDateFormatter+Singleton.h"


@implementation NSDateFormatter (Singleton)
+ (instancetype)singleton {
    static dispatch_once_t pred = 0;
    static NSDateFormatter *formatter = nil;
    dispatch_once(&pred, ^{
        formatter = [[self alloc] init];
    });
    return formatter;
}
@end