//
//  NFTrivaBarView.h
//  fancard
//
//  Created by MEETStudio on 15-8-28.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFTrivaBarView : UIView {

    UIImageView *_computerImage;
    UIImageView *_userImage;
    UIImageView *_timeImage;

    UIView *_belowView;
}

@property(strong, nonatomic) UIImageView *questionImage;

@property(strong, nonatomic) UILabel *questionLabel;
@property(strong, nonatomic) UILabel *pauseLabel;   //End of 1st|2ed|3rd|4th Quarter

@property(strong, nonatomic) UILabel *roundTime;     //Each bout time remaining, initially 24s
@property(strong, nonatomic) UILabel *timeQua;       //Each section of the remaining time, each section 1min

@property(strong, nonatomic) UIView  *quaView;
@property(strong, nonatomic) UIImageView *image1;
@property(strong, nonatomic) UIImageView *image2;
@property(strong, nonatomic) UIImageView *image3;
@property(strong, nonatomic) UIImageView *image4;
@property(strong, nonatomic) UILabel *time5;         //Last 5 second of Quarter

@property(strong, nonatomic) UIImageView *userPhoto;
@property(strong, nonatomic) UIImageView *opponentPhoto;

@property(strong, nonatomic) UILabel *userPoints;
@property(strong, nonatomic) UILabel *botPoints;

@property(strong, nonatomic) UILabel *resultLabel;   //@"GREAT SHOT!"……

@property(strong, nonatomic) UILabel *computerAdd;
@property(strong, nonatomic) UILabel *userAdd;

@end
