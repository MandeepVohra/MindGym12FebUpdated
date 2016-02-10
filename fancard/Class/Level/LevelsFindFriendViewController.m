//
// Created by vagrant on 12/16/15.
// Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <MJExtension/NSObject+MJKeyValue.h>
#import "LevelsFindFriendViewController.h"
#import "Mconfig.h"
#import "UIFactory.h"
#import "UserInfo.h"
#import "LanbaooPrefs.h"
#import "LeadersCell.h"
#import "CMOpenALSoundManager.h"
#import "CMOpenALSoundManager+Singleton.h"


@interface LevelsFindFriendViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate> {

    UIButton *_findFriend;

    NSMutableArray *_userArray;
    NSMutableArray *_searchArray;
    NSMutableArray *data;
    NSArray *filterData;
    UISearchDisplayController *searchDisplayController;

}
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation LevelsFindFriendViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (![LanbaooPrefs sharedInstance].musicOff) {
        [[CMOpenALSoundManager singleton] playBackgroundMusic:@"Mind-Gym-Main.mp3"];
    }

}

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

    [self _parseJson];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    [self searchUser:searchText];
}

#pragma mark search

- (void)searchUser:(NSString *)keyword {

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

            if ([dataDic[@"result"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *arrayDic = dataDic[@"result"];
                NSMutableArray *userArray = [UserInfo objectArrayWithKeyValuesArray:arrayDic];
                [_searchArray addObjectsFromArray:userArray];
            }
        }

        [self.tableView reloadData];
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

- (void)_parseJson {
    [self showHUD:@"Loading..." isDim:NO];
    NSString *command = @"rank_friend_total";
    NSInteger userId = [LanbaooPrefs sharedInstance].userId.intValue;

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
            @"command" : command,
            @"uid" : @(userId)
    };

    [manager GET:kServerURL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [self hideHUD];
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

             NSLog(@"---%lu", (unsigned long) _userArray.count);

//             for (TopHundredModel *tops in _userArray) {
//
//                 NSLog(@"name=%@",tops.username);
//             }
             data = [NSMutableArray array];

             for (int i = 0; i < _userArray.count; i++) {
                 UserInfo *tops = [[UserInfo alloc] init];
                 tops = _userArray[i];
                 NSString *userName = [NSString stringWithFormat:@"%@ %@", tops.firstname, tops.lastname];

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
        return _userArray ? _userArray.count : 0;

    } else {

        return _searchArray ? _searchArray.count : 0;

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"LeadersCell";
    LeadersCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[LeadersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    UserInfo *tops;

    if (tableView == self.tableView) {
        tops = _userArray[indexPath.row];

    } else {
        tops = _searchArray[indexPath.row];
    }

    cell.topModel = tops;

    [cell.myStarRateView level:tops.number_win];

    NSInteger num = tops.points_total;
    if (num >= 999) {
        long h = num % 1000;
        long k = num / 1000;
        cell.numPoints.text = [NSString stringWithFormat:@"%ld,%.3ld", k, h];
    } else {
        cell.numPoints.text = [NSString stringWithFormat:@"%d", tops.points_total];
    }

    NSString *userName = [NSString stringWithFormat:@"%@ %@", tops.firstname, tops.lastname];
    cell.userName.text = [NSString stringWithFormat:@"%ld.%@", (long) indexPath.row + 1, userName];

    NSString *wonLost = [NSString stringWithFormat:@"%d-%d", tops.number_win, tops.number_lost];
    cell.wonLost.text = wonLost;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"delete";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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

@end