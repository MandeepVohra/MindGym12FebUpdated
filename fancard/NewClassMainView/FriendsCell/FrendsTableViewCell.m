//
//  FrendsTableViewCell.m
//  fancard
//
//  Created by Mandeep on 28/01/16.
//  Copyright © 2016 MEETStudio. All rights reserved.
//

#import "FrendsTableViewCell.h"

@implementation FrendsTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.ProfilePic.layer.cornerRadius = self.ProfilePic.frame.size.width/2;
    self.ProfilePic.clipsToBounds = YES;
    self.LabelCount.layer.cornerRadius = 11;
    self.LabelCount.clipsToBounds = YES;
    [self.LabelCount setBackgroundColor:[UIColor redColor]];
    [self.LabelCount setTextAlignment:NSTextAlignmentCenter];
    [self.LabelCount setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10.0]];
    [self.LabelCount setTextColor:[UIColor whiteColor]];
    [[self.LabelCount layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[self.LabelCount layer] setBorderWidth:1.0];
    self.ChallengeButton.layer.cornerRadius = 15;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
