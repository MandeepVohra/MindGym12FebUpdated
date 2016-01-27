//
//  MainViewController.m
//  fancard
//
//  Created by Mandeep on 27/01/16.
//  Copyright © 2016 MEETStudio. All rights reserved.
//

#import "MainViewController.h"
#import "Mconfig.h"
#import "UIFactory.h"
#import "SettingsViewController.h"
#import "LeaderViewController.h"
#import "VSInfoViewController.h"
#import "UIViewExt.h"
#import "LevelsViewController.h"
#import "LogInViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "UIView+Round.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <LKDBHelper/NSObject+LKDBHelper.h>
#import "CMOpenALSoundManager.h"
#import "CMOpenALSoundManager+Singleton.h"
#import "WelcomeViewController.h"
#import "NSDate+FormatDateString.h"
#import "NSString+StringFormatDate.h"
#import "MySocket.h"
#import "UserInfo.h"
#import "LanbaooPrefs.h"
#import "LevelsFindFriendViewController.h"
#import "NSDictionary+NotNULL.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
    self.MainFrontView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.MainFrontView];
    
    self.largeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 287)];
    [self.largeImage setImage:[UIImage imageNamed:@"LargePlaceholder"]];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = self.largeImage.frame;
    [self.largeImage addSubview:effectView];
    [self.MainFrontView addSubview:self.largeImage];
    
    
    UIButton *buttonMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonMenu addTarget:self
                   action:@selector(toSignIn)
         forControlEvents:UIControlEventTouchUpInside];
    [buttonMenu setImage:[UIImage imageNamed:@"MenuListIcon"] forState:UIControlStateNormal];
    buttonMenu.frame = CGRectMake(17, 25, 23, 23);
    [self.MainFrontView addSubview:buttonMenu];
    
    
    UIButton *buttonContacts = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonContacts addTarget:self
                   action:@selector(toSignIn)
         forControlEvents:UIControlEventTouchUpInside];
    [buttonContacts setImage:[UIImage imageNamed:@"Frendicon"] forState:UIControlStateNormal];
    buttonContacts.frame = CGRectMake(280, 25, 23, 23);
    [self.MainFrontView addSubview:buttonContacts];
    
    
    UIImageView *imageProfile = [[UIImageView alloc] initWithFrame:CGRectMake(120, 50, 81, 80)];
    [imageProfile setImage:[UIImage imageNamed:@"SmallPlaceholder"]];
    [self.MainFrontView addSubview:imageProfile];
    
    
    UIImageView *ImagePropilepic = [[UIImageView alloc] initWithFrame:CGRectMake(126, 56, 69, 69)];
    [ImagePropilepic setImage:[UIImage imageNamed:@"Profilepic"]];
    ImagePropilepic.layer.cornerRadius = ImagePropilepic.layer.frame.size.width/2;
    [ImagePropilepic setClipsToBounds:YES];
    [self.MainFrontView addSubview:ImagePropilepic];
    
   
    self.NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 200, 30)];
    [self.NameLabel setTextColor:[UIColor whiteColor]];
    [self.NameLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14.0]];
    [self.MainFrontView addSubview:self.NameLabel];
    
}

-(void)viewWillAppear:(BOOL)animated

{
    if (![LanbaooPrefs sharedInstance].musicOff)
    {
        [[CMOpenALSoundManager singleton] playBackgroundMusic:@"Mind-Gym-Main.mp3"];
    }
    
    if ([LanbaooPrefs sharedInstance].userId.intValue == 0)
    {
        [self welcomePage];
    }
    
     [self getUserInfo];
    
}

- (void)welcomePage
{
    WelcomeViewController *welcome = [[WelcomeViewController alloc] init];
    welcome.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:welcome];
    [self presentViewController:navCtrl animated:NO completion:nil];
}

- (void)getUserInfo
{
    
    WS(weakSelf)
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long) [[NSDate new] timeIntervalSince1970]];
    //    NSDictionary *dic = @{@"uid" : uid};
    NSString *mURL = kServerURL;
    LLog(@"mURL = %@", mURL);
    
    NSString *uid = [LanbaooPrefs sharedInstance].userId;
    
    if (uid.length == 0 || uid.intValue == 0) {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"command" : @"index_rank",
                                 @"uid" : uid,
                                 };
    
    [manager GET:mURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *data = responseObject;
        if ([data[@"data"] isKindOfClass:[NSDictionary class]]) {
            //            [weakSelf showData:data[@"result"]];
            //            UserInfo *userInfo = [UserInfo searchSingleWithWhere:nil orderBy:nil];
            //            UserRankIndex *userRankIndex = [UserRankIndex objectWithKeyValues:data[@"data"]];
            UserInfo *userInfo = [UserInfo objectWithKeyValues:data[@"data"]];
            
            //            userInfo.points_week = userRankIndex.points_week;
            //            userInfo.points_total = userRankIndex.totalPoints;
            //            userInfo.number_win = userRankIndex.winCount;
            //            userInfo.number_lost = userRankIndex.loseCount;
            //            userInfo.rank = @(userRankIndex.rank).stringValue;
            //            userInfo.lastBotFight = userRankIndex.lastBotFight;
            //            userInfo.lastFrdFight = userRankIndex.lastFrdFight;
            
            [self.NameLabel setText:[NSString stringWithFormat:@"%@ %@",[userInfo valueForKey:@"firstname"],[userInfo valueForKey:@"lastname"]]];
            
            
            if (userInfo) {
                [userInfo updateToDB];
            }
            
            [LanbaooPrefs sharedInstance].rank = userInfo.rank.intValue;
           // [self refreshInfo];
            
        }
    }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
