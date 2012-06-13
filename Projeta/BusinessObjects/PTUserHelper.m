//
//  PTUser.m
//  
//
//  Created by Michael Wermeester on 16/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import "MainWindowController.h"
#import "MWConnectionController.h"
#import "PTCommon.h"
#import "PTRoleHelper.h"
#import "PTUserHelper.h"
#import "User.h"

@implementation PTUserHelper

@synthesize users = users;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (PTUserHelper *)instanceFromDictionary:(NSDictionary *)aDictionary {

    PTUserHelper *instance = [[PTUserHelper alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
}



- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (!aDictionary) {
        return;
    }


    NSArray *receivedUsers = [aDictionary objectForKey:@"users"];
    if (receivedUsers) {

        NSMutableArray *parsedUsers = [NSMutableArray arrayWithCapacity:[receivedUsers count]];
        for (id item in receivedUsers) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedUsers addObject:[User instanceFromDictionary:item]];
            }
        }

        self.users = parsedUsers;

    }

}

+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary {
    
    if (!aDictionary) {
        return nil;
    }
    
    
    NSArray *receivedUsers = [aDictionary objectForKey:@"users"];
    if (receivedUsers) {
        
        NSMutableArray *parsedUsers = [NSMutableArray arrayWithCapacity:[receivedUsers count]];
        for (id item in receivedUsers) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedUsers addObject:[User instanceFromDictionary:item]];
            }
        }
        
        //self.users = parsedUsers;
        return parsedUsers;
    }
    
    return nil;
}


#pragma mark Web service methods

// creates a new user in database.
// mainWindowController parameter is used for animating the main window's progress indicator.
+ (BOOL)createUser:(User *)theUser successBlock:(void(^)(NSMutableData *))successBlock_ mainWindowController:(id)sender {
    
    BOOL success = NO;
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // start animating the main window's circular progress indicator.
        [sender startProgressIndicatorAnimation];
    }
    
    // create dictionary from User object
    NSDictionary *dict = [theUser dictionaryWithValuesForKeys:[theUser namesEmailKeysWithPassword]];

    // API resource string.
    NSString *resourceString = [[NSString alloc] initWithFormat:@"resources/users/create"];
    
    // execute the PUT method on the webservice to update the record in the database.
    success = [PTCommon executePOSTforDictionary:dict resourceString:resourceString successBlock:successBlock_];
    
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // stop animating the main window's circular progress indicator.
        [sender stopProgressIndicatorAnimation];
    }
    
    return success;
}


// updates username, first name and last name of a given user. 
// mainWindowController parameter is used for animating the main window's progress indicator.
+ (BOOL)updateUser:(User *)theUser mainWindowController:(id)sender
{
    BOOL success = NO;
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // start animating the main window's circular progress indicator.
        [sender startProgressIndicatorAnimation];
    }
    
    // create dictionary from User object
    NSDictionary *dict = [theUser dictionaryWithValuesForKeys:[theUser namesEmailKeys]];

    // API resource string.
    NSString *resourceString = [[NSString alloc] initWithFormat:@"resources/users/update"];
    
    // execute the PUT method on the webservice to update the record in the database.
    success = [PTCommon executePUTforDictionary:dict resourceString:resourceString];
    
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // stop animating the main window's circular progress indicator.
        [sender stopProgressIndicatorAnimation];
    }
    
    return success;
}

+ (void)userExists:(NSString *)aUsername successBlock:(void(^)(BOOL))successBlock failureBlock:(void(^)())failureBlock {
    
    // get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    urlString = [urlString stringByAppendingString:@"resources/users/exists/"];
    urlString = [urlString stringByAppendingString:aUsername];
    
    // convert to NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    // NSURLConnection - MWConnectionController
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {
                                                        
                                                        NSString* resStr = [[NSString alloc] initWithData:data
                                                                encoding:NSUTF8StringEncoding];
                                                        
                                                        if ([resStr isEqual:@"1"]) {
                                                            // user exists.
                                                            successBlock(YES);
                                                        } else {
                                                            successBlock(NO);
                                                        }
                                                        
                                                    }
                                                    failureBlock:^(NSError *error) {
                                                        
                                                        failureBlock();
                                                    }];
    
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    [connectionController startRequestForURL:url setRequest:urlRequest];
}

+ (void)updateUserPassword:(NSNumber *)theUserId password:(NSString *)thePassword successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)(NSError *))failureBlock_
{
    User *theUser = [[User alloc] init];
    
    theUser.userId = theUserId;
    theUser.password = thePassword;
    
    NSDictionary *dict = [theUser dictionaryWithValuesForKeys:[theUser userIdPasswordKeys]];
    
    // API resource string.
    NSString *resourceString = [[NSString alloc] initWithFormat:@"resources/users/setPassword"];
    
    // execute the PUT method on the webservice to update the record in the database.
    [PTCommon executePUTforDictionaryWithBlocks:dict resourceString:resourceString successBlock:successBlock_ failureBlock:failureBlock_];
    
}


+ (void)usersForUsergroup:(Usergroup *)aGroup successBlock:(void(^)(NSMutableArray *))successBlock failureBlock:(void(^)(NSError *))failureBlock {
    
    if (aGroup.usergroupId)
        //return [self rolesForUserName:aUser.username successBlock:^{}];
        [self usersForUsergroupId:aGroup.usergroupId successBlock:successBlock failureBlock:failureBlock];
}

+ (void)usersForUsergroupId:(NSNumber *)aGroupId successBlock:(void(^)(NSMutableArray *))successBlock failureBlock:(void(^)(NSError *))failureBlock {
    
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    urlString = [urlString stringByAppendingString:@"resources/users/usergroup/"];
    urlString = [urlString stringByAppendingString:[aGroupId stringValue]];
    
    [PTUserHelper serverUsersToArray:urlString successBlock:successBlock failureBlock:failureBlock];
}

+ (void)usersVisibleForProject:(Project *)aProject successBlock:(void(^)(NSMutableArray *))successBlock failureBlock:(void(^)(NSError *))failureBlock {
    
    if (aProject.projectId)
        //return [self rolesForUserName:aUser.username successBlock:^{}];
        [self usersVisibleForProjectId:aProject.projectId successBlock:successBlock failureBlock:failureBlock];
}

+ (void)usersVisibleForProjectId:(NSNumber *)aProjectId successBlock:(void(^)(NSMutableArray *))successBlock failureBlock:(void(^)(NSError *))failureBlock {
    
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    urlString = [urlString stringByAppendingString:@"resources/users/project/"];
    urlString = [urlString stringByAppendingString:[aProjectId stringValue]];
    
    [PTUserHelper serverUsersToArray:urlString successBlock:successBlock failureBlock:failureBlock];
}

// Fetches users for the given resource URL into an NSMutableArray and executes the successBlock upon success.
+ (void)serverUsersToArray:(NSString *)urlString successBlock:(void (^)(NSMutableArray*))successBlock failureBlock:(void(^)(NSError *))failureBlock {
    
    // convert to NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableArray *users= [[NSMutableArray alloc] init];
    
    // NSURLConnection - MWConnectionController
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {
                                                        NSError *error;
                                                        
                                                        NSDictionary *dict = [[NSDictionary alloc] init];
                                                        dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                                        
                                                        [users addObjectsFromArray:[PTUserHelper setAttributesFromJSONDictionary:dict]];
                                                        
                                                        successBlock(users);
                                                    }
                                                    failureBlock:^(NSError *error) {
                                                        //[self rolesForUserRequestFailed:error];
                                                    }];
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [connectionController startRequestForURL:url setRequest:urlRequest];
}

+ (void)allUsers:(void(^)(NSMutableArray *))successBlock failureBlock:(void(^)(NSError *))failureBlock {
    
    // get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    urlString = [urlString stringByAppendingString:@"resources/users/all"];
    
    [self serverUsersToArray:urlString successBlock:successBlock failureBlock:failureBlock];
}

+ (void)developers:(void(^)(NSMutableArray *))successBlock failureBlock:(void(^)(NSError *))failureBlock {
    
    // get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    urlString = [urlString stringByAppendingString:@"resources/users/developers"];
    
    [self serverUsersToArray:urlString successBlock:successBlock failureBlock:failureBlock];
}

@end
