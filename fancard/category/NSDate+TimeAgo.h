#import <Foundation/Foundation.h>

@interface NSDate (TimeAgo)

- (NSString *)timeAgo;

- (NSString *)timeAgoWithLimit:(NSTimeInterval)limit;

- (NSString *)timeAgoWithLimit:(NSTimeInterval)limit dateFormat:(NSDateFormatterStyle)dFormatter andTimeFormat:(NSDateFormatterStyle)tFormatter;

- (NSString *)timeAgoWithLimit:(NSTimeInterval)limit dateFormatter:(NSDateFormatter *)formatter;

- (NSString *)timeAgoWithDaysLimit:(int)limitDays dateFormatter:(NSDateFormatter *)formatter;

// this method only returns "{value} {unit} ago" strings and no "yesterday"/"last month" strings
- (NSString *)dateTimeAgo;

- (NSString *)customDateTimeFormat:(NSString *)formatter;

// this method gives when possible the date compared to the current calendar date: "this morning"/"yesterday"/"last week"/..
// when more precision is needed (= less than 6 hours ago) it returns the same output as dateTimeAgo
- (NSString *)dateTimeUntilNow;

@end