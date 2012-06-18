//
//  PTUserGroupWindowController.m
//  Projeta
//
//  Created by Michael Wermeester on 1/22/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "PTGroupUserWindowController.h"
#import "User.h"
#import "Usergroup.h"
#import "PTUsergroupHelper.h"

@implementation PTGroupUserWindowController

@synthesize availableUsers;
@synthesize mainWindowController;
@synthesize parentGroupManagementViewCtrl;
@synthesize usergroup;
@synthesize groupUsersArrayCtrl;
@synthesize availableUsersArrayCtrl;
@synthesize updatingUsergroupsLabel;
@synthesize progressIndicator;

- (id)init
{
    self = [super initWithWindowNibName:@"PTGroupUserWindow"];
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



// assign selected user(s) to usergroup. 
- (IBAction)assignUser:(id)sender {
    
    // get selection of users to be affected to usergroup.
    NSArray *selectedUsers = [availableUsersArrayCtrl selectedObjects];
    
    for (User *user in selectedUsers) {
        
        if (!usergroup.users) {
            usergroup.users = [[NSMutableArray alloc] init];
        }
        
        // affect new user to usergroup.
        [groupUsersArrayCtrl addObject:user];
        
        // remove user from available users.
        [availableUsersArrayCtrl removeObject:user];
        
        // sort user roles alphabetically.
        [usergroup.users sortUsingComparator:^NSComparisonResult(User *u1, User *u2) {
            
            return [u1.username compare:u2.username];
        }];
    }
}

// remove selected user(s) from usergroup.
- (IBAction)removeUser:(id)sender {
    
    // get selection of users to be removed from usergroup.
    NSArray *selectedUsers = [groupUsersArrayCtrl selectedObjects];
    
    for (User *user in selectedUsers) {
        // make usergroup available.
        [availableUsersArrayCtrl addObject:user];
        
        // remove usergroup from user's usergroups.
        [groupUsersArrayCtrl removeObject:user];
        
        // sort user groups alphabetically.
        [availableUsers sortUsingComparator:^NSComparisonResult(User *u1, User *u2) {
            
            return [u1.username compare:u2.username];
        }];
    }
}

// bouton 'ok' cliqué.
- (IBAction)okButtonClicked:(id)sender {
    
    [progressIndicator startAnimation:self];
    [updatingUsergroupsLabel setHidden:NO];
    
    [self updateUsergroupUsers];
}

// update usergroup's users (in database).
- (BOOL)updateUsergroupUsers {
    
    BOOL success;
    
    // Initialize a new array to hold the roles.
    NSMutableArray *usersArray = [[NSMutableArray alloc] init];
    
    // add (assigned) user roles to the array.
    for (User *user in usergroup.users) {
        
        NSDictionary *tmpUserDict = [user dictionaryWithValuesForKeys:[user userIdKey]];
        
        [usersArray addObject:tmpUserDict];
    }
    
    // create a new dictionary which holds the users.
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:usersArray forKey:@"user"];
    
    // update usergroups in database via web service.
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

// Retourne le titre de la fenêtre.
- (NSString *)windowTitle {
    
    // afficher 'Projet : <nom du projet>'.
    NSString *retVal = [[NSString alloc] initWithString:@"Utilisateurs pour groupe"];
    if (usergroup) {
        if (usergroup.code) {
            retVal = [retVal stringByAppendingString:@" : "];
            retVal = [retVal stringByAppendingString:usergroup.code];
        }
    }
    
    return retVal;
    
}

@end
