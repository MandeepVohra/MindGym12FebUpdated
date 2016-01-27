//
//  UIFactory.m
//  fancard
//
//  Created by MEETStudio on 15-8-27.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "UIFactory.h"
#import "UniversalButton.h"


@implementation UIFactory

+ (UIButton *)createButtonWithFrame:(CGRect)frame
                             Target:(id)target
                           Selector:(SEL)selector
                              Image:(NSString *)image
                       ImagePressed:(NSString *)imagePressed {
    UniversalButton *button = [UniversalButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:imagePressed] forState:UIControlStateSelected];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)createButtonWithFrame:(CGRect)frame
                              Title:(NSString *)title
                             Target:(id)target
                           Selector:(SEL)selector {

    UniversalButton *button = [UniversalButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];    
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
