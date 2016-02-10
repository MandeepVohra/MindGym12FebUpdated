//
//  LevelsFriendsViewController.m
//  fancard
//
//  Created by Mandeep on 03/02/16.
//  Copyright © 2016 MEETStudio. All rights reserved.
//

#import "LevelsFriendsViewController.h"
#import "UIFactory.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <MJExtension/NSObject+MJKeyValue.h>
#import "LevelsFindFriendViewController.h"
#import "Mconfig.h"
#import "UIFactory.h"
#import "UserInfo.h"
#import "LanbaooPrefs.h"
#import "FrendsTableViewCell.h"
#import "CMOpenALSoundManager.h"
#import "CMOpenALSoundManager+Singleton.h"
@interface LevelsFriendsViewController ()<UISearchBarDelegate, UISearchDisplayDelegate,UITableViewDelegate, UITableViewDataSource>{
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *_userArray;
    NSMutableArray *_searchArray;
    NSMutableArray *data;
    NSArray *filterData;
}
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation LevelsFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    useridMY = [[LanbaooPrefs sharedInstance].userId intValue];
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    _titleView.backgroundColor = [UIColor colorWithRed:44.0/255.0 green:151.0/255.0 blue:223.0/255.0 alpha:1.0];
    [self.view addSubview:_titleView];
    
    UILabel* TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 100, 30)];
    [TitleLabel setTextColor:[UIColor whiteColor]];
    [TitleLabel setText:@"Find Friend"];
    [TitleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14.0]];
    [TitleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleView addSubview:TitleLabel];
    
    
    _backButton = [UIFactory createButtonWithFrame:CGRectMake(5, 10, 31, 30)
                                            Target:self
                                          Selector:@selector(backPressed)
                                             Image:@"BackArrow"
                                      ImagePressed:@"BackArrow"];
    [_titleView addSubview:_backButton];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 44)];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchBar.placeholder = @"Find Friends...";
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 88, kScreenWidth, kScreenHeight - 88) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor grayColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self _parseJson];
}
- (void)_parseJson {
   // [self showHUD:@"Loading..." isDim:NO];
    NSString *command = @"rank_friend_total";
    NSInteger userIdw = [LanbaooPrefs sharedInstance].userId.intValue;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"command" : command,
                                 @"uid" : @(userIdw)
                                 };
    
    [manager GET:kServerURL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //[self hideHUD];
             NSLog(@"JSON: %@", responseObject);
             NSMutableArray *arrayDic = [responseObject objectForKey:@"data"];
             _userArray = [UserInfo objectArrayWithKeyValuesArray:arrayDic];
             if (_userArray.count == 0) {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                     message:@"Add some friends from top100!"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                 [alertView show];
             }
             else{
                 [_tableView reloadData];
             }
             
//             NSLog(@"---%lu", (unsigned long) _userArray.count);
//             
//             //             for (TopHundredModel *tops in _userArray) {
//             //
//             //                 NSLog(@"name=%@",tops.username);
//             //             }
//             data = [NSMutableArray array];
//             
//             for (int i = 0; i < _userArray.count; i++) {
//                 UserInfo *tops = [[UserInfo alloc] init];
//                 tops = _userArray[i];
//                 NSString *userName = [NSString stringWithFormat:@"%@ %@", tops.firstname, tops.lastname];
//                 
//                 data[i] = userName;
//                 NSLog(@"##data:%@", data[i]);
//             }
//             [_tableView reloadData];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             [self _parseJson];
         }];
}

#pragma mark BackButton 
-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark TableMethods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.tableView)
    {
        return _userArray ? _userArray.count : 0;
    }
    else
    {
        return _searchArray ? _searchArray.count : 0;
    }

//    if ([whichApi isEqualToString:@"Search"]) {
//        if([_searchArray count]>0)
//        {
//            return [_searchArray count];
//        }
//        else{
//            return 0;
//        }
//    }
//    else if ([_userArray count]>0) {
//        return [_userArray count];
//    }
//    else
//        return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"FrendsTableViewCell";
    
    FrendsTableViewCell *cell = (FrendsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *outlets = [[NSBundle mainBundle] loadNibNamed:@"FrendsTableViewCell" owner:self options:nil];
        for (id outlet in outlets)
        {
            if ([outlet isKindOfClass:[FrendsTableViewCell class]])
            {
                cell = (FrendsTableViewCell *)outlet;
                break;
            }
        }
    }
    [cell.LabelCount setText:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
    
    if (tableView == self.tableView) {
        [cell.NameLabel setText:[NSString stringWithFormat:@"%@ %@",[[_userArray objectAtIndex:indexPath.row] valueForKey:@"firstname"],[[_userArray objectAtIndex:indexPath.row] valueForKey:@"lastname"]]];
        
        CGSize yourLabelSize = [cell.NameLabel.text sizeWithAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Montserrat-Regular" size:13.0]}];
        
        [cell.NameLabel setFrame:CGRectMake(cell.NameLabel.frame.origin.x, cell.NameLabel.frame.origin.y, yourLabelSize.width, cell.NameLabel.frame.size.height)];
        
        
        [cell.TickImage setFrame:CGRectMake(cell.NameLabel.frame.origin.x + yourLabelSize.width + 5, cell.TickImage.frame.origin.y, cell.TickImage.frame.size.height, cell.TickImage.frame.size.height)];
        
        [cell.NameLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:13.0]];
        [cell.NameLabel setTextColor:[UIColor colorWithRed:44.0/255.0 green:62.0/255.0 blue:80.0/255 alpha:1.0]];
        
        [cell.WonLostLabel setText:[NSString stringWithFormat:@"%ldW-%ldL",[[[_userArray objectAtIndex:indexPath.row] valueForKey:@"number_win"] integerValue],[[[_userArray objectAtIndex:indexPath.row] valueForKey:@"number_lost"] integerValue]]];
        [cell.WonLostLabel setFont:[UIFont fontWithName:@"Montserrat-Light" size:10.0]];
        [cell.WonLostLabel setTextColor:[UIColor colorWithRed:44.0/255.0 green:62.0/255.0 blue:80.0/255 alpha:1.0]];
        
        [cell.ProfilePic sd_setImageWithURL:[NSURL URLWithString:[[_userArray objectAtIndex:indexPath.row] valueForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"ImagePlaceholder"]];
        
        [cell.PointsLabel setText:[NSString stringWithFormat:@"%i Points",[[[_userArray objectAtIndex:indexPath.row] valueForKey:@"points_total"] intValue]]];
        [cell.PointsLabel setFont:[UIFont fontWithName:@"Montserrat-Light" size:10.0]];
        
        [cell.ChallengeButton setTag:indexPath.row];
        [cell.AddfriendButton setTag:indexPath.row];
        
        NSString *stringRate = [[_userArray objectAtIndex:indexPath.row]valueForKey:@"number_win"];
        int level = 0;
        
        if ([stringRate intValue]>0 && [stringRate intValue]<= 4)
        {
            level = 1;
        }
        else if ([stringRate intValue]>4 && [stringRate intValue]<= 24){
            level = 2;
            
        }
        else if ([stringRate intValue]>24 && [stringRate intValue]<= 74){
            level = 3;
            
        }
        else if ([stringRate intValue]>74 && [stringRate intValue]<= 124){
            level = 4;
            
        }
        else if ([stringRate intValue]>124){
            level = 5;
        }
        
        if (level==1) {
            [cell.RateImage1 setImage:[UIImage imageNamed:@"UserRateslected"]];
        }
        else if (level ==2){
            [cell.RateImage1 setImage:[UIImage imageNamed:@"UserRateslected"]];
            
            [cell.RateImage2 setImage:[UIImage imageNamed:@"UserRateslected"]];
        }
        else if (level ==3){
            [cell.RateImage1 setImage:[UIImage imageNamed:@"UserRateslected"]];
            
            [cell.RateImage2 setImage:[UIImage imageNamed:@"UserRateslected"]];
            [cell.RateImage3 setImage:[UIImage imageNamed:@"UserRateslected"]];
        }
        else if (level ==4){
            [cell.RateImage1 setImage:[UIImage imageNamed:@"UserRateslected"]];
            
            [cell.RateImage2 setImage:[UIImage imageNamed:@"UserRateslected"]];
            [cell.RateImage3 setImage:[UIImage imageNamed:@"UserRateslected"]];
            [cell.RateImage4 setImage:[UIImage imageNamed:@"UserRateslected"]];
        }
        else if (level ==5){
            [cell.RateImage1 setImage:[UIImage imageNamed:@"UserRateslected"]];
            
            [cell.RateImage2 setImage:[UIImage imageNamed:@"UserRateslected"]];
            [cell.RateImage3 setImage:[UIImage imageNamed:@"UserRateslected"]];
            [cell.RateImage4 setImage:[UIImage imageNamed:@"UserRateslected"]];
            [cell.RateImage5 setImage:[UIImage imageNamed:@"UserRateslected"]];
        }

    }
    else
    {
        [cell.NameLabel setText:[NSString stringWithFormat:@"%@ %@",[[_searchArray objectAtIndex:indexPath.row] valueForKey:@"firstname"],[[_searchArray objectAtIndex:indexPath.row] valueForKey:@"lastname"]]];
        
        CGSize yourLabelSize = [cell.NameLabel.text sizeWithAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Montserrat-Regular" size:13.0]}];
        
        [cell.NameLabel setFrame:CGRectMake(cell.NameLabel.frame.origin.x, cell.NameLabel.frame.origin.y, yourLabelSize.width, cell.NameLabel.frame.size.height)];
        
        
        [cell.TickImage setFrame:CGRectMake(cell.NameLabel.frame.origin.x + yourLabelSize.width + 5, cell.TickImage.frame.origin.y, cell.TickImage.frame.size.height, cell.TickImage.frame.size.height)];
        
        [cell.NameLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:13.0]];
        [cell.NameLabel setTextColor:[UIColor colorWithRed:44.0/255.0 green:62.0/255.0 blue:80.0/255 alpha:1.0]];
        
        [cell.WonLostLabel setText:[NSString stringWithFormat:@"%ldW-%ldL",[[[_searchArray objectAtIndex:indexPath.row] valueForKey:@"number_win"] integerValue],[[[_searchArray objectAtIndex:indexPath.row] valueForKey:@"number_lost"] integerValue]]];
        [cell.WonLostLabel setFont:[UIFont fontWithName:@"Montserrat-Light" size:10.0]];
        [cell.WonLostLabel setTextColor:[UIColor colorWithRed:44.0/255.0 green:62.0/255.0 blue:80.0/255 alpha:1.0]];
        
        [cell.ProfilePic sd_setImageWithURL:[NSURL URLWithString:[[_searchArray objectAtIndex:indexPath.row] valueForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"ImagePlaceholder"]];
        
        [cell.PointsLabel setText:[NSString stringWithFormat:@"%i Points",[[[_searchArray objectAtIndex:indexPath.row] valueForKey:@"points_total"] intValue]]];
        [cell.PointsLabel setFont:[UIFont fontWithName:@"Montserrat-Light" size:10.0]];
        
        [cell.ChallengeButton setTag:indexPath.row];
        [cell.AddfriendButton setTag:indexPath.row];
        
        NSString *stringRate = [[_searchArray objectAtIndex:indexPath.row]valueForKey:@"number_win"];
        int level = 0;
        
        if ([stringRate intValue]>0 && [stringRate intValue]<= 4)
        {
            level = 1;
        }
        else if ([stringRate intValue]>4 && [stringRate intValue]<= 24){
            level = 2;
            
        }
        else if ([stringRate intValue]>24 && [stringRate intValue]<= 74){
            level = 3;
            
        }
        else if ([stringRate intValue]>74 && [stringRate intValue]<= 124){
            level = 4;
            
        }
        else if ([stringRate intValue]>124){
            level = 5;
        }
        
        if (level==1) {
            [cell.RateImage1 setImage:[UIImage imageNamed:@"UserRateslected"]];
        }
        else if (level ==2){
            [cell.RateImage1 setImage:[UIImage imageNamed:@"UserRateslected"]];
            
            [cell.RateImage2 setImage:[UIImage imageNamed:@"UserRateslected"]];
        }
        else if (level ==3){
            [cell.RateImage1 setImage:[UIImage imageNamed:@"UserRateslected"]];
            
            [cell.RateImage2 setImage:[UIImage imageNamed:@"UserRateslected"]];
            [cell.RateImage3 setImage:[UIImage imageNamed:@"UserRateslected"]];
        }
        else if (level ==4){
            [cell.RateImage1 setImage:[UIImage imageNamed:@"UserRateslected"]];
            
            [cell.RateImage2 setImage:[UIImage imageNamed:@"UserRateslected"]];
            [cell.RateImage3 setImage:[UIImage imageNamed:@"UserRateslected"]];
            [cell.RateImage4 setImage:[UIImage imageNamed:@"UserRateslected"]];
        }
        else if (level ==5){
            [cell.RateImage1 setImage:[UIImage imageNamed:@"UserRateslected"]];
            
            [cell.RateImage2 setImage:[UIImage imageNamed:@"UserRateslected"]];
            [cell.RateImage3 setImage:[UIImage imageNamed:@"UserRateslected"]];
            [cell.RateImage4 setImage:[UIImage imageNamed:@"UserRateslected"]];
            [cell.RateImage5 setImage:[UIImage imageNamed:@"UserRateslected"]];
        }

    }
    
    
    
    
//    UserInfo *tops;
//    
//    if (tableView == self.tableView) {
//        tops = _userArray[indexPath.row];
//        
//    } else {
//        tops = _searchArray[indexPath.row];
//    }
//    
//    cell.topModel = tops;
//    
//    [cell.myStarRateView level:tops.number_win];
//    
//    NSInteger num = tops.points_total;
//    if (num >= 999) {
//        long h = num % 1000;
//        long k = num / 1000;
//        cell.numPoints.text = [NSString stringWithFormat:@"%ld,%.3ld", k, h];
//    } else {
//        cell.numPoints.text = [NSString stringWithFormat:@"%d", tops.points_total];
//    }
//    
//    NSString *userName = [NSString stringWithFormat:@"%@ %@", tops.firstname, tops.lastname];
//    cell.userName.text = [NSString stringWithFormat:@"%ld.%@", (long) indexPath.row + 1, userName];
//    
//    NSString *wonLost = [NSString stringWithFormat:@"%d-%d", tops.number_win, tops.number_lost];
//    cell.wonLost.text = wonLost;
//    
//    return cell;

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [self searchUser:searchText];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
   // [_userArray removeAllObjects];
    
   // whichApi = @"Friends";
    [self _parseJson];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
   
}

#pragma mark search

- (void)searchUser:(NSString *)keyword {
    
    whichApi = @"Search";
    if (keyword.length == 0) {
        return;
    }
    
    NSString *uid = [LanbaooPrefs sharedInstance].userId;
    
    WS(weakSelf)
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long) [[NSDate new] timeIntervalSince1970]];
    //    NSString *mURL = [[NSString alloc] initWithFormat:@"%@%@?uid=%@&keyword=%@&pageNo=%d&pageSize=30&time=%@", kServeURL, kTimelineSearch, uid, keyword, searchPageNo, timeSp];
    //    NSString *encodedValue = [mURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    LLog(@"mURL = %@", mURL);
    
    NSDictionary *parameters = @{
                                 @"command" : @"find_user",
                                 @"p" : @"1",
                                 @"s" : @"50",
                                 @"key" : keyword
                                 };
    
    [manager GET:kServerURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != nil) {
            
            _searchArray = [[NSMutableArray alloc] init];
            NSDictionary *dataDic = (NSDictionary *) [responseObject objectForKey:@"data"];
            
            if ([dataDic[@"result"] isKindOfClass:[NSArray class]])
            {
                NSMutableArray *arrayDic = dataDic[@"result"];
                NSMutableArray *userArray = [UserInfo objectArrayWithKeyValuesArray:arrayDic];
                [_searchArray addObjectsFromArray:userArray];
            }
            
             [self.tableView reloadData];
           
        }
        
        
        //        weakSelf.searchDisplayController.searchResultsTableView.footer.hidden = searchBabyArray.count < 30;
        
        //        [weakSelf hideLoading];
        
        //        [weakSelf.searchDisplayController.searchResultsTableView.header endRefreshing];
        //        [weakSelf.searchDisplayController.searchResultsTableView.footer endRefreshing];
        
    }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //        [weakSelf hideLoading];
        //        [weakSelf.treeView.header endRefreshing];
        //        [weakSelf.treeView.footer endRefreshing];
        
        LLog(@"%@", error);
    }];
    
}


-(IBAction)AddfRIEND:(UIButton *)BUTT{
    NSString *strinUserid = [[_userArray objectAtIndex:[BUTT tag]] valueForKey:@"id"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"command" : @"add_friends",
                                 @"uid" : [NSString stringWithFormat:@"%i",useridMY],
                                 @"fid" : strinUserid
                                 };
    [manager POST:kServerURL
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON:%@", responseObject);
              NSString *message = [responseObject objectForKey:@"message"];
              if ([message isEqualToString:@"he is your friend,you can not add again"]) {
                  message = @"already your friend!";
                  
                  [[[UIAlertView alloc] initWithTitle:@"Alert!!" message:message delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
                  
              } else {
                  //                  [self showHUdComplete:message];
                  [[[UIAlertView alloc] initWithTitle:@"Alert!!" message:message delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error:%@", error);
              //[self showHUdCompleteWithTitle:@"check the network!"];
              [[[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Check the Network" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
          }];
    
}

-(IBAction)ChallengeButtonMethod:(UIButton *)button{
    // int type = userModels.type.intValue;
    //UserInfo *_userModel;
    int Type = [[[_userArray objectAtIndex:[button tag]] valueForKey:@"type"] intValue];
    
    //_userModel = userModels;
    NSString *alertString = @"alert";
    
    if (Type == 3 || userUserId == [[[_userArray objectAtIndex:[button tag]] valueForKey:@"id"] intValue]) {
        if (userUserId == useridMY) {
            alertString = @"Yourself!";
        } else {
            alertString = @"User has already played VS a Friend today!";
        }
        [[CMOpenALSoundManager singleton] playSoundWithID:3];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:alertString
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        
        UserInfo *userInfo = [UserInfo searchSingleWithWhere:nil orderBy:nil];
        
        NSString *dateStr = userInfo.lastFrdFight;
        NSDate *dateFight = [dateStr getDateWithFormat:kDateFormat];
        
        NSDate *dateNow = [NSDate new];
        NSString *dateNowStr = [dateNow getDateStrWithFormat:@"yyyy-MM-dd"];
        
        if (dateFight) {
            
            if ([dateNowStr isEqualToString:[dateFight getDateStrWithFormat:@"yyyy-MM-dd"]]) {
                [[CMOpenALSoundManager singleton] playSoundWithID:3];
                [[[UIAlertView alloc] initWithTitle:@"Alert"
                                            message:@"You have already played today."
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                
                return;
            }
        }
        
        
        //dateStr = userModels.lastFrdFight;
        dateStr = [[_userArray objectAtIndex:[button tag]] valueForKey:@"lastFrdFight"];
        dateFight = [dateStr getDateWithFormat:kDateFormat];
        
        if (dateFight) {
            if ([dateNowStr isEqualToString:[dateFight getDateStrWithFormat:@"yyyy-MM-dd"]]) {
                [[[UIAlertView alloc] initWithTitle:@"Alert"
                                            message:@"They have already played today."
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                
                return;
            }
        }
    }
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
