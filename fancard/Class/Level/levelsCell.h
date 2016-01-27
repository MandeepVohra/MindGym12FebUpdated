//
//  levelsCell.h
//  fancard
//
//  Created by MEETStudio on 15-9-10.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"
#import "CWStarRateView+Level.h"

@interface levelsCell : UITableViewCell {
    UILabel *_line;   

    UIImageView *_bluePoint1;
    UIImageView *_bluePoint2;
}
@property(nonatomic, strong) UIImageView *locks;
@property(nonatomic, strong) CWStarRateView *myStarRateView;

@property(nonatomic, strong) UIView *leftView;
@property(nonatomic, strong) UIView *rightView;

@property(nonatomic, strong) UILabel *labelWinNum;
@property(nonatomic, strong) UILabel *labelWins;
@property(nonatomic, strong) UILabel *levelName;
@property(nonatomic, strong) UILabel *privilege1;
@property(nonatomic, strong) UILabel *privilege2;

@end
