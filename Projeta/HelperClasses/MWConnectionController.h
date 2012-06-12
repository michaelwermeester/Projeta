//
//  PTConnectionController.h
//  Projeta
//
//  Created by Michael Wermeester on 31/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWConnectionController : NSObject <NSURLConnectionDelegate> {
    // données reçues.
    NSMutableData* receivedData;
}

// blocks qui sont executés lors du succés ou échec d'une NSURLConnection.
@property (nonatomic, copy) void (^succeededAction)(NSMutableData *);
@property (nonatomic, copy) void (^failedAction)(NSError *);

// méthode d'initialisation. Permet de définir les blocks a exécuter. 
- (id)initWithSuccessBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)(NSError *))failureBlock_;

// lancer une requête HTTP pour une URL spécifié.
- (BOOL)startRequestForURL:(NSURL*)url setRequest:(NSURLRequest *)request;

@end