//
//  FindFriendViewController.m
//  fancard
//
//  Created by MEETStudio on 15-9-8.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "FindFriendViewController.h"
#import "UIFactory.h"
#import "Mconfig.h"
#import "LeadersCell.h"
#import "LanbaooPrefs.h"
#import "UserInfo.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>

@interface FindFriendViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate> {
    
    UIButton *_findFriend;

    NSMutableArray *_userArray;   //
    NSMutableArray *data;         //search data
    NSArray *filterData;
    UISearchDisplayController *searchDisplayController;

}
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation FindFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    _titleView.backgroundColor = [UIColor colorWithRed:162 / 255.0 green:0 blue:20 / 255.0 alpha:1.0f];
    [self.view addSubview:_titleView];
    _backButton = [UIFactory createButtonWithFrame:CGRectMake(5, 10, 44, 30)
                                            Target:self
                                          Selector:@selector(backPressed)
                                             Image:@"Btn_back"
                                      ImagePressed:@"Btn_back"];
    [_titleView addSubview:_backButton];
   
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,44, kScreenWidth, 44)];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchBar.placeholder = @"Find Friends...";
    searchBar.delegate = self;
    [self.view addSubview:searchBar];

    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];

    // searchResultsDataSource is UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate is UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
    

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 88, kScreenWidth, kScreenHeight - 88) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor grayColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self _parseJson];
}
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    [searchBar setShowsCancelButton:YES animated:YES];
//    for (UIView *searchbuttons in [searchBar subviews]) {
//        if ([searchbuttons isKindOfClass:[UIButton class]]) {
//            UIButton *cancelButton = (UIButton *)searchbuttons;
//            [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//            [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_close.png"] forState:UIControlStateNormal];
//            [cancelButton setBackgroundImage:nil forState:UIControlStateHighlighted];
//        }
//    }
//}


- (void)_parseJson {
    [self showHUD:@"Loading..." isDim:NO];
    NSString *command = @"rank_friend_total";
    NSInteger userId = [LanbaooPrefs sharedInstance].userId.intValue;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"command":command,
                                 @"uid":@(userId)
                                 };

    [manager GET:kServerURL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [self hideHUD];
             NSLog(@"JSON: %@", responseObject);
             NSMutableArray *arrayDic = [responseObject objectForKey:@"data"];
             _userArray = [UserInfo objectArrayWithKeyValuesArray:arrayDic];
             if (_userArray.count ==0) {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                     message:@"Add some friends from top100!"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                 [alertView show];
             }

             NSLog(@"---%lu", (unsigned long) _userArray.count);

//             for (TopHundredModel *tops in _userArray) {
//                 
//                 NSLog(@"name=%@",tops.username);
//             }
             data = [NSMutableArray array];

             for (int i = 0; i < _userArray.count; i++) {
                 UserInfo *tops = [[UserInfo alloc] init];
                 tops = _userArray[i];
                 NSString *userName = [NSString stringWithFormat:@"%@ %@",tops.firstname,tops.lastname];
                    
                 data[i] = userName;
                 NSLog(@"##data:%@", data[i]);
             }
             [_tableView reloadData];

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                [self _parseJson];
            }];
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return _userArray.count;
    
    } else {

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@", searchDisplayController.searchBar.text];
        filterData = [[NSArray alloc] initWithArray:[data filteredArrayUsingPredicate:predicate]];
        return filterData.count;
    }
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"LeadersCell";
    LeadersCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[LeadersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    if (tableView == self.tableView) {
        UserInfo *tops = _userArray[indexPath.row];
        cell.topModel = tops;
        
        [cell.myStarRateView level:tops.number_win];
        
        NSString *userName = [NSString stringWithFormat:@"%@ %@",tops.firstname,tops.lastname];
        cell.userName.text = [NSString stringWithFormat:@"%ld.%@", (long) indexPath.row + 1, userName];
        
        NSString *wonLost = [NSString stringWithFormat:@"%d-%d",tops.number_win,tops.number_lost];
        cell.wonLost.text = wonLost;
        
    } else {

        cell.userName.text = filterData[indexPath.row];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"delete";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showHUD:@"deleting..." isDim:NO];
    UserInfo *tops = _userArray[indexPath.row];
    NSString *fid = tops.id;
    
    NSInteger userId = [LanbaooPrefs sharedInstance].userId.intValue;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"command" : @"rm_friend",
                                 @"uid" : @(userId),
                                 @"fid" : fid
                                 };
    [manager POST:kServerURL
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON:%@", responseObject);
              [_userArray removeObjectAtIndex:indexPath.row];
              [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
              [tableView reloadData];
              [self showHUdComplete:@"successful!"];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error:%@", error);
              [self showHUdCompleteWithTitle:@"check the network!"];
          }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
