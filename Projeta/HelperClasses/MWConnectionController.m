//
//  PTConnectionController.m
//  Projeta
//
//  Created by Michael Wermeester on 31/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import "MWConnectionController.h"

@implementation MWConnectionController

@synthesize succeededAction;
@synthesize failedAction;


- (id)initWithSuccessBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)(NSError *))failureBlock_ {
    
    if ((self = [super init])) {
    
        [self setSucceededAction:successBlock_];
        [self setFailedAction:failureBlock_];
    }
    
    return self;
}

- (BOOL)startRequestForURL:(NSURL*)url setRequest:(NSMutableURLRequest *)request {
    
    //NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    // cache & policy stuff here
    //[[NSURLCache sharedURLCache] removeAllCachedResponses];
    //[urlRequest setHTTPMethod:@"POST"];
    //[urlRequest setHTTPShouldHandleCookies:YES];
    
    // enable gzip compression
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    // set http-header User-Agent.
	[request setValue:@"Projeta" forHTTPHeaderField:@"User-Agent"];
    
    NSURLConnection* __autoreleasing connectionResponse = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (!connectionResponse)
    {
        // handle error
        return NO;
    } else {
        receivedData = [NSMutableData data];
    }
    
    return YES;
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response {
    [receivedData setLength:0];
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self failedAction](error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // for easier debugging
    NSString* newStr = [[NSString alloc] initWithData:receivedData
                                             encoding:NSUTF8StringEncoding];
    
    NSLog(@"JSON result: %@", newStr);
    // end debug
    
    [self succeededAction](receivedData);
}
    
@end
