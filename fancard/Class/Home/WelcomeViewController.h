//
//  WelcomeViewController.h
//  fancard
//
//  Created by MEETStudio on 15-10-29.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "BaseViewController.h"
#import "MainViewController.h"

@interface WelcomeViewController : BaseViewController<UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *joinButton;
-(void)CallNewServiceWithFirstname:(NSString *)firstname lastname:(NSString *)lastname FacebookId:(NSString *)token Command:(NSString *)commandNew PlatForm:(NSString *)plat;
@property (nonatomic, strong)  UIImageView *UserImage;
@end
