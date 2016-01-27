//
//  MySocket.h
//  fancard
//
//  Created by MEETStudio on 15-11-12.
//  Copyright (c) 2015 MEETStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

@interface MySocket : NSObject<SRWebSocketDelegate>

@property(nonatomic, strong) SRWebSocket *sRWebSocket;

+ (instancetype)singleton;

-(void)initWebSocket;
//-(void)registerToWebSocket;

@end
