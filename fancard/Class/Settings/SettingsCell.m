//
//  SettingsCell.m
//  fancard
//  
//  Created by MEETStudio on 15-9-10.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "SettingsCell.h"
#import "Mconfig.h"
#import <PureLayout/PureLayout.h>

@implementation SettingsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _initView];
    }
    return self;
}

- (void)_initView {
    NSInteger sectionHeight = (kScreenHeight - (44 + 80 + 20)) / 8;
    _iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconView];
    [_iconView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:12.0f];
    [_iconView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12.0f];
    [_iconView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:12.0f];
    [_iconView autoSetDimension:ALDimensionWidth toSize:(sectionHeight-24.0f)];
 
//    _funcListLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.right+1, 0, 150, sectionHeight)];
    _funcListLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_funcListLabel];
    _funcListLabel.text = @"woceyixia";
    _funcListLabel.font = [UIFont fontWithName:kAsapBoldFont size:20.0f];
    _funcListLabel.textColor = [UIColor colorWithRed:68 / 255.0 green:68 / 255.0 blue:68 / 255.0 alpha:1.0f];
    [_funcListLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconView withOffset:11.0f];
    [_funcListLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_funcListLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_funcListLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:100.0f];


}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
