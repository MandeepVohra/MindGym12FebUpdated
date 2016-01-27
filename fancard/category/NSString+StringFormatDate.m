//
//  NSString+StringFormatDate.m
//  fancard
//
//  Created by MEETStudio on 15-11-13.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "NSString+StringFormatDate.h"

@implementation NSString (StringFormatDate)

- (NSDate *)getDateWithFormat:(NSString *)FormatStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:FormatStr];
    NSDate *date = [formatter dateFromString:self];
    return date;
}

@end
