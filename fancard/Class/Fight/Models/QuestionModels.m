//
//  QuestionModels.m
//  fancard
//
//  Created by MEETStudio on 15-9-16.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "QuestionModels.h"
#import <MJExtension/MJExtension.h>
#import "NSMutableArray+shuffling.h"

@implementation QuestionModels

- (NSArray *)answers {
    NSMutableArray *array = [NSMutableArray arrayWithObjects:self.rightAns, self.wrongAns1, self.wrongAns2, nil];

    [array shuffle];

    return array;
}

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
            @"cateId" : @"category_id",
            @"identifier" : @"id",
            @"question" : @"title",
            @"rightAns" : @"correct_answer",
            @"wrongAns1" : @"wrong_answer1",
            @"wrongAns2" : @"wrong_answer2"
    };
}

+ (void)map {
    [QuestionModels setupReplacedKeyFromPropertyName:^NSDictionary * {
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
