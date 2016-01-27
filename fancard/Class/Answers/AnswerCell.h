//
//  AnswerCell.h
//  fancard
//
//  Created by MEETStudio on 15-9-6.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowseAnsModel.h"

@interface AnswerCell : UITableViewCell {
    UILabel *_line;
}

@property(nonatomic, strong) BrowseAnsModel *question;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *midBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UILabel *answer1;
@property (nonatomic, strong) UILabel *answer2;
@property (nonatomic, strong) UILabel *answer3;

@end
