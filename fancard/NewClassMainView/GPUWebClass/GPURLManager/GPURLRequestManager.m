//
//  GPURLRequestManager.m
//  GP
//
//  Created by Gurpreet on 14/01/14.
//  Copyright (c) 2013 Gurpreet. All rights reserved.
//

#import "GPURLRequestManager.h"

@implementation GPURLRequestManager

@synthesize target          =_target;
@synthesize selector        =_selector;
@synthesize data            =_data;
@synthesize failSelector    =_failSelector;
@synthesize finishedBlock   =_finishedBlock;
@synthesize failedBlock     =_failedBlock;
@synthesize request         =_request;

+ (void)downloadURL:(NSURLRequest *)urlRequest target:(id)target selector:(SEL)successSelector failSelector:(SEL)failSelector{
    GPURLRequestManager *_download  = [[GPURLRequestManager alloc] init];
    _download.target                = target;
    _download.selector              = successSelector;
    _download.request               = urlRequest;
    _download.failSelector          = failSelector;
    [_download startLoading];
    [_download autorelease];
}

+ (void)downloadURL:(NSURLRequest *)urlRequest finished:(void (^)(NSData*))finished failed:(void (^)(NSError *))failure{
    
    GPURLRequestManager *_download = [[GPURLRequestManager alloc] init];
    _download.finishedBlock        = finished;
    _download.failedBlock          = failure;
    _download.request              = urlRequest;
    [_download startLoading];
    [_download autorelease];
}
-(void)startLoading{
    NSURLConnection *_conn = [NSURLConnection connectionWithRequest:_request delegate:self];
    _data = [NSMutableData data];
    [_data retain];
    [_conn start];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)m_error {
   if (_failedBlock)
      _failedBlock(m_error);
   if (_target && _failedBlock)
      [_target performSelector:_failSelector withObject:m_error];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
   [_data setLength:0];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
   return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)dataR{
   [self.data appendData:dataR];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
	return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
		[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
   if (_finishedBlock)
      _finishedBlock(_data);
   if (_target && _selector)
      [_target performSelector:_selector withObject:_data];
}

- (void)dealloc {
   [_target release];
   [_data release];
   [super dealloc];
}

@end
