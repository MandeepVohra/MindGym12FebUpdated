//
// Created by demo on 12/7/15.
// Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

//{
//    birthday = "03/20/1991";
//    "first_name" = Mg;
//    friends =     {
//            data =         (
//            );
//            summary =         {
//                "total_count" = 1;
//            };
//    };
//    id = 117873668582450;
//    "last_name" = Mg;
//    link = "https://www.facebook.com/app_scoped_user_id/117873668582450/";
//    name = "Mg Mg";
//    picture =     {
//            data =         {
//                    "is_silhouette" = 1;
//                    url = "https://scontent.xx.fbcdn.net/hprofile-xfa1/v/t1.0-1/s200x200/10354686_10150004552801856_220367501106153455_n.jpg?oh=3d28110b4889284a44dcf3b9a346d99d&oe=56E86650";
//            };
//    };
//}

@interface Data : NSObject

@property(nonatomic, strong) NSString *is_silhouette;
@property(nonatomic, strong) NSString *url;

@end

@interface Picture : NSObject
@property(nonatomic, strong) Data *data;
@end

@interface FacebookUser : NSObject

@property(nonatomic, strong) NSString *birthday;
@property(nonatomic, strong) NSString *first_name;
@property(nonatomic, strong) NSString *last_name;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) Picture *picture;

@end