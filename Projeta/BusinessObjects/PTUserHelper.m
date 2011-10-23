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

+ (NSMutableArray *)setAttributesFromDictionary2:(NSDictionary *)aDictionary {
    
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

// + (void)updateUser:(User *)theUser
+ (BOOL)updateUser:(User *)theUser mainWindowController:(id)sender
{
    BOOL success = NO;
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // start animating the main window's circular progress indicator.
        [sender startProgressIndicatorAnimation];
    }
    
    // create dictionary from User object
    //NSDictionary *dict = [theUser dictionaryWithValuesForKeys:[theUser allKeys]];
    // update username, first name, last name and email address
    NSDictionary *dict = [theUser dictionaryWithValuesForKeys:[theUser namesEmailKeys]];
    
    // create NSData from dictionary
    NSError* error;
    NSData *requestData = [[NSData alloc] init];
    requestData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    
    // get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    //urlString = [urlString stringByAppendingString:@"resources/users"];
    urlString = [urlString stringByAppendingString:@"resources/users/update"];
    
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
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // start animating the main window's circular progress indicator.
        [sender stopProgressIndicatorAnimation];
    }
    
    return success;
}

@end
