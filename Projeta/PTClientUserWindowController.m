//
//  PTClientUserWindowController.m
//  Projeta
//
//  Created by Michael Wermeester on 1/22/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "PTClientUserWindowController.h"
#import "User.h"
#import "Usergroup.h"
#import "PTUsergroupHelper.h"

@implementation PTClientUserWindowController

@synthesize availableUsers;
@synthesize mainWindowController;
@synthesize parentClientManagementViewCtrl;
@synthesize usergroup;
@synthesize groupUsersArrayCtrl;
@synthesize availableUsersArrayCtrl;
@synthesize updatingUsergroupsLabel;
@synthesize progressIndicator;

- (id)init
{
    self = [super initWithWindowNibName:@"PTClientUserWindow"];
    //self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib {
    
    // remove users already affected to user from available users list.
    for (User *u in usergroup.users) {
        
        for (NSUInteger i = 0; i < [availableUsers count]; i++) {
            
            // if user found.
            if ([[availableUsers objectAtIndex:i] isEqual:u]) {
                
                // remove user.
                [[self mutableArrayValueForKey:@"availableUsers"] removeObjectAtIndex:i];
            }
        }
    }
    
}

- (IBAction)cancelButtonClicked:(id)sender {
    
    [self close];
}



// assign selected user(s) to client. 
- (IBAction)assignUser:(id)sender {
    
    // get selection of users to be affected to client.
    NSArray *selectedUsers = [availableUsersArrayCtrl selectedObjects];
    
    for (User *user in selectedUsers) {
        
        if (!usergroup.users) {
            usergroup.users = [[NSMutableArray alloc] init];
        }
        
        // affect new user to client.
        [groupUsersArrayCtrl addObject:user];
        
        // remove user from available users.
        [availableUsersArrayCtrl removeObject:user];
        
        // sort users alphabetically.
        [usergroup.users sortUsingComparator:^NSComparisonResult(User *u1, User *u2) {
            
            return [u1.username compare:u2.username];
        }];
    }
}



// remove selected user(s) from client.
- (IBAction)removeUser:(id)sender {
    
    // get selection of users to be removed from client.
    NSArray *selectedUsers = [groupUsersArrayCtrl selectedObjects];
    
    for (User *user in selectedUsers) {
        // make user available.
        [availableUsersArrayCtrl addObject:user];
        
        // remove iserr from assigned users.
        [groupUsersArrayCtrl removeObject:user];
        
        // sort users alphabetically.
        [availableUsers sortUsingComparator:^NSComparisonResult(User *u1, User *u2) {
            
            return [u1.username compare:u2.username];
        }];
    }
}



- (IBAction)okButtonClicked:(id)sender {
    
    [progressIndicator startAnimation:self];
    [updatingUsergroupsLabel setHidden:NO];
    
    [self updateUsergroupUsers];
}

// update the client's users (in database).
- (BOOL)updateUsergroupUsers {
    
    BOOL success;
    
    // Initialize a new array to hold the users.
    NSMutableArray *usersArray = [[NSMutableArray alloc] init];
    
    // add (assigned) users to the array.
    for (User *user in usergroup.users) {
        
        NSDictionary *tmpUserDict = [user dictionaryWithValuesForKeys:[user userIdKey]];
        
        [usersArray addObject:tmpUserDict];
    }
    
    // create a new dictionary which holds the users.
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:usersArray forKey:@"user"];

    // update client's users in database via web service.
    success = [PTUsergroupHelper updateUsersForUsergroup:usergroup users:dict successBlock:^(NSMutableData *data) {[self finishedUpdatingUsergroups:data];} failureBlock:^(NSError *error) {[self failedUpdatingUsergroups:error];}];
    
    return success;
}

- (void)failedUpdatingUsergroups:(NSError *)failure {
    
    [progressIndicator stopAnimation:self];
    [updatingUsergroupsLabel setHidden:YES];
}

- (void)finishedUpdatingUsergroups:(NSMutableData *)data {
    
    [progressIndicator stopAnimation:self];
    [updatingUsergroupsLabel setHidden:YES];
    
    [self close];
}

@end
