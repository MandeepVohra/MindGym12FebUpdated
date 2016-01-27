//
//  CWStarRateView+Level.m
//  fancard
//
//  Created by MEETStudio on 15-10-26.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "CWStarRateView+Level.h"

@implementation CWStarRateView (Level)

- (void)level:(NSInteger)winNumber
{
    int level;
    if (winNumber > 0 && winNumber < 5) {
        level = 1;
    }else if (winNumber >= 5 && winNumber < 25) {
        level = 2;
    }else if (winNumber >= 25 && winNumber < 75) {
        level = 3;
    }else if (winNumber >= 75 && winNumber < 125) {
        level = 4;
    }else if (winNumber >= 125) {
        level = 5;
    }
    switch (level) {
        case 1:
            self.scorePercent = 0.2;
            break;
        case 2:
            self.scorePercent = 0.4;
            break;
        case 3:
            self.scorePercent = 0.6;
            break;
        case 4:
            self.scorePercent = 0.8;
            break;
        case 5:
            self.scorePercent = 1.0;
            break;
        default:
            self.scorePercent = 0;
            break;
    }
}

- (void)starNum:(NSInteger)level
{
    switch (level) {
        case 1:
            self.scorePercent = 0.2;
            break;
        case 2:
            self.scorePercent = 0.4;
            break;
        case 3:
            self.scorePercent = 0.6;
            break;
        case 4:
            self.scorePercent = 0.8;
            break;
        case 5:
            self.scorePercent = 1.0;
            break;
        default:
            self.scorePercent = 0;
            break;
    }
}

@end
