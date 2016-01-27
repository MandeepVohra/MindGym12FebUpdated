//
//  MTextField.m
//  fancard
//
//  Created by MEETStudio on 15-10-27.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "MTextField.h"
#import <PureLayout/PureLayout.h>
#import "UIViewExt.h"
#import "Mconfig.h"

#define lineHeight (1.0f / [UIScreen mainScreen].scale)

@implementation MTextField

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){        
        _ball = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 55, 30)];
        _ball.contentMode = UIViewContentModeScaleAspectFit;
        _ball.image = [UIImage imageNamed:@"ball_signUp.png"];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.leftView = _ball;
        self.leftView.hidden = YES;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(48, self.height-lineHeight, self.width-96, lineHeight)];
    line.backgroundColor = [UIColor grayColor];
    [self addSubview:line];
    
}


@end
