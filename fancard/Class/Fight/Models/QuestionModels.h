//
//  QuestionModels.h
//  fancard
//
//  Created by MEETStudio on 15-9-16.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModels : NSObject

@property(assign, nonatomic) int cateId;         //---topic
@property(assign, nonatomic) int identifier;      //question id
@property(assign, nonatomic) int quarter;      //question id
@property(strong, nonatomic) NSString *question;
@property(strong, nonatomic) NSString *rightAns;
@property(strong, nonatomic) NSString *wrongAns1;
@property(strong, nonatomic) NSString *wrongAns2;

+ (void)map;

- (NSArray *)answers;

@end
