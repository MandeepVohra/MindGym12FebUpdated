//
//  GetChallenge.m
//  fancard
//
//  Created by MEETStudio on 15-10-15.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "GetChallenge.h"
#import "UIViewExt.h"
#import "Mconfig.h"
#import "UIImageView+WebCache.h"
#import "UserInfo.h"

@interface GetChallenge () {
    NSArray *array;
}
@end

@implementation GetChallenge

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 2;
        self.layer.borderColor = [[UIColor colorWithWhite:1 alpha:0.6] CGColor];

        [self _initTableView];
    }
    return self;
}

- (void)_initTableView {
    _chaNumView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width - 10, 50)];
    _chaNumLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width - 10, 50)];
    _chaNumLb.backgroundColor = [UIColor redColor];

    _chaNumLb.textColor = [UIColor yellowColor];
    _chaNumLb.textAlignment = NSTextAlignmentCenter;
    _chaNumLb.font = [UIFont boldSystemFontOfSize:25.0f];
    [_chaNumView addSubview:_chaNumLb];

    _chaMessage = [[UITableView alloc] initWithFrame:CGRectMake(7, 7, self.width - 14, self.height - 9) style:UITableViewStylePlain];
    _chaMessage.delegate = self;
    _chaMessage.dataSource = self;
    _chaMessage.backgroundColor = [UIColor clearColor];
    [self addSubview:_chaMessage];
    _chaMessage.separatorStyle = UITableViewCellSeparatorStyleNone;
    _chaMessage.tableHeaderView = _chaNumView;
    
    
    
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return array ? array.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
//    Challenger *ch = array[indexPath.row];
    UserInfo *userInfo = array[indexPath.row];
    cell.acDelegate = self;
    cell.oppUserName.text = [NSString stringWithFormat:@"%@ %@", userInfo.firstname, userInfo.lastname];
    cell.challenger = userInfo;
    //[cell.oppUserPhoto sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar]];
    
    [cell.oppUserPhoto sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:[UIImage imageNamed:@"ImagePlaceholder"]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}

- (void)setInfo:(NSArray *)challengers {
    array = challengers;
    NSString *challengeHint = [NSString stringWithFormat:@"%ld NEW CHALLENGES!", (unsigned long) (array ? array.count : 0)];
    _chaNumLb.text = challengeHint;
    [_chaMessage reloadData];
}

#pragma mark - acceptDelegate

- (void)acceptChallenge:(UserInfo *)userInfo {
    if (_reDelegate && [_reDelegate respondsToSelector:@selector(responseChallenge:)]) {
        [_reDelegate responseChallenge:userInfo];
    }
}

@end

#pragma mark -
#pragma mark - cell method

@implementation Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _initView];
    }
    return self;
}

- (void)_initView {
    _cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth - 20, 46)];
    _cellView.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:_cellView];
    _oppUserPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 34, 34)];
    _oppUserPhoto.contentMode = UIViewContentModeScaleAspectFit;
    _oppUserPhoto.backgroundColor = [UIColor clearColor];
    [_cellView addSubview:_oppUserPhoto];

    _oppUserName = [[UILabel alloc] initWithFrame:CGRectMake(_oppUserPhoto.right + 10, 5, 160, 34)];
    _oppUserName.backgroundColor = [UIColor clearColor];
    _oppUserName.font = [UIFont boldSystemFontOfSize:20.0f];
    [_oppUserName setText:@"FIRSTNAME LASTNAME"];
    _oppUserName.adjustsFontSizeToFitWidth = YES;
    [_oppUserName setTextAlignment:NSTextAlignmentLeft];
    [_oppUserName setTextColor:[UIColor whiteColor]];
    [_cellView addSubview:_oppUserName];

    _accept = [[UIButton alloc] initWithFrame:CGRectMake(_cellView.width - 80, 5, 80, 34)];
    _accept.backgroundColor = [UIColor colorWithRed:238 / 255.0f green:191 / 255.0f blue:22 / 255.0f alpha:1.0f];
    [_accept setTitle:@"Accept" forState:UIControlStateNormal];
    _accept.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_accept setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_accept addTarget:self action:@selector(vsMyFriend) forControlEvents:UIControlEventTouchUpInside];

    [_cellView addSubview:_accept];

    _whiteLine = [[UILabel alloc] initWithFrame:CGRectMake(0, _cellView.height - 2, _cellView.width, 2)];
    _whiteLine.backgroundColor = [UIColor whiteColor];
    [_cellView addSubview:_whiteLine];

}

//accept
- (void)vsMyFriend {
    if (_acDelegate && [_acDelegate respondsToSelector:@selector(acceptChallenge:)]) {
        [_acDelegate acceptChallenge:_challenger];
    }
}

@end
