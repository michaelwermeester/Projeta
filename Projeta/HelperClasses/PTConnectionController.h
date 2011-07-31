//
//  PTConnectionController.h
//  Projeta
//
//  Created by Michael Wermeester on 31/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTConnectionController : NSObject <NSURLConnectionDelegate> {
    NSMutableData* receivedData;
}

@property (nonatomic, strong) id connectionDelegate;
@property (nonatomic, copy) void (^succeededAction)(NSMutableData *);
@property (nonatomic, copy) void (^failedAction)(NSError *);

- (id)initWithDelegate:(id)delegate success:(void(^)(NSMutableData *))successBlock_ failure:(void(^)(NSError *))failureBlock_;

- (BOOL)startRequestForURL:(NSURL*)url setRequest:(NSURLRequest *)request;

@end
