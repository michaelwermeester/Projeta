//
//  PTClientHelper.m
//  Projeta
//
//  Created by Michael Wermeester on 2/1/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "MWConnectionController.h"
#import "PTClientHelper.h"
#import "PTCommon.h"

#import "Client.h"
#import "User.h"

@implementation PTClientHelper

@synthesize clients;

+ (PTClientHelper *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    PTClientHelper *instance = [[PTClientHelper alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    
    NSArray *receivedClients = [aDictionary objectForKey:@"clients"];
    if ([receivedClients isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *parsedClients = [NSMutableArray arrayWithCapacity:[receivedClients count]];
        for (NSDictionary *item in receivedClients) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedClients addObject:[Client instanceFromDictionary:item]];
            }
        }
        
        self.clients = parsedClients;
        
    }
}

+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary {
    
    if (!aDictionary) {
        return nil;
    }
    
    
    NSArray *receivedClients = [aDictionary objectForKey:@"clients"];
    if (receivedClients) {
        
        NSMutableArray *parsedClients = [NSMutableArray arrayWithCapacity:[receivedClients count]];
        for (id item in receivedClients) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedClients addObject:[Client instanceFromDictionary:item]];
            }
        }
        
        return parsedClients;
    }
    
    return nil;
}


// Fetches clients for the given resource URL into an NSMutableArray and executes the successBlock upon success.
+ (void)serverClientsToArray:(NSString *)urlString successBlock:(void (^)(NSMutableArray*))successBlock failureBlock:(void(^)(NSError *))failureBlock {
    
    // convert to NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableArray *clients= [[NSMutableArray alloc] init];
    
    // NSURLConnection - MWConnectionController
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {
                                                        NSError *error;
                                                        
                                                        NSDictionary *dict = [[NSDictionary alloc] init];
                                                        dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                                        
                                                        [clients addObjectsFromArray:[PTClientHelper setAttributesFromJSONDictionary:dict]];
                                                        
                                                        successBlock(clients);
                                                    }
                                                    failureBlock:^(NSError *error) {
                                                        //[self rolesForUserRequestFailed:error];
                                                    }];
    
    [connectionController setPostSuccessAction:^{
        //NSLog(@"postSuccessAction.");
    }];
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [connectionController startRequestForURL:url setRequest:urlRequest];
}

// fetch all client names from web service.
+ (void)getClientNames:(void(^)(NSMutableArray *))successBlock failureBlock:(void(^)(NSError *))failureBlock {
    
    // get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    urlString = [urlString stringByAppendingString:@"resources/clients/names"];
    
    [self serverClientsToArray:urlString successBlock:successBlock failureBlock:failureBlock];
}


@end
