//
//  PTConnectionController.h
//  Projeta
//
//  Created by Michael Wermeester on 31/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWConnectionController : NSObject <NSURLConnectionDelegate> {
    NSMutableData* receivedData;
}

// executé 
@property (nonatomic, copy) void (^succeededAction)(NSMutableData *);
@property (nonatomic, copy) void (^failedAction)(NSError *);

// executé après succeededAction.
@property (nonatomic, copy) void (^postSuccessAction)(void);


- (id)initWithSuccessBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)(NSError *))failureBlock_;

- (BOOL)startRequestForURL:(NSURL*)url setRequest:(NSURLRequest *)request;

@end
