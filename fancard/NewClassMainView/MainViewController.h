//
//  MainViewController.h
//  fancard
//
//  Created by Mandeep on 27/01/16.
//  Copyright © 2016 MEETStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "GetChallenge.h"
#import "SRWebSocket.h"
#import "UserInfo.h"
//#import "AnswerViewController.h"
#import "YesterDayViewController.h"
#import "LevelsFriendsViewController.h"
#import "ProfileViewController.h"
//#import "WelcomeViewController.h"
@interface MainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ResponseDelegate,UIGestureRecognizerDelegate>{
    int userid,page;
    BOOL hasNextPage;
    GetChallenge *chaView;
 NSMutableArray *challengerArr;
    
    NSString *beanTime;
    NSTimer *m_pTimer;
    NSDate *m_pStartDate;
    NSDate *newDate;
 double oddTime;
    
    
    NSString *stringButtonOption;
    int userUserId;
    
    
    
    UIView *_background;
    UIButton *_cancelButton;
    UIView *_challengeView;
    UILabel *_oppNameLabel;
    UIButton *_buttonChallenge;
    int _friendId;
    
    int LevelChallenge;
    UserInfo *newuserifochallenge;
    
    
}

@property (nonatomic,retain)  UIView *MainFrontView,*SliderView;
@property (nonatomic,retain)  UIImageView *largeImage,*BottomImageFrend,*Bottom100Image,*verifiedBottom;
@property (nonatomic,retain)  UILabel *NameLabel,*FrendsLabel,*Top100Label,*VerifiedLabel;
@property (nonatomic,retain) UITableView *tableDetail;

@property (nonatomic,retain)  UIImageView *HomeIcon,*YeterDayImage,*NotificationImage,*MusicImage,*SoundImage,*PlayImage,*ContactUsImage,*TermsImage,*LogoutImage;
@property (nonatomic,retain)  UILabel *HomeLabel,*YesterdayLabel,*NotificationLabel,*MusicLabel,*SoundLabel,*PlayLabel,*ContactUsLabel,*TermsLabel,*Logoutlabel;
@property (nonatomic,retain) UIButton *HomeButton,*YesterdayButton,*HowtoPlayButton,*ContactButton,*TermsButton,*LogoutButton;
@property (nonatomic,retain)  UIImageView *ArrowHome,*ArrowYesterday,*ArrowHowtoplay,*ArrowContactUs,*ArrowTerms,*ArrowLogout;
@property (nonatomic,retain) NSMutableArray *_userArray;
@property(nonatomic, assign) BOOL isFindFriend;

@property (nonatomic, assign) NSInteger fid;
@property (nonatomic,retain)  UILabel *DateLabel,*DayLabel;



@property (nonatomic,retain)  LevelsFriendsViewController *levelsFriends;

@property (nonatomic,retain) UIView *ChallengeView;
@property (nonatomic,retain) UIImageView *ChallengeUserImage,*challengeRate1,*Challengerate2,*challengerate3,*challengerate4,*challengerate5;
@property (nonatomic,retain) UILabel *challengeNameLabel,*ChallengePointLabel,*ChallengePointValueLabel,*challengePPGlabel,*ChallengePPGValueLabel,*challengewinlossLabel,*challengewinloosvaluelabel;
@property (nonatomic,retain) NSString *STRmyname,*STRmyPoints,*STRMyppg,*STRmywinloss,*STRMyRank,*STRMylevel;
@end
