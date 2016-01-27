//
// Created by demo on 10/27/15.
// Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UILabel (DynamicFontSize)
- (void)adjustFontSizeWithText:(NSString *)text constrainedToSize:(CGSize)maxSize;
@end