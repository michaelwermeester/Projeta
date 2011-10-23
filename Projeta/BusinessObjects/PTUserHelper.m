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

// creates a new user in database.
// mainWindowController parameter is used for animating the main window's progress indicator.
+ (BOOL)createUser:(User *)theUser successBlock:(void(^)(NSMutableData *))successBlock_ mainWindowController:(id)sender {
    
    BOOL success = NO;
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // start animating the main window's circular progress indicator.
        [sender startProgressIndicatorAnimation];
    }
    
    // create dictionary from User object
    //NSDictionary *dict = [theUser dictionaryWithValuesForKeys:[theUser allKeys]];
    // update username, first name, last name and email address
    NSDictionary *dict = [theUser dictionaryWithValuesForKeys:[theUser namesEmailKeysWithPassword]];

    // API resource string.
    NSString *resourceString = [[NSString alloc] initWithFormat:@"resources/users/create"];
    
    // execute the PUT method on the webservice to update the record in the database.
    success = [PTCommon executePOSTforDictionary:dict resourceString:resourceString successBlock:successBlock_];
    
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // start animating the main window's circular progress indicator.
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
    //NSDictionary *dict = [theUser dictionaryWithValuesForKeys:[theUser allKeys]];
    // update username, first name, last name and email address
    NSDictionary *dict = [theUser dictionaryWithValuesForKeys:[theUser namesEmailKeys]];

    // API resource string.
    NSString *resourceString = [[NSString alloc] initWithFormat:@"resources/users/update"];
    
    // execute the PUT method on the webservice to update the record in the database.
    success = [PTCommon executePUTforDictionary:dict resourceString:resourceString];
    
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // start animating the main window's circular progress indicator.
        [sender stopProgressIndicatorAnimation];
    }
    
    return success;
}

@end
