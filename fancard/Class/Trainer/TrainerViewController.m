//
//  RightViewController.m
//  fancard
//
//  Created by MEETStudio on 15-8-27.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "TrainerViewController.h"
#import "Mconfig.h"
#import "DDMenuController.h"
#import "UIFactory.h"

@interface TrainerViewController () {
    UIImageView *imageView;
    UIImageView *upper;
    
    //top view
    UIView *_titleView;
    UILabel *_titleLabel;
    UIButton *_backButton;
}

@end

@implementation TrainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    _titleView.backgroundColor = [UIColor colorWithRed:162 / 255.0 green:0 blue:20 / 255.0 alpha:1.0f];
    [self.view addSubview:_titleView];
    _backButton = [UIFactory createButtonWithFrame:CGRectMake(5, 10, 44, 30)
                                            Target:self
                                          Selector:@selector(backToHome)
                                             Image:@"Btn_back"
                                      ImagePressed:@"Btn_back"];
    [_titleView addSubview:_backButton];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-50, 12, 100, 30)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont fontWithName:kAsapBoldFont size:20.0f];
    _titleLabel.text = @"Trainer";
    [_titleView addSubview:_titleLabel];

    imageView = [[UIImageView alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pic_bg_1" ofType:@"png"];
    imageView.image = [UIImage imageWithContentsOfFile:path];

    imageView.frame = CGRectMake(-2, 44, kScreenWidth + 2, kScreenHeight - 44);
    self.view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:imageView];
}

- (void)backToHome {
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowRootVCNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
