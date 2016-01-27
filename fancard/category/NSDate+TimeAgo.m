#import "NSDate+TimeAgo.h"
#import "NSCalendar+Singleton.h"
#import "NSDateFormatter+Singleton.h"

@interface NSDate ()
- (NSString *)getLocaleFormatUnderscoresWithValue:(double)value;
@end

@implementation NSDate (TimeAgo)

#ifndef NSDateTimeAgoLocalizedStrings
#define NSDateTimeAgoLocalizedStrings(key) \
NSLocalizedStringFromTableInBundle(key, @"NSDateTimeAgo", [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"NSDateTimeAgo.bundle"]], nil)
#endif

- (NSString *)timeAgo {
    NSDate *now = [NSDate new];
    double deltaSeconds = fabs([self timeIntervalSinceDate:now]);
    double deltaMinutes = deltaSeconds / 60.0f;

    int minutes;

    if (deltaSeconds < 5) {
        return NSLocalizedString(@"Just now", @"Just now");
    }
    else if (deltaSeconds < 60) {
        return [self stringFromFormat:NSLocalizedString(@"%%d seconds ago", @"%%d seconds ago") withValue:deltaSeconds];
    }
    else if (deltaSeconds < 120) {
        return NSLocalizedString(@"A minute ago", @"A minute ago");
    }
    else if (deltaMinutes < 60) {
        return [self stringFromFormat:NSLocalizedString(@"%%d minutes ago", @"%%d minutes ago") withValue:deltaMinutes];
    }
    else if (deltaMinutes < 120) {
        return NSLocalizedString(@"An hour ago", @"An hour ago");
    }
    else if (deltaMinutes < (24 * 60)) {
        minutes = (int) floor(deltaMinutes / 60);
        return [self stringFromFormat:NSLocalizedString(@"%%d hours ago", @"%%d hours ago") withValue:minutes];
    }
    else if (deltaMinutes < (24 * 60 * 2)) {
        return NSLocalizedString(@"Yesterday", @"Yesterday");
    }
    else if (deltaMinutes < (24 * 60 * 7)) {
        minutes = (int) floor(deltaMinutes / (60 * 24));
        return [self stringFromFormat:NSLocalizedString(@"%%d days ago", @"%%d days ago") withValue:minutes];
    }
    else if (deltaMinutes < (24 * 60 * 14)) {
        return NSLocalizedString(@"Last week", @"Last week");
    }
    else if (deltaMinutes < (24 * 60 * 31)) {
        minutes = (int) floor(deltaMinutes / (60 * 24 * 7));
        return [self stringFromFormat:NSLocalizedString(@"%%d weeks ago", @"%%d weeks ago") withValue:minutes];
    }
    else if (deltaMinutes < (24 * 60 * 61)) {
        return NSLocalizedString(@"Last month", @"Last month");
    }
    else if (deltaMinutes < (24 * 60 * 365.25)) {
        minutes = (int) floor(deltaMinutes / (60 * 24 * 30));
        return [self stringFromFormat:NSLocalizedString(@"%%d months ago", @"%%d months ago") withValue:minutes];
    }
    else if (deltaMinutes < (24 * 60 * 731)) {
        return NSLocalizedString(@"Last year", @"Last year");
    }

    minutes = (int) floor(deltaMinutes / (60 * 24 * 365));
    return [self stringFromFormat:NSLocalizedString(@"%%d years ago", @"%%d years ago") withValue:minutes];
}

// Similar to timeAgo, but only returns "
- (NSString *)dateTimeAgo {
    NSCalendar *calendar = [NSCalendar singleton];
    NSDate *now = [NSDate new];
    NSDateComponents *components = [calendar components:
                    NSYearCalendarUnit |
                            NSMonthCalendarUnit |
                            NSWeekCalendarUnit |
                            NSDayCalendarUnit |
                            NSHourCalendarUnit |
                            NSMinuteCalendarUnit |
                            NSSecondCalendarUnit
                                               fromDate:self
                                                 toDate:now
                                                options:0];

    if (components.year >= 1) {
        if (components.year == 1) {
            return NSDateTimeAgoLocalizedStrings(@"1 year ago");
        }
        return [self stringFromFormat:@"%%d %@years ago" withValue:components.year];
    }
    else if (components.month >= 1) {
        if (components.month == 1) {
            return NSDateTimeAgoLocalizedStrings(@"1 month ago");
        }
        return [self stringFromFormat:@"%%d %@months ago" withValue:components.month];
    }
    else if (components.week >= 1) {
        if (components.week == 1) {
            return NSDateTimeAgoLocalizedStrings(@"1 week ago");
        }
        return [self stringFromFormat:@"%%d %@weeks ago" withValue:components.week];
    }
    else if (components.day >= 1)    // up to 6 days ago
    {
        if (components.day == 1) {
            return NSDateTimeAgoLocalizedStrings(@"1 day ago");
        }
        return [self stringFromFormat:@"%%d %@days ago" withValue:components.day];
    }
    else if (components.hour >= 1)   // up to 23 hours ago
    {
        if (components.hour == 1) {
            return NSDateTimeAgoLocalizedStrings(@"An hour ago");
        }
        return [self stringFromFormat:@"%%d %@hours ago" withValue:components.hour];
    }
    else if (components.minute >= 1) // up to 59 minutes ago
    {
        if (components.minute == 1) {
            return NSDateTimeAgoLocalizedStrings(@"A minute ago");
        }
        return [self stringFromFormat:@"%%d %@minutes ago" withValue:components.minute];
    }
    else if (components.second < 5) {
        return NSDateTimeAgoLocalizedStrings(@"Just now");
    }

    // between 5 and 59 seconds ago
    return [self stringFromFormat:@"%%d %@seconds ago" withValue:components.second];
}

- (NSString *)customDateTimeFormat:(NSString *)formatterStr {
    NSCalendar *calendar = [NSCalendar singleton];
    NSDate *now = [NSDate new];
    NSDateComponents *componentsSelf = [calendar components:
                    NSYearCalendarUnit |
                            NSMonthCalendarUnit |
                            NSWeekCalendarUnit |
                            NSDayCalendarUnit |
                            NSHourCalendarUnit |
                            NSMinuteCalendarUnit |
                            NSSecondCalendarUnit
                                                   fromDate:self];

    NSDateComponents *componentsNow = [calendar components:

            NSYearCalendarUnit |
                    NSMonthCalendarUnit |
                    NSWeekCalendarUnit |
                    NSDayCalendarUnit |
                    NSHourCalendarUnit |
                    NSMinuteCalendarUnit |
                    NSSecondCalendarUnit          fromDate:now];

    NSDateFormatter *dateFormat = [NSDateFormatter singleton];
    [dateFormat setDateFormat:@"MM-dd HH:mm"];

    if (componentsNow.year > componentsSelf.year) {
        [dateFormat setDateFormat:formatterStr];
        return [dateFormat stringFromDate:self];
    }
    else if (componentsNow.month > componentsSelf.month) {
        [dateFormat setDateFormat:formatterStr];
        return [dateFormat stringFromDate:self];
    }
    else if (componentsNow.weekOfMonth > componentsSelf.weekOfMonth) {
        [dateFormat setDateFormat:formatterStr];
        return [dateFormat stringFromDate:self];
    } else if (componentsNow.day > componentsSelf.day) {

        [dateFormat setDateFormat:@"HH:mm"];

        int daysGap = componentsNow.day - componentsSelf.day;
        switch (daysGap) {
            case 0: {
                return [NSString stringWithFormat:@"今天 %@", [dateFormat stringFromDate:self]];
//                break;
            }
            case 1: {
                return [NSString stringWithFormat:@"昨天 %@", [dateFormat stringFromDate:self]];
//                break;
            }
            case 2: {
                return [NSString stringWithFormat:@"前天 %@", [dateFormat stringFromDate:self]];
//                break;
            }
            default:
                [dateFormat setDateFormat:@"MM-dd HH:mm"];
                return [dateFormat stringFromDate:self];
//                break;
        }

    } else if (componentsNow.hour > componentsSelf.hour)   // up to 23 hours ago
    {
        [dateFormat setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"今天 %@", [dateFormat stringFromDate:self]];
    }
    else if (componentsNow.minute > componentsSelf.minute) // up to 59 minutes ago
    {
        [dateFormat setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"今天 %@", [dateFormat stringFromDate:self]];
    }
    else if (componentsNow.second > componentsSelf.second) {
        [dateFormat setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"今天 %@", [dateFormat stringFromDate:self]];
    }
    return [dateFormat stringFromDate:self];
}


- (NSString *)dateTimeUntilNow {
    NSDate *now = [NSDate new];
    NSCalendar *calendar = [NSCalendar singleton];

    NSDateComponents *components = [calendar components:NSHourCalendarUnit
                                               fromDate:self
                                                 toDate:now
                                                options:0];

    if (components.hour >= 6) // if more than 6 hours ago, change precision
    {
        NSInteger startDay = [calendar ordinalityOfUnit:NSDayCalendarUnit
                                                 inUnit:NSEraCalendarUnit
                                                forDate:self];
        NSInteger endDay = [calendar ordinalityOfUnit:NSDayCalendarUnit
                                               inUnit:NSEraCalendarUnit
                                              forDate:now];

        NSInteger diffDays = endDay - startDay;
        if (diffDays == 0) // today!
        {
            NSDateComponents *startHourComponent = [calendar components:NSHourCalendarUnit fromDate:self];
            NSDateComponents *endHourComponent = [calendar components:NSHourCalendarUnit fromDate:self];
            if (startHourComponent.hour < 12 &&
                    endHourComponent.hour > 12) {
                return NSDateTimeAgoLocalizedStrings(@"This morning");
            }
            else if (startHourComponent.hour >= 12 &&
                    startHourComponent.hour < 18 &&
                    endHourComponent.hour >= 18) {
                return NSDateTimeAgoLocalizedStrings(@"This afternoon");
            }
            return NSDateTimeAgoLocalizedStrings(@"Today");
        }
        else if (diffDays == 1) {
            return NSDateTimeAgoLocalizedStrings(@"Yesterday");
        }
        else {
            NSInteger startWeek = [calendar ordinalityOfUnit:NSWeekCalendarUnit
                                                      inUnit:NSEraCalendarUnit
                                                     forDate:self];
            NSInteger endWeek = [calendar ordinalityOfUnit:NSWeekCalendarUnit
                                                    inUnit:NSEraCalendarUnit
                                                   forDate:now];
            NSInteger diffWeeks = endWeek - startWeek;
            if (diffWeeks == 0) {
                return NSDateTimeAgoLocalizedStrings(@"This week");
            }
            else if (diffWeeks == 1) {
                return NSDateTimeAgoLocalizedStrings(@"Last week");
            }
            else {
                NSInteger startMonth = [calendar ordinalityOfUnit:NSMonthCalendarUnit
                                                           inUnit:NSEraCalendarUnit
                                                          forDate:self];
                NSInteger endMonth = [calendar ordinalityOfUnit:NSMonthCalendarUnit
                                                         inUnit:NSEraCalendarUnit
                                                        forDate:now];
                NSInteger diffMonths = endMonth - startMonth;
                if (diffMonths == 0) {
                    return NSDateTimeAgoLocalizedStrings(@"This month");
                }
                else if (diffMonths == 1) {
                    return NSDateTimeAgoLocalizedStrings(@"Last month");
                }
                else {
                    NSInteger startYear = [calendar ordinalityOfUnit:NSYearCalendarUnit
                                                              inUnit:NSEraCalendarUnit
                                                             forDate:self];
                    NSInteger endYear = [calendar ordinalityOfUnit:NSYearCalendarUnit
                                                            inUnit:NSEraCalendarUnit
                                                           forDate:now];
                    NSInteger diffYears = endYear - startYear;
                    if (diffYears == 0) {
                        return NSDateTimeAgoLocalizedStrings(@"This year");
                    }
                    else if (diffYears == 1) {
                        return NSDateTimeAgoLocalizedStrings(@"Last year");
                    }
                }
            }
        }
    }

    // anything else uses "time ago" precision
    return [self dateTimeAgo];
}


- (NSString *)stringFromFormat:(NSString *)format withValue:(NSInteger)value {
    return [[NSString alloc] initWithFormat:format, value];
    NSString *localeFormat = [NSString stringWithFormat:format, [self getLocaleFormatUnderscoresWithValue:value]];
    return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), value];
}

- (NSString *)timeAgoWithLimit:(NSTimeInterval)limit {
    return [self timeAgoWithLimit:limit dateFormat:NSDateFormatterFullStyle andTimeFormat:NSDateFormatterFullStyle];
}

- (NSString *)timeAgoWithLimit:(NSTimeInterval)limit dateFormat:(NSDateFormatterStyle)dFormatter andTimeFormat:(NSDateFormatterStyle)tFormatter {
    if (fabs([self timeIntervalSinceDate:[NSDate new]]) <= limit)
        return [self timeAgo];

    return [NSDateFormatter localizedStringFromDate:self
                                          dateStyle:dFormatter
                                          timeStyle:tFormatter];
}

- (NSString *)timeAgoWithLimit:(NSTimeInterval)limit dateFormatter:(NSDateFormatter *)formatter {
    if (fabs([self timeIntervalSinceDate:[NSDate new]]) <= limit)
        return [self timeAgo];

    return [formatter stringFromDate:self];
}

- (NSString *)timeAgoWithDaysLimit:(int)limitDays dateFormatter:(NSDateFormatter *)formatter {
    NSDateComponents *components = [NSDateComponents new];
    [components setDay:limitDays];
    NSDate *newDate = [[NSCalendar singleton] dateByAddingComponents:components toDate:self options:0];
    if (fabs([self timeIntervalSinceDate:[NSDate new]]) <= fabs([self timeIntervalSinceDate:newDate]))
        return [self timeAgo];

    return [formatter stringFromDate:self];
}

// Helper functions

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

/*
 - Author  : Almas Adilbek
 - Method  : getLocaleFormatUnderscoresWithValue
 - Param   : value (Double value of seconds or minutes)
 - Return  : @"" or the set of underscores ("_")
 in order to define exact translation format for specific translation rules.
 (Ex: "%d _seconds ago" for "%d секунды назад", "%d __seconds ago" for "%d секунда назад",
 and default format without underscore %d seconds ago" for "%d секунд назад")
 Updated : 12/12/2012
 
 Note    : This method must be used for all languages that have specific translation rules.
 Using method argument "value" you must define all possible conditions language have for translation
 and return set of underscores ("_") as it is an ID for locale format. No underscore ("") means default locale format;
 */
- (NSString *)getLocaleFormatUnderscoresWithValue:(double)value {
    NSString *localeCode = [[NSLocale preferredLanguages] objectAtIndex:0];

    // Russian (ru)
    if ([localeCode isEqual:@"ru"]) {
        NSString *valueStr = [NSString stringWithFormat:@"%.f", value];
        int l = valueStr.length;
        int XY = [[valueStr substringWithRange:NSMakeRange(l - 2, l)] intValue];
        int Y = (int) floor(value) % 10;

        if (Y == 0 || Y > 4 || XY == 11) return @"";
        if (Y != 1 && Y < 5) return @"_";
        if (Y == 1) return @"__";
    }

    // Add more languages here, which are have specific translation rules...

    return @"";
}

#pragma clang diagnostic pop

@end
