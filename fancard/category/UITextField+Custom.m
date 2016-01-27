//
//  UITextField+Custom.m
//  fancard
//
//  Created by MEETStudio on 15-10-27.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "UITextField+Custom.h"
#import "Mconfig.h"

@implementation UITextField (Custom)

- (void)customSomething:(NSString *)str
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:str];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:kAsapRegularFont size:18.0f] range:[str rangeOfString:str]];
    self.attributedPlaceholder = string;
}

- (void)customSomething:(NSString *)str font:(UIFont *)font
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:str];
    [string addAttribute:NSFontAttributeName value:font range:[str rangeOfString:str]];
    self.attributedPlaceholder = string;
}

@end
