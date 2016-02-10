//
//  LeaderViewController.h
//  fancard
//
//  Created by MEETStudio on 15-8-27.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "BaseViewController.h"
#import "LeadersCell.h"
#import "SRWebSocket.h"
#import "PagedFlowView.h"

@interface LeaderViewController : BaseViewController <LeadersDelegate, addFriendDelegate, PagedFlowViewDelegate, PagedFlowViewDataSource>

@property(nonatomic, strong) UserInfo *friendModel;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, assign) BOOL isFindFriend;

- (void)toChallenge:(UserInfo *)userModels withRank:rank;

@end
