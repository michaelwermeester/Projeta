//
//  PTClientHelper.h
//  Projeta
//
//  Created by Michael Wermeester on 2/1/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Client.h"

@class Project;

@interface PTClientHelper : NSObject {
    NSArray *clients;
}

@property (nonatomic, copy) NSArray *clients;

+ (PTClientHelper *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary;


// Fetches clients for the given resource URL into an NSMutableArray and executes the successBlock upon success.
+ (void)serverClientsToArray:(NSString *)urlString successBlock:(void (^)(NSMutableArray*))successBlock failureBlock:(void(^)(NSError *))failureBlock;
// fetch all client names from web service.
+ (void)getClientNames:(void(^)(NSMutableArray *))successBlock failureBlock:(void(^)(NSError *))failureBlock;

+ (void)clientsVisibleForProject:(Project *)aProject successBlock:(void(^)(NSMutableArray *))successBlock failureBlock:(void(^)(NSError *))failureBlock;
+ (void)clientsVisibleForProjectId:(NSNumber *)aProjectId successBlock:(void(^)(NSMutableArray *))successBlock failureBlock:(void(^)(NSError *))failureBlock;

@end
