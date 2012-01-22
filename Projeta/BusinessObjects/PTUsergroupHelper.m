//
//  PTUserGroupHelper.m
//  Projeta
//
//  Created by Michael Wermeester on 31/10/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "MWConnectionController.h"
#import "PTCommon.h"
#import "PTUsergroupHelper.h"
#import "User.h"
#import "Usergroup.h"

@implementation PTUsergroupHelper

@synthesize usergroup = usergroup;

+ (PTUsergroupHelper *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    PTUsergroupHelper *instance = [[PTUsergroupHelper alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    
    NSArray *receivedUsergroup = [aDictionary objectForKey:@"usergroup"];
    if ([receivedUsergroup isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *parsedUsergroup = [NSMutableArray arrayWithCapacity:[receivedUsergroup count]];
        for (NSDictionary *item in receivedUsergroup) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedUsergroup addObject:[Usergroup instanceFromDictionary:item]];
            }
        }
        
        self.usergroup = parsedUsergroup;
        
    }
    
    
}

+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary {
    
    if (!aDictionary) {
        return nil;
    }
    
    
    NSArray *receivedUsergroups = [aDictionary objectForKey:@"usergroup"];
    if (receivedUsergroups) {
        
        NSMutableArray *parsedUsergroups = [NSMutableArray arrayWithCapacity:[receivedUsergroups count]];
        for (id item in receivedUsergroups) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedUsergroups addObject:[Usergroup instanceFromDictionary:item]];
            }
        }
        
        return parsedUsergroups;
    }
    
    return nil;
}


#pragma mark Web service methods

// Fetches roles for the given resource URL into an NSMutableArray and executes the successBlock upon success.
+ (void)serverUsergroupsToArray:(NSString *)urlString successBlock:(void (^)(NSMutableArray*))successBlock {
    
    // convert to NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableArray *usergroups= [[NSMutableArray alloc] init];
    
    // NSURLConnection - MWConnectionController
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {
                                                        NSError *error;
                                                        
                                                        NSDictionary *dict = [[NSDictionary alloc] init];
                                                        dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                                        
                                                        [usergroups addObjectsFromArray:[PTUsergroupHelper setAttributesFromJSONDictionary:dict]];
                                                        
                                                        successBlock(usergroups);
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

+ (void)usergroupsAvailable:(void(^)(NSMutableArray *))successBlock {
    
    // Server URL.
    NSString *urlString = [PTCommon serverURLString];
    
    // Resource path from which the available resources are being fetched from. 
    urlString = [urlString stringByAppendingString:@"resources/usergroups/all"];
    
    // Fetch roles from server and exectute the successBlock.
    [self serverUsergroupsToArray:urlString successBlock:successBlock];
}

+ (void)usergroupsForUser:(User *)aUser successBlock:(void(^)(NSMutableArray *))successBlock {
    
    if (aUser.username)
        //return [self rolesForUserName:aUser.username successBlock:^{}];
        [self usergroupsForUserName:aUser.username successBlock:successBlock];
    //else
    //    return nil;
}

+ (void)usergroupsForUserName:(NSString *)aUsername successBlock:(void(^)(NSMutableArray *))successBlock {
    
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    urlString = [urlString stringByAppendingString:@"resources/usergroups?username="];
    urlString = [urlString stringByAppendingString:aUsername];
    
    [self serverUsergroupsToArray:urlString successBlock:successBlock];
}

+ (BOOL)updateUsergroupsForUser:(User *)aUser usergroups:(NSMutableDictionary *)usergroups successBlock:(void(^)(NSMutableData *))successBlock failureBlock:(void(^)(NSError *))failureBlock {
    
    BOOL success;
    
    // build URL by adding resource path
    NSString *resourceString = [[NSString alloc] initWithFormat:@"resources/usergroups?userId="];
    resourceString = [resourceString stringByAppendingString:[aUser.userId stringValue]];
    
    
    // execute the PUT method on the webservice to update the record in the database.
    [PTCommon executePUTforDictionaryWithBlocks:usergroups resourceString:resourceString successBlock:successBlock failureBlock:failureBlock];
    
    return success;
}


@end
