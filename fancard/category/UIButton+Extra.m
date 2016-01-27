//
// Created by vagrant on 10/1/14.
// Copyright (c) 2014 lanbaoo. All rights reserved.
//

#import "UIButton+Extra.h"


@implementation UIButton (Extra)
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIButton imageFromColor:backgroundColor] forState:state];
}

+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)addBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth {
    CALayer *border = [CALayer layer];
    border.borderColor = color.CGColor;
    border.frame = CGRectMake(-borderWidth, -borderWidth, self.frame.size.width + borderWidth, self.frame.size.height + borderWidth);
    border.borderWidth = borderWidth;
    border.cornerRadius = 8.f;
    [self.layer addSublayer:border];
    self.layer.masksToBounds = YES;
}

@end