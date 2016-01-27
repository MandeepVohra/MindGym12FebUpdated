//
// Created by demo on 10/27/15.
// Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "UILabel+DynamicFontSize.h"
#import "Mconfig.h"


@implementation UILabel (DynamicFontSize)

- (void)adjustFontSizeWithText:(NSString *)text constrainedToSize:(CGSize)maxSize {

    if (![text isKindOfClass:[NSString class]] || text.length == 0) {
        self.text = @"";
        return;
    }

    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

//    NSLog(@"oldtext = %@", text);

    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@" +" options:NSRegularExpressionCaseInsensitive error:&error];
    text = [regex stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, [text length]) withTemplate:@" "];

    self.text = text;

    CGFloat maxFontSize = 50.0f;
    self.font = [UIFont fontWithName:kAsapBoldFont size:maxFontSize];
    [self setNeedsDisplay];
    NSArray *array = [text componentsSeparatedByString:@" "];

    NSString *separatedStr;
    if (array && array.count > 0) {
        if (array.count < 4) {
            for (NSString *str in array) {
                if (str.length >= separatedStr.length) {
                    separatedStr = str;
                }
            }
        } else {
            separatedStr = text;
        }
    } else {
        separatedStr = text;
    }
//    NSLog(@"separatedStr = %@", separatedStr);

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    for (CGFloat fSize = 0.0f; fSize < maxFontSize; fSize += 0.05f) {
        UIFont *someFont = [UIFont fontWithName:kAsapBoldFont size:fSize];;

        NSDictionary *attributes = @{NSFontAttributeName : someFont, NSParagraphStyleAttributeName : paragraphStyle.copy};
        CGSize labelSize = [separatedStr boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;

        CGFloat height = ceilf(labelSize.height);
        CGFloat width = ceilf(labelSize.width);

        if (width >= maxSize.width || height >= maxSize.height) {
            self.font = [UIFont fontWithName:kAsapBoldFont size:floorf(fSize)];
            self.text = text;
            [self setNeedsDisplay];
            break;
        }
    }
}

@end