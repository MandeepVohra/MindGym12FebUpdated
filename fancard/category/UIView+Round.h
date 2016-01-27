//
//  UIView+Round.h
//  fancard
//
//  Created by MEETStudio on 15-10-21.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Round)

- (void)roundCorners:(UIRectCorner)corners radius:(CGFloat)radius;

- (void)roundTopCornersRadius:(CGFloat)radius;

- (void)roundBottomCornersRadius:(CGFloat)radius;

@end
