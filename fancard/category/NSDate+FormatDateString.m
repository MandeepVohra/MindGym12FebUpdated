//
// Created by demo on 11/5/15.
// Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "NSDate+FormatDateString.h"


@implementation NSDate (FormatDateString)
- (NSString *)getDateStrWithFormat:(NSString *)FormatStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:FormatStr];
    NSString *dateString = [formatter stringFromDate:self];
    return dateString;
}

@end