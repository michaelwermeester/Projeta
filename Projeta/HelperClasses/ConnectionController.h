//
//  ConnectionController.h
//  Projeta
//
//  Created by Michael Wermeester on 25/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionController : NSObject <NSURLConnectionDelegate> {
    NSMutableData* receivedData;
}

@property (nonatomic, strong) id connectionDelegate;
@property (nonatomic) SEL succeededAction;
@property (nonatomic) SEL failedAction;

- (id)initWithDelegate:(id)delegate selSucceeded:(SEL)succeeded selFailed:(SEL)failed;
- (BOOL)startRequestForURL:(NSURL*)url;

@end
