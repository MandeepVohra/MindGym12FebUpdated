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
    
    
#pragma MasterCreationzWork
#pragma mark Logo MindGym 
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackroundImage"]];
    
    UIImageView *imageLogo = [[UIImageView alloc] initWithFrame:CGRectMake(60, 85, 203, 38)];
    [imageLogo setImage:[UIImage imageNamed:@"MindGymLogo"]];
    [self.view addSubview:imageLogo];
    
#pragma mark Buttons
    
    UIButton *buttonJoin = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonJoin addTarget:self
               action:@selector(toSignIn)
     forControlEvents:UIControlEventTouchUpInside];
    [buttonJoin setImage:[UIImage imageNamed:@"FaceBookicon"] forState:UIControlStateNormal];
    [buttonJoin setTitle:@"  Join for League" forState:UIControlStateNormal];
    buttonJoin.titleLabel.font =[UIFont fontWithName:@"Montserrat-Regular" size:14.0];
    [buttonJoin setBackgroundColor:[UIColor colorWithRed:44.0/255.0 green:151.0/255.0 blue:222.0/255.0 alpha:1.0]];
    [buttonJoin.layer setCornerRadius:22];
    buttonJoin.frame = CGRectMake(50, 400, 219.0, 45.0);
    [self.view addSubview:buttonJoin];
    
    UIButton *buttonPracticeGame = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonPracticeGame addTarget:self
                   action:@selector(playGeustGame)
         forControlEvents:UIControlEventTouchUpInside];
   
    [buttonPracticeGame setTitle:@"Practice Game" forState:UIControlStateNormal];
    [buttonPracticeGame.layer setCornerRadius:22];
    [buttonPracticeGame.layer setBorderWidth:1.0];
     buttonPracticeGame.titleLabel.font =[UIFont fontWithName:@"Montserrat-Regular" size:14.0];
    [buttonPracticeGame.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    buttonPracticeGame.frame = CGRectMake(50, 470, 219.0, 45.0);
    [self.view addSubview:buttonPracticeGame];
    
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
