//
//  NSMutableArray+shuffling.m
//  fancard
//
//  Created by MEETStudio on 15-10-25.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "NSMutableArray+shuffling.h"

@implementation NSMutableArray (shuffling)

- (void)shuffle {
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        //Select a random element between i and end of array to swap with.
        NSUInteger nElements = count - i;
        NSUInteger n = (arc4random() % nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
