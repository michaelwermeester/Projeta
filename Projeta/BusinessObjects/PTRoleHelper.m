//
//  PTRoleHelper.m
//  Projeta
//
//  Created by Michael Wermeester on 20/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "PTRoleHelper.h"

#import "Role.h"
#import "MWConnectionController.h"
#import "PTCommon.h"
#import "User.h"

@implementation PTRoleHelper

@synthesize role = role;

+ (PTRoleHelper *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    PTRoleHelper *instance = [[PTRoleHelper alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    
    NSArray *receivedRole = [aDictionary objectForKey:@"role"];
    if ([receivedRole isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *parsedRole = [NSMutableArray arrayWithCapacity:[receivedRole count]];
        for (NSDictionary *item in receivedRole) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedRole addObject:[Role instanceFromDictionary:item]];
            }
        }
        
        self.role = parsedRole;
        
    }
}

+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary {
    
    if (!aDictionary) {
        return nil;
    }
    
    
    NSArray *receivedRoles = [aDictionary objectForKey:@"role"];
    if (receivedRoles) {
        
        NSMutableArray *parsedRoles = [NSMutableArray arrayWithCapacity:[receivedRoles count]];
        for (id item in receivedRoles) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedRoles addObject:[Role instanceFromDictionary:item]];
            }
        }
        
        //self.users = parsedUsers;
        return parsedRoles;
    }
    
    return nil;
}

#pragma mark Web service methods

// Fetches roles for the given resource URL into an NSMutableArray and executes the successBlock upon success.
+ (void)serverRolesToArray:(NSString *)urlString successBlock:(void (^)(NSMutableArray*))successBlock {
    
    // convert to NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableArray *roles= [[NSMutableArray alloc] init];
    
    // NSURLConnection - MWConnectionController
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {
                                                        NSError *error;
                                                        
                                                        NSDictionary *dict = [[NSDictionary alloc] init];
                                                        dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                                        
                                                        [roles addObjectsFromArray:[PTRoleHelper setAttributesFromJSONDictionary:dict]];
                                                        
                                                        successBlock(roles);
                                                    }
                                                    failureBlock:^(NSError *error) {
                                                        //[self rolesForUserRequestFailed:error];
                                                    }];
    
    //[connectionController setPostSuccessAction:^{
        //NSLog(@"postSuccessAction.");
    //}];
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [connectionController startRequestForURL:url setRequest:urlRequest];
}

+ (void)rolesAvailable:(void(^)(NSMutableArray *))successBlock {
    
    // Server URL.
    NSString *urlString = [PTCommon serverURLString];
    
    // Resource path from which the available resources are being fetched from. 
    urlString = [urlString stringByAppendingString:@"resources/roles/available"];
    
    // Fetch roles from server and exectute the successBlock.
    [self serverRolesToArray:urlString successBlock:successBlock];
}

//+ (NSMutableArray *)rolesForUser:(User *)aUser {
+ (void)rolesForUser:(User *)aUser successBlock:(void(^)(NSMutableArray *))successBlock {
    
    if (aUser.username)
        //return [self rolesForUserName:aUser.username successBlock:^{}];
        [self rolesForUserName:aUser.username successBlock:successBlock];
    //else
    //    return nil;
}

//+ (NSMutableArray *)rolesForUserName:(NSString *)aUsername {
+ (void)rolesForUserName:(NSString *)aUsername successBlock:(void(^)(NSMutableArray *))successBlock {
    
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    /*
     urlString = [urlString stringByAppendingString:@"resources/be.luckycode.projetawebservice.users/username/"];
     urlString = [urlString stringByAppendingString:[_loggedInUser username]];
     urlString = [urlString stringByAppendingString:@"/roles"];
     */
    urlString = [urlString stringByAppendingString:@"resources/roles?username="];
    urlString = [urlString stringByAppendingString:aUsername];
    
    [self serverRolesToArray:urlString successBlock:successBlock];
    
    /*// convert to NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableArray *userRoles = [[NSMutableArray alloc] init];
    
    // NSURLConnection - MWConnectionController
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {
                                                        NSError *error;
                                                        
                                                        NSDictionary *dict = [[NSDictionary alloc] init];
                                                        dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                                        
                                                        [userRoles addObjectsFromArray:[PTRoleHelper setAttributesFromJSONDictionary:dict]];
                                                        
                                                        successBlock_(userRoles);
                                                    }
                                                    failureBlock:^(NSError *error) {
                                                        //[self rolesForUserRequestFailed:error];
                                                    }];
    
    [connectionController setPostSuccessAction:^{
        //NSLog(@"postSuccessAction.");
    }];
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [connectionController startRequestForURL:url setRequest:urlRequest];*/
        
    // return userRoles;
}


/*+ (void)updateRolesForUser:(User *)aUser successBlock:(void(^)(NSMutableArray *))successBlock {
    
}*/

+ (BOOL)updateRolesForUser:(User *)aUser roles:(NSMutableDictionary *)roles {
    
    BOOL success;
    
    // create NSData from dictionary
    NSError* error;
    NSData *requestData = [[NSData alloc] init];
    requestData = [NSJSONSerialization dataWithJSONObject:roles options:0 error:&error];
    
    // get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    urlString = [urlString stringByAppendingString:@"resources/roles?userId="];
    urlString = [urlString stringByAppendingString:[aUser.userId stringValue]];
    
    // convert to NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {
                                                        
                                                    }
                                                    failureBlock:^(NSError *error) {
                                                        
                                                    }];
    
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString* requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [requestData length]];
    
    //[urlRequest setHTTPMethod:@"POST"]; // create
    [urlRequest setHTTPMethod:@"PUT"]; // update
    [urlRequest setHTTPBody:requestData];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:requestDataLengthString forHTTPHeaderField:@"Content-Length"];
    [urlRequest setTimeoutInterval:30.0];
    
    success = [connectionController startRequestForURL:url setRequest:urlRequest];
    
    return success;
}

@end
