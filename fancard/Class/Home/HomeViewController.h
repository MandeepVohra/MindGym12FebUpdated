//
//  HomeViewController.h
//  fancard
//
//  Created by MEETStudio on 15-8-27.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "BaseViewController.h"
#import "GetChallenge.h"
#import "SRWebSocket.h"

@interface HomeViewController : BaseViewController <ResponseDelegate,
        UIActionSheetDelegate,
        UIImagePickerControllerDelegate,
        UIPickerViewDelegate,
        UINavigationControllerDelegate>

@property (nonatomic, assign) NSInteger fid;

@end
