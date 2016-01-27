//
//  RankDelegate.h
//  fancard
//
//  Created by MEETStudio on 15-11-19.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#ifndef fancard_RankDelegate_h
#define fancard_RankDelegate_h

@class UserInfo;

@protocol LeadersDelegate <NSObject>
@optional

//Click the button to challenge this challenge players
- (void)toChallenge:(UserInfo *)userModels withRank:(NSString *)rank;

@end

@protocol addFriendDelegate <NSObject>
@required

- (void)addFriendByUserModel:(UserInfo *)userModel;

@end

#endif
