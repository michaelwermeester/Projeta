//
//  ConnectionController.m
//  Projeta
//
//  Created by Michael Wermeester on 25/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import "ConnectionController.h"

@implementation ConnectionController

@synthesize connectionDelegate;
@synthesize succeededAction;
@synthesize failedAction;

- (id)initWithDelegate:(id)delegate selSucceeded:(SEL)succeeded selFailed:(SEL)failed {
    if ((self = [super init])) {
        self.connectionDelegate = delegate;
        self.succeededAction = succeeded;
        self.failedAction = failed;
    }
    return self;
}

- (BOOL)startRequestForURL:(NSURL*)url setRequest:(NSURLRequest *)request {
    //NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    // cache & policy stuff here
    //[[NSURLCache sharedURLCache] removeAllCachedResponses];
    //[urlRequest setHTTPMethod:@"POST"];
    //[urlRequest setHTTPShouldHandleCookies:YES];
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
    [connectionDelegate performSelector:failedAction withObject:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
     [connectionDelegate performSelector:succeededAction withObject:receivedData];
}

@end
