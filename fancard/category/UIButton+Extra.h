//
// Created by vagrant on 10/1/14.
// Copyright (c) 2014 lanbaoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIButton (Extra)
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

+ (UIImage *)imageFromColor:(UIColor *)color;

- (void)addBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth;

@end