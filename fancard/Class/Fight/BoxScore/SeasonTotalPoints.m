//
//  SeasonTotalPoints.m
//  fancard
//
//  Created by MEETStudio on 15-11-18.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "SeasonTotalPoints.h"

@implementation SeasonTotalPoints

- (void)addScoreWithMyCurrentScore:(int)myCurrentScore opponentCurrentScore:(int)opponentCurrentScore
{
    self.mySeasonQuestion += 1;
    self.oppSeasonQuestion += 1;
    if (myCurrentScore == 2 || myCurrentScore == 3) {
        self.myCorrectQuestion += 1;
        self.mySeasonScore += myCurrentScore;
    }
    if (opponentCurrentScore == 2 || opponentCurrentScore == 3) {
        self.oppCorrectQuestion += 1;
        self.oppSeasonScore += opponentCurrentScore;
    }
}

- (void)updateMyCurrentScoreWithScore:(int)score{
    self.mySeasonQuestion += 1;
    if (score == 2 || score == 3) {
        self.myCorrectQuestion += 1;
        self.mySeasonScore += score;
    }

}

- (void)updateOppCurrentScoreWithScore:(int)score{
    self.oppSeasonQuestion += 1;
    if (score == 2 || score == 3) {
        self.oppCorrectQuestion +=1;
        self.oppSeasonScore += score;
    }
}

@end
