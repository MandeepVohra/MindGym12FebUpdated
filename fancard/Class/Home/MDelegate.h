//
//  MDelegate.h
//  fancard
//
//  Created by MEETStudio on 15-10-16.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#ifndef fancard_MDelegate_h
#define fancard_MDelegate_h

@class UserInfo;

@protocol AcceptChallengeDelegate <NSObject>
@optional

- (void)acceptChallenge:(UserInfo *)userInfo;

@end

@protocol ResponseDelegate <NSObject>
@optional

- (void)responseChallenge:(UserInfo *)userInfo;

@end

#endif
