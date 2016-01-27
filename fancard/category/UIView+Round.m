//
//  UIView+Round.m
//  fancard
//
//  Created by MEETStudio on 15-10-21.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "UIView+Round.h"

@implementation UIView (Round)

- (void)roundCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    CGRect bounds = self.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;

    self.layer.mask = maskLayer;

    CAShapeLayer *frameLayer = [CAShapeLayer layer];
    frameLayer.frame = bounds;
    frameLayer.path = maskPath.CGPath;
    //    frameLayer.strokeColor = [UIColor redColor].CGColor;
    frameLayer.strokeColor = self.layer.borderColor;
    frameLayer.fillColor = nil;

    [self.layer addSublayer:frameLayer];
}

- (void)roundTopCornersRadius:(CGFloat)radius {
    [self roundCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) radius:radius];
}

- (void)roundBottomCornersRadius:(CGFloat)radius {
    [self roundCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) radius:radius];
}

@end
