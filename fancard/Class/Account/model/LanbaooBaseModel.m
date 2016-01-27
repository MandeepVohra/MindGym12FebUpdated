//
// Created by demo on 7/20/15.
// Copyright (c) 2015 lanbaoo. All rights reserved.
//

#import "LanbaooBaseModel.h"
#import "LKDBHelper.h"
#import "MConfig.h"


@implementation LanbaooBaseModel {

}
+ (LKDBHelper *)getUsingLKDBHelper {

    static LKDBHelper *db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dbpath = [docsdir stringByAppendingPathComponent:@"fancarddb"];
        LLog(@"dbpath = %@", dbpath);
        db = [[LKDBHelper alloc] initWithDBPath:dbpath];
    });
    return db;
}
@end