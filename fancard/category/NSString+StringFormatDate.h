//
//  NSString+StringFormatDate.h
//  fancard
//
//  Created by MEETStudio on 15-11-13.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringFormatDate)

- (NSDate *)getDateWithFormat:(NSString *)FormatStr;

@end
