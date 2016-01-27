//
// Created by demo on 6/5/15.
// Copyright (c) 2015 lanbaoo. All rights reserved.
//

#import "NSDictionary+NotNULL.h"
#import "NSDateFormatter+Singleton.h"
#import "NSDate+TimeAgo.h"


@implementation NSDictionary (NotNULL)

- (NSArray *)getArray:(NSString *)key {
    return ([self[key] isKindOfClass:[NSNull class]] || ![self[key] isKindOfClass:[NSArray class]]) ? [[NSArray alloc] init] : self[key];
}

- (NSString *)getString:(NSString *)key {
    if (!self) {
        return @"";
    }
    if ([self[key] isKindOfClass:[NSNull class]] || (!self[key])) {
        return @"";
    } else if ([self[key] isKindOfClass:[NSDecimalNumber class]]) {
        return ((NSDecimalNumber *) self[key]).stringValue;
    } else if ([self[key] isKindOfClass:[NSNumber class]]) {
        return ((NSDecimalNumber *) self[key]).stringValue;
    }
//    return [self[key] isKindOfClass:[NSNull class]] ? @"" : ([self[key] isKindOfClass:[NSDecimalNumber class]] ? ((NSDecimalNumber*)self[key]).stringValue : self[key]);
    return ((NSString *) self[key]);
}

- (NSString *)getString:(NSString *)key defaultValue:(NSString *)value {
    NSString *strValue = [self getString:key];
    return strValue.length > 0 ? strValue : value;
}

- (int)getInt:(NSString *)key {
    return [self[key] isKindOfClass:[NSNull class]] ? 0 : [self[key] intValue];
}

- (int)getInt:(NSString *)key defaultValue:(int)value {
    return [self[key] isKindOfClass:[NSNull class]] ? value : [self[key] intValue];
}

- (NSInteger)getInteger:(NSString *)key {
    return [self[key] isKindOfClass:[NSNull class]] ? 0 : [self[key] intValue];
}

- (NSInteger)getInteger:(NSString *)key defaultValue:(NSInteger)value {
    return [self[key] isKindOfClass:[NSNull class]] ? value : [self[key] intValue];
}

- (float)getFloat:(NSString *)key {
    return [self[key] isKindOfClass:[NSNull class]] ? 0 : [self[key] floatValue];
}

- (float)getFloat:(NSString *)key defaultValue:(float)value {
    return [self[key] isKindOfClass:[NSNull class]] ? value : [self[key] floatValue];
}

- (double)getDouble:(NSString *)key {
    return [self[key] isKindOfClass:[NSNull class]] ? 0 : [self[key] doubleValue];
}

- (double)getDouble:(NSString *)key defaultValue:(float)value {
    return [self[key] isKindOfClass:[NSNull class]] ? value : [self[key] doubleValue];
}

- (CGFloat)getCGFloat:(NSString *)key {
    return [self[key] isKindOfClass:[NSNull class]] ? 0 : [self[key] floatValue];
}

- (CGFloat)getCGFloat:(NSString *)key defaultValue:(CGFloat)value {
    return [self[key] isKindOfClass:[NSNull class]] ? value : [self[key] floatValue];
}

- (NSDate *)getDate:(NSString *)key {
    return [self getDate:key defaultValue:[NSDate date]];
}

- (NSDate *)getDate:(NSString *)key defaultValue:(NSDate *)value {
    return [self[key] isKindOfClass:[NSNull class]] ? value : self[key];
}


- (BOOL)getBool:(NSString *)key {
    return [self[key] isKindOfClass:[NSNull class]] ? NO : [self[key] boolValue];
}

- (NSString *)getDateStr:(NSString *)key {
    if ([self[key] isKindOfClass:[NSNull class]]) {
        return @"";
    } else {
        NSDateFormatter *dateFormat = [NSDateFormatter singleton];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormat dateFromString:[self getString:key]];
        return [date customDateTimeFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
}

- (NSString *)getDateStr:(NSString *)key formatOut:(NSString *)fmtOutStr {
    if ([self[key] isKindOfClass:[NSNull class]]) {
        return @"";
    } else {
        NSDateFormatter *dateFormat = [NSDateFormatter singleton];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormat dateFromString:[self getString:key]];
//        [dateFormat setDateFormat:fmtOutStr];
        return [date customDateTimeFormat:fmtOutStr];
    }
}


- (NSString *)getDateStr:(NSString *)key formatOut:(NSString *)fmtOutStr defaultValue:(NSString *)value {
    if ([self[key] isKindOfClass:[NSNull class]]) {
        return value;
    } else {
        NSDateFormatter *dateFormat = [NSDateFormatter singleton];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormat dateFromString:[self getString:key]];
//        [dateFormat setDateFormat:fmtOutStr];
        return [date customDateTimeFormat:fmtOutStr];
    }
}

- (NSString *)getDateStr:(NSString *)key format:(NSString *)fmtStr {
    if ([self[key] isKindOfClass:[NSNull class]]) {
        return @"";
    } else {
        NSDateFormatter *dateFormat = [NSDateFormatter singleton];
        [dateFormat setDateFormat:fmtStr];
        NSDate *date = [dateFormat dateFromString:[self getString:key]];
        return [date customDateTimeFormat:fmtStr];
    }
}

- (NSString *)getDateStr:(NSString *)key formatIn:(NSString *)fmtInStr formatOut:(NSString *)fmtOutStr {
    if ([self[key] isKindOfClass:[NSNull class]]) {
        return @"";
    } else {
        NSDateFormatter *dateFormat = [NSDateFormatter singleton];
        [dateFormat setDateFormat:fmtInStr];
        NSDate *date = [dateFormat dateFromString:[self getString:key]];
        [dateFormat setDateFormat:fmtOutStr];
        return [date customDateTimeFormat:fmtOutStr];
    }
}

- (NSString *)getDateStr:(NSString *)key defaultValue:(NSString *)value {
    if ([self[key] isKindOfClass:[NSNull class]]) {
        return value;
    } else {
        NSDateFormatter *dateFormat = [NSDateFormatter singleton];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormat dateFromString:[self getString:key]];
        return [date customDateTimeFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
}

- (NSString *)getDateStr:(NSString *)key format:(NSString *)fmtStr defaultValue:(NSString *)value {
    if ([self[key] isKindOfClass:[NSNull class]]) {
        return value;
    } else {
        NSDateFormatter *dateFormat = [NSDateFormatter singleton];
        [dateFormat setDateFormat:fmtStr];
        NSDate *date = [dateFormat dateFromString:[self getString:key]];
        return [date customDateTimeFormat:fmtStr];
    }
}

@end