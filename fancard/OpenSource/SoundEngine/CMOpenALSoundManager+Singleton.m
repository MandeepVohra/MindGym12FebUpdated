//
// Created by demo on 10/12/15.
//

#import "CMOpenALSoundManager+Singleton.h"


@implementation CMOpenALSoundManager (Singleton)

+ (instancetype)singleton {
    static dispatch_once_t pred = 0;
    static CMOpenALSoundManager *manager = nil;
    dispatch_once(&pred, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

@end