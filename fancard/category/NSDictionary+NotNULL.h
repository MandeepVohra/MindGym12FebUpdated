//
// Created by demo on 6/5/15.
// Copyright (c) 2015 lanbaoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class NSDateFormatter;

@interface NSDictionary (NotNULL)
- (NSArray *)getArray:(NSString *)key;

- (NSString *)getString:(NSString *)key;

- (NSString *)getString:(NSString *)key defaultValue:(NSString *)value;

- (int)getInt:(NSString *)key;

- (int)getInt:(NSString *)key defaultValue:(int)value;

- (NSInteger)getInteger:(NSString *)key;

- (NSInteger)getInteger:(NSString *)key defaultValue:(NSInteger)value;

- (float)getFloat:(NSString *)key;

- (float)getFloat:(NSString *)key defaultValue:(float)value;

- (double)getDouble:(NSString *)key;

- (double)getDouble:(NSString *)key defaultValue:(float)value;

- (CGFloat)getCGFloat:(NSString *)key;

- (CGFloat)getCGFloat:(NSString *)key defaultValue:(CGFloat)value;

- (NSDate *)getDate:(NSString *)key;

- (NSDate *)getDate:(NSString *)key defaultValue:(NSDate *)value;

- (BOOL)getBool:(NSString *)key;

- (NSString *)getDateStr:(NSString *)key;

- (NSString *)getDateStr:(NSString *)key formatOut:(NSString *)fmtOutStr;

- (NSString *)getDateStr:(NSString *)key formatOut:(NSString *)fmtOutStr defaultValue:(NSString *)value;

- (NSString *)getDateStr:(NSString *)key format:(NSString *)fmtStr;

- (NSString *)getDateStr:(NSString *)key defaultValue:(NSString *)value;

- (NSString *)getDateStr:(NSString *)key format:(NSString *)fmtStr defaultValue:(NSString *)value;

- (NSString *)getDateStr:(NSString *)key formatIn:(NSString *)fmtInStr formatOut:(NSString *)fmtOutStr;

@end