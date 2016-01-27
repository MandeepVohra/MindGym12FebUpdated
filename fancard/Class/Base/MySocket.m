//
//  MySocket.m
//  fancard
//
//  Created by MEETStudio on 15-11-12.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import "MySocket.h"
#import "Mconfig.h"
#import "PushBean.h"
#import "NSDate+FormatDateString.h"
#import "NSString+StringFormatDate.h"
#import "LanbaooPrefs.h"
#import <MJExtension/MJExtension.h>

@implementation MySocket

static MySocket *mySocket = nil;

+ (instancetype)singleton {

    if (!mySocket) {
        mySocket = [[MySocket alloc] init];
    }
    return mySocket;
}

- (void)initWebSocket {
    _sRWebSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kSocketURL]]];
    _sRWebSocket.delegate = self;
    [_sRWebSocket open];
}


- (void)registerToWebSocket {
    NSString *userId = [LanbaooPrefs sharedInstance].userId;
    if (userId.length > 0) {
        if (_sRWebSocket.readyState == SR_OPEN) {
            PushBean *pushBean = [[PushBean alloc] init];
            pushBean.uid = userId;
            pushBean.pushTime = [[NSDate new] getDateStrWithFormat:kDateFormat];
            [_sRWebSocket send:pushBean.JSONString];
        }
    }
}


- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

//Receive socket message
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSocketNotification object:message];
    PushBean *pushBean = [PushBean objectWithKeyValues:message];
    if (pushBean) {
        NSString *action = pushBean.action;
        if (action.length > 0 && [action isEqualToString:@"trueTime"]) {
            NSString *serverTime = pushBean.pushTime;
            NSDate *date = [serverTime getDateWithFormat:kDateFormat];
            NSDate *date2 = [NSDate date];
            NSTimeInterval gapTime = [date timeIntervalSinceDate:date2];
            NSLog(@"gapTime:%f", gapTime);
            [LanbaooPrefs sharedInstance].gapTime = gapTime;
        }
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSString *userId = [LanbaooPrefs sharedInstance].userId;
    if (userId.length > 0) {
        NSLog(@"webSocketDidOpen");
        PushBean *pushBean = [[PushBean alloc] init];
        pushBean.uid = userId;
        pushBean.pushTime = [[NSDate new] getDateStrWithFormat:kDateFormat];
        [webSocket send:pushBean.JSONString];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"webSocket error = %@", error);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"webSocket close reason = %@", reason);
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSLog(@"didReceivePong");
}

@end
