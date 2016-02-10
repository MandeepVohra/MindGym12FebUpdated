//
//  VSInfoViewController.h
//  fancard
//
//  Created by MEETStudio on 15-8-28.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "BaseViewController.h"
#import "ItemInfoView.h"
#import "SRWebSocket.h"
#import "BotModel.h"

@interface VSInfoViewController : BaseViewController

@property(nonatomic, strong) UILabel *labelName;
@property(nonatomic, strong) UIImageView *avatar;
@property(nonatomic, strong) ItemInfoView *points;
@property(nonatomic, strong) ItemInfoView *ppg;     //points per game
@property(nonatomic, strong) ItemInfoView *rank;
@property(nonatomic, strong) ItemInfoView *wonLost;

@property (nonatomic, assign) NSInteger joinCD24;  //time remain of 24s

@property (nonatomic, assign) BOOL isChallenger;   //This device send the challenge
@property (nonatomic, assign) BOOL isAccept;       //This device accepts the challenge

@property (nonatomic, assign) NSInteger friendId;
@property (nonatomic, strong) UserInfo *friendModel;
@property (nonatomic, strong) BotModel *botModel;
@property (nonatomic ,retain) UIView *AcceptChallengeView;
@property (nonatomic ,retain) UIImageView *MyacceptChallengeImageView,*UseracceptChallengeImageView;
@property (nonatomic ,retain) UILabel *MyNameLabel,*UserNameLabel,*laebelPPgUserValue,*laebelWLValueUser,*laebelRankUserValue,*laebelPointUserValue;
@property (nonatomic ,retain) NSString *stringMyName ,*stringmypoints,* stringMyRank,*stringMyPPG,*StringMyWinLoss,*stringMyLevel;
@end
