//
//  PTConnectionController.m
//  Projeta
//
//  Created by Michael Wermeester on 31/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import "PTConnectionController.h"

@implementation PTConnectionController

@synthesize connectionDelegate;
@synthesize succeededAction;
@synthesize failedAction;


- (id)initWithDelegate:(id)delegate success:(void(^)(NSMutableData *))successBlock_ failure:(void(^)(NSError *))failureBlock_ {
    
    if ((self = [super init])) {
        self.connectionDelegate = delegate;
    
        [self setSucceededAction:successBlock_];
        [self setFailedAction:failureBlock_];
    }
    
    return self;
}

- (BOOL)startRequestForURL:(NSURL*)url setRequest:(NSURLRequest *)request {
    
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
    //[connectionDelegate performSelector:failedAction withObject:error];
    //[connectionDelegate failedAction](error);
    
    [self failedAction](error);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //[connectionDelegate performSelector:succeededAction withObject:receivedData];
    //[connectionDelegate succeededAction](receivedData);
    //[connectionDelegate performBlock:[connectionDelegate succeededAction(receivedData)]];
    //[connectionDelegate performBlock:^{succeededAction(receivedData);}];
    //[connectionDelegate performSelector:@selector(invokeBlock:) withObject:receivedData];
    
    [self succeededAction](receivedData);
}
    
@end
