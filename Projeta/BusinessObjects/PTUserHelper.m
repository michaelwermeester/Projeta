//
//  PTUser.m
//  
//
//  Created by Michael Wermeester on 16/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import "MWConnectionController.h"
#import "PTCommon.h"
#import "PTRoleHelper.h"
#import "PTUserHelper.h"
#import "User.h"

static NSMutableArray *_currentUserRoles = nil;
static User *_loggedInUser = nil;

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

// returns the current logged-in user.
+ (User *)loggedInUser {
    
    if (!_loggedInUser) {
        PTUserHelper *usrHlpr = [[PTUserHelper alloc] init];
        [usrHlpr loadUserInfo];
    }
    
    return _loggedInUser;
}

+ (void)setLoggedInUser:(id)newValue {

    _loggedInUser = newValue;
}

+ (NSMutableArray *)currentUserRoles {
    return _currentUserRoles;
}

+ (void)setCurrentUserRoles:(NSMutableArray *)newRoles {
    _currentUserRoles = newRoles;
}

- (void)loadUserInfo {
    
    // get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    urlString = [urlString stringByAppendingString:@"resources/be.luckycode.projetawebservice.users/getLoggedInUser"];
    
    // convert to NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    // NSURLConnection - MWConnectionController
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {
                                                        //[self userRoleInitializationsRequestFinished:data];
                                                        
                                                        NSError *error;
                                                        
                                                        NSDictionary *dict = [[NSDictionary alloc] init];
                                                        dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                                        
                                                        NSMutableArray *loggedInUserArr = [[NSMutableArray alloc] init];
                                                        
                                                        // see Cocoa and Objective-C up and running by Scott Stevenson.
                                                        // page 242
                                                        [loggedInUserArr addObjectsFromArray:[PTUserHelper setAttributesFromDictionary2:dict]];
                                                        
                                                        if ([loggedInUserArr count] == 1) {
                                                            for (User *usr in loggedInUserArr) {
                                                                _loggedInUser = usr;
                                                                
                                                                [self loadUserRoles];
                                                            }
                                                        }
                                                    }
                                                    failureBlock:^(NSError *error) {
                                                        //[self userRoleInitializationsRequestFailed:error];
                                                    }];
    
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [connectionController startRequestForURL:url setRequest:urlRequest];
}

- (void)loadUserRoles {
    
    if (!_currentUserRoles)
        _currentUserRoles = [[NSMutableArray alloc] init];
    
    // get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    urlString = [urlString stringByAppendingString:@"resources/be.luckycode.projetawebservice.users/username/"];
    urlString = [urlString stringByAppendingString:[[PTUserHelper loggedInUser] username]];
    NSLog(@"user: %@", [[PTUserHelper loggedInUser] username]);
    urlString = [urlString stringByAppendingString:@"/roles"];
    //urlString = [urlString stringByAppendingString:@"admin/roles"];
    
    // convert to NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    // NSURLConnection - MWConnectionController
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {
                                                        [self userRoleInitializationsRequestFinished:data];
                                                    }
                                                    failureBlock:^(NSError *error) {
                                                        [self userRoleInitializationsRequestFailed:error];
                                                    }];
    
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [connectionController startRequestForURL:url setRequest:urlRequest];
}

- (void)userRoleInitializationsRequestFinished:(NSMutableData*)data {
    NSError *error;
    
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    [_currentUserRoles addObjectsFromArray:[PTRoleHelper setAttributesFromJSONDictionary:dict]];
    
    //[self showAdminMenu];
    
    // stop animating the main window's circular progress indicator.
    //[mainWindowController stopProgressIndicatorAnimation];
}

- (void)userRoleInitializationsRequestFailed:(NSError*)error {
    
    // stop animating the main window's circular progress indicator.
    //[mainWindowController stopProgressIndicatorAnimation];
}

@end
