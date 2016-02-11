//
//  WelcomeViewController.m
//  fancard
//
//  Created by MEETStudio on 15-10-29.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "WelcomeViewController.h"
#import <PureLayout/PureLayout.h>
#import "UIFactory.h"
#import "Mconfig.h"
#import "MyFightViewController.h"
#import "CMOpenALSoundManager.h"
#import "CMOpenALSoundManager+Singleton.h"
#import "LogInViewController.h"
#import "LanbaooPrefs.h"
#import "ETGlobal.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSObject+MJKeyValue.h"
#import "NSDate+FormatDateString.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <AFNetworking/AFNetworking.h>
#import "FacebookUser.h"
#import "SingUpUser.h"
#import "UserInfo.h"
#import "APService.h"
#import "GPURLRequestManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <TwitterKit/Twitter.h>
#import <TwitterKit/TWTRUser.h>
@interface WelcomeViewController (){
    UIScrollView *scrollText;
    UIPageControl *pageControl;
}

@end

@implementation WelcomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   // self.navigationController.navigationBar.hidden = NO;
    //[self.view setBackgroundColor:[UIColor redColor]];
    [self ScrollLabel];
    
    if ([LanbaooPrefs sharedInstance].userId)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    //[self addLeftBtnArrow];
   // self.myTitle.text = @"Welcome";
//    self.playButton = [UIFactory createButtonWithFrame:CGRectZero
//                                                Target:self
//                                              Selector:@selector(playGeustGame)
//                                                 Image:@"Welcome_play"
//                                          ImagePressed:@"Welcome_play"];
//    [self.view addSubview:_playButton];
//    CGSize imageSize = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Welcome_play@2x" ofType:@"png"]].size;
//    float myheight = kScreenWidth * imageSize.height / imageSize.width;
//    [_playButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:80.0f];
//    [_playButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
//    [_playButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
//    [_playButton autoSetDimension:ALDimensionHeight toSize:myheight];
//
//    self.joinButton = [UIFactory createButtonWithFrame:CGRectZero
//                                                Target:self
//                                              Selector:@selector(toSignIn)
//                                                 Image:@"Welcome_join"
//                                          ImagePressed:@"Welcome_join"];
//    [self.view addSubview:_joinButton];
//
//    [_joinButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:80.0f];
//    [_joinButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
//    [_joinButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
//    [_joinButton autoSetDimension:ALDimensionHeight toSize:myheight];
    
    
    self.UserImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [self.view addSubview:self.UserImage];
    [self.UserImage setHidden:YES];
    
    
#pragma MasterCreationzWork
#pragma mark Logo MindGym 
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackroundImage"]];
    
    UIImageView *imageLogo = [[UIImageView alloc] initWithFrame:CGRectMake(60, 85, 203, 38)];
    [imageLogo setImage:[UIImage imageNamed:@"MindGymLogo"]];
    [self.view addSubview:imageLogo];
    
#pragma mark Buttons
    
    UIButton *buttonPracticeGame = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonPracticeGame addTarget:self
                           action:@selector(playGeustGame)
                 forControlEvents:UIControlEventTouchUpInside];
    [buttonPracticeGame setTitle:@"Practice Game" forState:UIControlStateNormal];
    [buttonPracticeGame.layer setCornerRadius:22];
    [buttonPracticeGame.layer setBorderWidth:1.0];
    buttonPracticeGame.titleLabel.font =[UIFont fontWithName:@"Montserrat-Regular" size:14.0];
    [buttonPracticeGame.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    buttonPracticeGame.frame = CGRectMake(50, 355, 219.0, 45.0);
    [self.view addSubview:buttonPracticeGame];
    
    
    UIButton *buttonJoin = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonJoin addTarget:self
                   action:@selector(FacebookButton:)
     forControlEvents:UIControlEventTouchUpInside];
    [buttonJoin setImage:[UIImage imageNamed:@"FaceBookicon"] forState:UIControlStateNormal];
    [buttonJoin setTitle:@"  Join for Facebook" forState:UIControlStateNormal];
    buttonJoin.titleLabel.font =[UIFont fontWithName:@"Montserrat-Regular" size:14.0];
    [buttonJoin setBackgroundColor:[UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:153.0/255.0 alpha:1.0]];
    [buttonJoin.layer setCornerRadius:22];
    buttonJoin.frame = CGRectMake(50, 420, 219.0, 45.0);
    [self.view addSubview:buttonJoin];
    
    
    UIButton *buttonJoinTwitter = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonJoinTwitter addTarget:self
                          action:@selector(TwitterButton:)
         forControlEvents:UIControlEventTouchUpInside];
    //[buttonJoinTwitter setImage:[UIImage imageNamed:@"FaceBookicon"] forState:UIControlStateNormal];
    [buttonJoinTwitter setTitle:@"  Join with Twitter" forState:UIControlStateNormal];
    buttonJoinTwitter.titleLabel.font =[UIFont fontWithName:@"Montserrat-Regular" size:14.0];
    [buttonJoinTwitter setBackgroundColor:[UIColor colorWithRed:85.0/255.0 green:172.0/255.0 blue:239.0/255.0 alpha:1.0]];
    [buttonJoinTwitter.layer setCornerRadius:22];
    buttonJoinTwitter.frame = CGRectMake(50, 480, 219.0, 45.0);
    [self.view addSubview:buttonJoinTwitter];
    
    
}

- (void)backPressed

{
    if ([CMOpenALSoundManager singleton]) {
        [[CMOpenALSoundManager singleton] playSoundWithID:2];
    }
    NSString *title = @"PLAY OR JOIN!";

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:title delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (void)playGeustGame
{
    
    if ([[CMOpenALSoundManager singleton] isBackGroundMusicPlaying])
    {
        [[CMOpenALSoundManager singleton] stopBackgroundMusic];
    }
    
    [self getQuestions];
}

- (void)getQuestions {
    NSString *command;
    command = @"get_guest_quiz";

    [self showHUD:@"" isDim:YES];
    NSLog(@"\nnow command:%@\n", command);
    [ETGlobal sharedGlobal].allQuizs = [NSMutableArray array];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
            @"command" : command,
            @"date": [[NSDate new] getDateStrWithFormat:kDateFormat]
    };
    [manager GET:kServerURL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//             NSLog(@"JSON: %@", responseObject);
             [QuestionModels map];

             NSMutableArray *arrayDic = [responseObject objectForKey:@"data"];
             [ETGlobal sharedGlobal].allQuizs = [QuestionModels objectArrayWithKeyValuesArray:arrayDic];
             [self hideHUD];
             if ([ETGlobal sharedGlobal].allQuizs.count > 0) {
                 MyFightViewController *random = [[MyFightViewController alloc] init];
                 random.isGuest = YES;
                 [self.navigationController pushViewController:random animated:YES];
             } else {
                 [self showHit:@"no questions"];
             }

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [self hideHUD];
                [self getQuestions];
            }];
}

- (void)toSignIn {
    LogInViewController *logIn = [[LogInViewController alloc] init];
    [self.navigationController pushViewController:logIn animated:YES];
}


#pragma mark ScrollLabel

-(void)ScrollLabel
{
    
    NSArray *arrayTextHeader = [[NSArray alloc] initWithObjects:@"Trivia Like Never Before",@"It's a League",@"The Questions", nil];
    NSArray *ArrayDescription = [[NSArray alloc] initWithObjects:@"A reimagined trivia experience designed for Basketball fans around the world.",@"games a day (14 per week) to move up the weekly ranks! Your points and rank reset at the end of each week.",@"Every quarter is a new category. The questions are designed to be entertaining and relevant. But you better hurry because the questions are gone forever at the end of the day! ", nil];
    
    UIView *LabelBg = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, 130)];
    [LabelBg setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:LabelBg];
    
    scrollText = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
    [scrollText setDelegate:self];
    CGFloat xpostion = 73;
    
    for (int i =0 ; i<[arrayTextHeader count]; i++)
    {
        UILabel *labelText = [[UILabel alloc] initWithFrame:CGRectMake(xpostion, 10, 270, 40)];
        [labelText setText:[arrayTextHeader objectAtIndex:i]];
        [labelText setTextColor:[UIColor whiteColor]];
        [scrollText addSubview:labelText];
        [labelText setFont:[UIFont fontWithName:@"Montserrat-Regular" size:16.0]];
        if (i == 0) {
            xpostion = xpostion + 350;
        }
        else if (i == 1)
        {
            xpostion = xpostion + 320;
        }
        
        
    }
    
    CGFloat xLine = 123;
  
    for (int k = 0 ; k <3; k++) {
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(xLine, 48, 60, 1)];
        [lineLabel setText:@""];
        [lineLabel setBackgroundColor:[UIColor whiteColor]];
        [scrollText addSubview:lineLabel];
        
        xLine = xLine+ 320;
    }
    
    CGFloat xDesc = 15;
    for (int j = 0 ; j <[ArrayDescription count]; j++) {
        UILabel *LabelDesc = [[UILabel alloc] initWithFrame:CGRectMake(xDesc, 50, 290, 70)];
        [LabelDesc setText:[ArrayDescription objectAtIndex:j]];
        [LabelDesc setTextColor:[UIColor whiteColor]];
        [LabelDesc setNumberOfLines:0];
        [LabelDesc setBackgroundColor:[UIColor clearColor]];
        [LabelDesc setTextAlignment:NSTextAlignmentCenter];
        [LabelDesc setFont:[UIFont fontWithName:@"Montserrat-Light" size:12.0]];
        [scrollText addSubview:LabelDesc];
        xDesc = xDesc+ 320;
    }
   
    
    pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(125,120,70,10);
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.3];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [LabelBg addSubview:pageControl];
    
    
    [scrollText setPagingEnabled:YES];
    [scrollText setScrollEnabled:YES];
    [LabelBg addSubview:scrollText];
    [scrollText setContentSize:CGSizeMake(scrollText.frame.size.width * 3, 100)];
    
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView  {
    NSInteger pageNumber = roundf(scrollView.contentOffset.x / (scrollView.frame.size.width));
    pageControl.currentPage = pageNumber;
}

-(void)TwitterButton:(id)sender{
    [self showHUD:@"" isDim:YES];
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            LLog(@"logged in user with id %@", session.userID);
            
            /* Get user info */
            [[[Twitter sharedInstance] APIClient] loadUserWithID:[session userID]
                                                      completion:^(TWTRUser *user,
                                                                   NSError *error) {
                                                          // handle the response or error
                                                          if (![error isEqual:nil]) {
                                                              LLog(@"Twitter info   -> user = %@ ", user.keyValues);
                                                              
                                                              SingUpUser *singUpUser = [[SingUpUser alloc] init];
                                                              singUpUser.firstname = user.screenName;
                                                              singUpUser.lastname = @"";
                                                              singUpUser.avatar = user.profileImageURL;
                                                              singUpUser.token = user.userID;
                                                              singUpUser.command = @"third_platform";
                                                              singUpUser.platform = @"2";
                                                              
                                                              [self postTokenMethod:singUpUser.keyValues];
                                                              
                                                          } else {
                                                              LLog(@"Twitter error getting profile : %@", [error localizedDescription]);
                                                              [self hideHUD];
                                                          }
                                                      }];
            
        } else {
            // log error
            [self hideHUD];
            LLog(@"error = %@", error);
        }
    }];

}

-(void)FacebookButton:(id)sender{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    NSArray *permissionsArray = @[@"email", @"public_profile", @"user_friends"];
    [login logInWithReadPermissions:permissionsArray handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
            NSLog(@"error %@", error);
        } else if (result.isCancelled) {
            // Handle cancellations
            NSLog(@"Cancelled");
        } else {
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
                [self fetchUserInfo];
            }
        }
    }];
}

- (void)fetchUserInfo {
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        [self showHUD:@"" isDim:YES];
        NSLog(@"Token is available");
        
        //        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" parameters:nil]
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields" : @"id,name,link,first_name,last_name,picture.type(large),email,birthday,bio,friends,friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"Fetched User Information:%@", result);
                 
                 FacebookUser *facebookUser = [FacebookUser objectWithKeyValues:result];
                 
                 SingUpUser *singUpUser = [[SingUpUser alloc] init];
                 singUpUser.firstname = facebookUser.first_name;
                 singUpUser.lastname = facebookUser.last_name;
                 singUpUser.avatar = (facebookUser.picture && facebookUser.picture.data) ? facebookUser.picture.data.url : @"";
                 singUpUser.token = facebookUser.id;
                 singUpUser.command = @"third_platform";
                 singUpUser.platform = @"3";
                 
               //  [self.UserImage sd_setImageWithURL:[NSURL URLWithString:facebookUser.picture.data.url] placeholderImage:[UIImage imageNamed:@""]];
                 
                 
                // [self CallNewServiceWithFirstname:facebookUser.first_name lastname:facebookUser.last_name FacebookId:facebookUser.id Command:@"third_platform" PlatForm:@"3"];
                 
                 
                 [self postTokenMethod:singUpUser.keyValues];
                 
             }
             else {
                 NSLog(@"Error %@", error);
                 [self hideHUD];
             }
         }];
        
    } else {
        [self hideHUD];
        NSLog(@"User is not Logged in");
    }
    
    //    // For more complex open graph stories, use `FBSDKShareAPI`
    //// with `FBSDKShareOpenGraphContent`
    ///* make the API call */
    //    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
    //            initWithGraphPath:@"/me/friends"
    //                   parameters:nil
    //                   HTTPMethod:@"GET"];
    //    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
    //            id result,
    //            NSError *error) {
    //        // Handle the result
    //        LLog(@"/me/friends result = %@", result);
    //    }];
}

- (void)postTokenMethod:(NSDictionary *)parameters {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
       LLog(@"parameters = %@", parameters);
    [manager POST:kServerURL
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              [self hideHUD];
              NSLog(@"postToken JSON:%@", responseObject);
              NSDictionary *userModel = (NSDictionary *) [responseObject objectForKey:@"data"];
              
              UserInfo *userInfo = [UserInfo objectWithKeyValues:userModel];
              [userInfo updateToDB];
              
              [LanbaooPrefs sharedInstance].userId = userInfo.id;
              [LanbaooPrefs sharedInstance].userName = [NSString stringWithFormat:@"%@ %@", userInfo.firstname, userInfo.lastname];
              
              [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                             UIRemoteNotificationTypeSound |
                                                             UIRemoteNotificationTypeAlert)
                                                 categories:nil];
              
              if ([LanbaooPrefs sharedInstance].userId) {
                  
                  [APService setAlias:[NSString stringWithFormat:@"%@%@", @"user", [LanbaooPrefs sharedInstance].userId]
                     callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                               object:self];
                  
              }
              
              [self _homeAction];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [self hideHUD];
              NSLog(@"Error:%@", error);
          }];
    
    
    
}

- (void)_homeAction {
   // [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setObject:@"LoginSuccessfull" forKey:@"SaveLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    MainViewController *mainView = [[MainViewController alloc] init];
    [self.navigationController pushViewController:mainView animated:YES];
}

/*
-(void)CallNewServiceWithFirstname:(NSString *)firstname lastname:(NSString *)lastname FacebookId:(NSString *)token Command:(NSString *)commandNew PlatForm:(NSString *)plat{
    
   
    NSString *urlString = [NSString stringWithFormat:@"%@",@"http://ec2-52-27-33-107.us-west-2.compute.amazonaws.com/phpfancard/API/index.php"];
    
    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *postbody = [NSMutableData data];
    
    //setting post parameter1
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"command\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[commandNew dataUsingEncoding:NSUTF8StringEncoding]];
    
    //setting post parameter2
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"platform\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"3" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //setting post parameter3
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"firstname\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[firstname dataUsingEncoding:NSUTF8StringEncoding]];
    
    //setting post parameter4
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lastname\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[lastname dataUsingEncoding:NSUTF8StringEncoding]];
    
    //setting post parameter4
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[token dataUsingEncoding:NSUTF8StringEncoding]];
    
    //setting post parameter2
//    NSData *imageData = UIImageJPEGRepresentation(cameraBtn.imageView.image, 90);
//    NSString* filename =[[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding];
//    
//    
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; image=\"%@.png\"\r\n",filename, filename] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [request setHTTPBody:postbody];
//    
//    
//    
//    // NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    
//    _timer  = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(stopActivity:) userInfo:nil repeats:NO];
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
