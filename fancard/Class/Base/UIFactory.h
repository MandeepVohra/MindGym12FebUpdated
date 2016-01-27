//
//  UIFactory.h
//  fancard
//
//  Created by MEETStudio on 15-8-27.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIFactory : NSObject

+ (UIButton *)createButtonWithFrame:(CGRect)frame
                             Target:(id)target
                           Selector:(SEL)selector
                              Image:(NSString *)image
                       ImagePressed:(NSString *)imagePressed;

+ (UIButton *)createButtonWithFrame:(CGRect)frame
                              Title:(NSString *)title
                             Target:(id)target
                           Selector:(SEL)selector;

@end
