//
//  AnswerCell.m
//  fancard
//
//  Created by MEETStudio on 15-9-6.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "AnswerCell.h"
#import "Mconfig.h"
#import "UIViewExt.h"
#import "UIView+FrameCategory.h"
#import "UILabel+DynamicFontSize.h"

@implementation AnswerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _initView];
    }
    return self;
}

- (void)_initView {
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(1, 1.5, kScreenWidth-2, 177)];
    background.backgroundColor = [UIColor clearColor];
    [background.layer setBorderWidth:1.0f];
    [background.layer setBorderColor:[[UIColor colorWithWhite:1 alpha:0.6f] CGColor]];
    [self.contentView addSubview:background];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-4, 30)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont fontWithName:kAsapBoldFont size:16.0f];
    [background addSubview:_titleLabel];
    
    _line = [[UILabel alloc] initWithFrame:CGRectMake(20, 28.5, kScreenWidth-44, 1.5)];
    _line.backgroundColor = [UIColor whiteColor];
    [background addSubview:_line];
    
    _questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, kScreenWidth-44, 40)];
    _questionLabel.backgroundColor = [UIColor clearColor];
    _questionLabel.textAlignment = NSTextAlignmentCenter;
    _questionLabel.adjustsFontSizeToFitWidth = YES;
    _questionLabel.numberOfLines = 2;
    [_questionLabel setText:@"Display Question 1 here in up to two lines of text,etc,etc,etc? User can scroll down to see all answers for that quarter,Swipe"];
    _questionLabel.font = [UIFont fontWithName:kAsapRegularFont size:20.0f];
    _questionLabel.textColor = [UIColor whiteColor];
    [background addSubview:_questionLabel];
    
    CGSize imageSize = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pic_ball_Leader" ofType:@"png"]].size;
    float myWidth = 130*imageSize.width/imageSize.height;
    
    _leftBtn = [[UIButton alloc] init];
    _leftBtn.frame = CGRectMake((kScreenWidth/2-myWidth/2)-100, 55, myWidth, 130);
    _leftBtn.centerX = kScreenWidth / 6.0f;
    [_leftBtn setImage:[UIImage imageNamed:@"pic_ball_Ans.png"]forState:UIControlStateNormal];
    [_leftBtn setImage:[UIImage imageNamed:@"pic_ball_Leader.png"] forState:UIControlStateSelected];
    [background addSubview:_leftBtn];
    
    
    _midBtn = [[UIButton alloc] init];
    _midBtn.frame = CGRectMake((kScreenWidth/2-myWidth/2), 60, myWidth, 130);
    _midBtn.centerX = kScreenWidth / 2.0f;
    [_midBtn setImage:[UIImage imageNamed:@"pic_ball_Ans.png"] forState:UIControlStateNormal];
    [_midBtn setImage:[UIImage imageNamed:@"pic_ball_Leader.png"] forState:UIControlStateSelected];
    [background addSubview:_midBtn];
    
    _rightBtn = [[UIButton alloc] init];
    _rightBtn.frame = CGRectMake((kScreenWidth/2-myWidth/2)+100, 55, myWidth, 130);
    _rightBtn.centerX = kScreenWidth * 5 / 6.0f;
    [_rightBtn setImage:[UIImage imageNamed:@"pic_ball_Ans.png"] forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageNamed:@"pic_ball_Leader.png"] forState:UIControlStateSelected];
    [background addSubview:_rightBtn];
    
    _answer1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 70)];
    _answer1.backgroundColor = [UIColor clearColor];
    _answer1.text = @"Wrong";
    _answer1.centerX = kScreenWidth / 6.0f;
    _answer1.centerY =  120.0f;
    _answer1.font = [UIFont fontWithName:kAsapBoldFont size:40.0f];
    _answer1.numberOfLines = 0;
    _answer1.textAlignment = NSTextAlignmentCenter;
    _answer1.adjustsFontSizeToFitWidth = YES;
    [_answer1 setTextColor:[UIColor colorWithRed:241.0 / 255.0 green:240.0 / 255.0 blue:241.0 / 255.0 alpha:1.0f]];
    _answer1.transform = CGAffineTransformMakeRotation(-M_PI / 180 * 20);
    [_answer1 setTextAlignment:NSTextAlignmentCenter];
    [background addSubview:_answer1];
    
    _answer2 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-40, 0, 80, 70)];
    _answer2.backgroundColor = [UIColor clearColor];
    _answer2.text = @"Wrong";
    _answer2.centerX = kScreenWidth / 2.0f;
    _answer2.centerY =  125.0f;
    _answer2.font = [UIFont fontWithName:kAsapBoldFont size:40.0f];
    _answer2.numberOfLines = 0;
    _answer2.textAlignment = NSTextAlignmentCenter;
    _answer2.adjustsFontSizeToFitWidth = YES;
    [_answer2 setTextColor:[UIColor colorWithRed:241.0 / 255.0 green:240.0 / 255.0 blue:241.0 / 255.0 alpha:1.0f]];
    _answer2.transform = CGAffineTransformMakeRotation(-M_PI / 180 * 20);
    [_answer2 setTextAlignment:NSTextAlignmentCenter];
    [background addSubview:_answer2];
   
    _answer3 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-20-80, 0, 80, 70)];
    _answer3.backgroundColor = [UIColor clearColor];
    _answer3.text = @"Wrong";
    _answer3.centerX = kScreenWidth * 5 / 6.0f;
    _answer3.centerY =  120.0f;
    _answer3.font = [UIFont fontWithName:kAsapBoldFont size:40.0f];
    _answer3.numberOfLines = 0;
    _answer3.textAlignment = NSTextAlignmentCenter;
    _answer3.adjustsFontSizeToFitWidth = YES;
    [_answer3 setTextColor:[UIColor colorWithRed:241.0 / 255.0 green:240.0 / 255.0 blue:241.0 / 255.0 alpha:1.0f]];
    _answer3.transform = CGAffineTransformMakeRotation(-M_PI / 180 * 20);
    [_answer2 setTextAlignment:NSTextAlignmentCenter];
    [background addSubview:_answer3];
    
    
}

- (void)layoutSubviews {
    _questionLabel.text = _question.question;
    NSArray *answers = [_question answers];
    [_answer1 adjustFontSizeWithText:answers[0] constrainedToSize:(CGSize){80,70}];
    [_answer2 adjustFontSizeWithText:answers[1] constrainedToSize:(CGSize){80,70}];
    [_answer3 adjustFontSizeWithText:answers[2] constrainedToSize:(CGSize){80,70}];
    
    [self changeAnswerbackgroundImage];
}

- (void)changeAnswerbackgroundImage
{
    if ([_answer1.text isEqualToString:_question.rightAns]) {
        _leftBtn.selected = YES;
        _midBtn.selected = NO;
        _rightBtn.selected = NO;
    }else if ([_answer2.text isEqualToString:_question.rightAns]) {
        _leftBtn.selected = NO;
        _midBtn.selected = YES;
        _rightBtn.selected = NO;
    }else if ([_answer3.text isEqualToString:_question.rightAns]) {
        _leftBtn.selected = NO;
        _midBtn.selected = NO;
        _rightBtn.selected = YES;
    }   
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
