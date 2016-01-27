//
//  playerScore.h
//  fancard
//
//  Created by MEETStudio on 15-10-17.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface playerScore : NSObject

@property(nonatomic, assign) int playerId;
@property(nonatomic, assign) int score;

+ (void)map;

@end
