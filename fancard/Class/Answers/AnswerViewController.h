//
//  LeftViewController.h
//  fancard
//
//  Created by MEETStudio on 15-8-27.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "PagedFlowView.h"
#import "BaseViewController.h"

@class BaseViewController;

@interface AnswerViewController : BaseViewController <PagedFlowViewDelegate, PagedFlowViewDataSource>

@end
