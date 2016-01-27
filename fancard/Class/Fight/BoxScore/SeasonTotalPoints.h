//
//  SeasonTotalPoints.h
//  fancard
//
//  Created by MEETStudio on 15-11-18.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeasonTotalPoints : NSObject

@property (nonatomic, assign) int myCorrectQuestion;
@property (nonatomic, assign) int mySeasonQuestion;
@property (nonatomic, assign) int mySeasonScore;

@property (nonatomic, assign) int oppCorrectQuestion;
@property (nonatomic, assign) int oppSeasonQuestion;
@property (nonatomic, assign) int oppSeasonScore;

- (void)addScoreWithMyCurrentScore:(int)myCurrentScore opponentCurrentScore:(int)opponentCurrentScore;

- (void)updateMyCurrentScoreWithScore:(int)score;
- (void)updateOppCurrentScoreWithScore:(int)score;



@end
