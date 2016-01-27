//
//  UniversalButton.m
//  fancard
//
//  Created by MEETStudio on 15-10-12.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "UniversalButton.h"
#import "CMOpenALSoundManager+Singleton.h"
#import "LanbaooPrefs.h"

@implementation UniversalButton

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    [super sendAction:action to:target forEvent:event];
    if (![LanbaooPrefs sharedInstance].soundOff) {
        [[CMOpenALSoundManager singleton] playSoundWithID:2];
    }
}

@end
