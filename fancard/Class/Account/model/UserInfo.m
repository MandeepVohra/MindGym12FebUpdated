//
// Created by demo on 12/10/15.
// Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "UserInfo.h"


@implementation UserInfo {

}

- (NSString *)firstname {
    if (_firstname.length == 0) {
        return @"";
    } else {
        return _firstname;
    }
}

- (NSString *)lastname {
    if (_lastname.length == 0) {
        return @"";
    } else {
        return _lastname;
    }
}

- (NSString *)avatar {
    if (_avatar.length == 0) {
        return @"";
    } else {
        return _avatar;
    }
}

+ (NSString *)getPrimaryKey {
    return @"id";
}

+ (NSString *)getTableName {
    return @"userinfo";
}

@end