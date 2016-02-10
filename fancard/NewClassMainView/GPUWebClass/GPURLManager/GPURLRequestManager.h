//
//  GPURLRequestManager.h
//  GP
//
//  Created by Gurpreet on 14/01/14.
//  Copyright (c) 2013 Gurpreet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPURLRequestManager : NSObject <NSURLConnectionDelegate>

@property (nonatomic,copy) void (^finishedBlock)(NSData *);
@property (nonatomic,copy) void (^failedBlock)(NSError *);
@property (nonatomic,retain) id target;
@property (nonatomic) SEL selector, failSelector;
@property (nonatomic,retain) NSMutableData *data;
@property (nonatomic,retain) NSURLRequest *request;

+ (void)downloadURL:(NSURLRequest *)urlRequest target:(id)target selector:(SEL)successSelector failSelector:(SEL)failSelector;
+ (void)downloadURL:(NSURLRequest *)urlRequest finished:(void (^)(NSData*))finished failed:(void (^)(NSError *))failure;

@end
