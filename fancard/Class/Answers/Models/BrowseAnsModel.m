//
//  BrowseAnsModel.m
//  fancard
//
//  Created by MEETStudio on 15-11-3.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "BrowseAnsModel.h"
#import <MJExtension/MJExtension.h>
#import "NSMutableArray+shuffling.h"

@implementation BrowseAnsModel

- (NSArray *)answers {
    NSMutableArray *array = [NSMutableArray arrayWithObjects:self.rightAns, self.wrongAns1, self.wrongAns2, nil];
    
    [array shuffle];
    
    return array;
}

+ (void)map {
    [BrowseAnsModel setupReplacedKeyFromPropertyName:^NSDictionary * {
        return @{
                 @"cateId" : @"category_id",
                 @"identifier" : @"id",
                 @"question" : @"title",
                 @"rightAns" : @"correct_answer",
                 @"wrongAns1" : @"wrong_answer1",
                 @"wrongAns2" : @"wrong_answer2"
                 };
    }];
}

@end
