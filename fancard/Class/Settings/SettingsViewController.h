//
//  SettingsViewController.h
//  fancard
//
//  Created by MEETStudio on 15-8-27.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingsViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate> {
    //top view
    UIView *_titleView;
    UIButton *_backButton;
    UILabel *_titleLabel;

    UITableView *_tableView;
    NSArray *_iconArray;
    UIImageView *_caption;

    float cellHeight;
    BOOL  _popAsLoginFlag;
}

@end
