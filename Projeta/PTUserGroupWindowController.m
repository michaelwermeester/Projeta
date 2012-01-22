//
//  PTUserGroupWindowController.m
//  Projeta
//
//  Created by Michael Wermeester on 1/22/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "PTUserGroupWindowController.h"
#import "User.h"
#import "Usergroup.h"
#import "PTUsergroupHelper.h"

@implementation PTUserGroupWindowController

@synthesize availableUsergroups;
@synthesize mainWindowController;
@synthesize parentUserManagementViewCtrl;
@synthesize user;
@synthesize userUsergroupsArrayCtrl;
@synthesize availableUsergroupsArrayCtrl;
@synthesize updatingUsergroupsLabel;
@synthesize progressIndicator;

//User *userCopy;

- (id)init
{
    self = [super initWithWindowNibName:@"PTUserGroupWindow"];
    //self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib {
    
    //userCopy = [[User alloc] init];
    //userCopy = [user copy];
    
    // remove usergroups already affected to user from available usergroups list.
    for (Usergroup *ug in user.usergroups) {
        
        for (NSUInteger i = 0; i < [availableUsergroups count]; i++) {
            
            // if usergroup found.
            if ([[availableUsergroups objectAtIndex:i] isEqual:ug]) {
                
                // remove usergroup.
                [[self mutableArrayValueForKey:@"availableUsergroups"] removeObjectAtIndex:i];
            }
        }
    }
    
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)cancelButtonClicked:(id)sender {
    
    [self close];
}

// assign selected usergroup(s) to user. 
- (IBAction)assignUsergroup:(id)sender {
    
    // get selection of roles to be affected to user.
    NSArray *selectedUsergroups = [availableUsergroupsArrayCtrl selectedObjects];
    
    for (Usergroup *usergroup in selectedUsergroups) {
        
        if (!user.usergroups) {
            user.usergroups = [[NSMutableArray alloc] init];
        }
        
        // affect new role to user.
        [userUsergroupsArrayCtrl addObject:usergroup];
        
        // remove role from available roles.
        [availableUsergroupsArrayCtrl removeObject:usergroup];
        
        // sort user roles alphabetically.
        [user.usergroups sortUsingComparator:^NSComparisonResult(Usergroup *ug1, Usergroup *ug2) {
            
            return [ug1.code compare:ug2.code];
        }];
    }
}

// remove selected usergroup(s) from user.
- (IBAction)removeUsergroup:(id)sender {
    
    // get selection of usergroups to be removed from user.
    NSArray *selectedUsergroups = [userUsergroupsArrayCtrl selectedObjects];
    
    for (Usergroup *usergroup in selectedUsergroups) {
        // make usergroup available.
        [availableUsergroupsArrayCtrl addObject:usergroup];
        
        // remove usergroup from user's usergroups.
        [userUsergroupsArrayCtrl removeObject:usergroup];
        
        // sort user groups alphabetically.
        [availableUsergroups sortUsingComparator:^NSComparisonResult(Usergroup *ug1, Usergroup *ug2) {
            
            return [ug1.code compare:ug2.code];
        }];
    }
}

- (IBAction)okButtonClicked:(id)sender {
    
    [progressIndicator startAnimation:self];
    [updatingUsergroupsLabel setHidden:NO];
    
    [self updateUserUsergroups];
}

// update user's usergroups (in database).
- (BOOL)updateUserUsergroups {
    
    BOOL success;
    
    // Initialize a new array to hold the roles.
    NSMutableArray *usergroupsArray = [[NSMutableArray alloc] init];
    
    // add (assigned) user roles to the array.
    for (Usergroup *usergroup in user.usergroups) {
        
        NSDictionary *tmpUsergroupDict = [usergroup dictionaryWithValuesForKeys:[user updateUsergroupsKeys]];
        
        [usergroupsArray addObject:tmpUsergroupDict];
    }
    
    // create a new dictionary which holds the usergroups.
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:usergroupsArray forKey:@"usergroup"];
    
    //
    // update user roles in database via web service.
    success = [PTUsergroupHelper updateUsergroupsForUser:user usergroups:dict successBlock:^(NSMutableData *data) {[self finishedUpdatingUsergroups:data];} failureBlock:^(NSError *error) {[self failedUpdatingUsergroups:error];}];
    
    return success;
}

- (void)failedUpdatingUsergroups:(NSError *)failure {
    
    [progressIndicator stopAnimation:self];
    [updatingUsergroupsLabel setHidden:YES];
}

- (void)finishedUpdatingUsergroups:(NSMutableData *)data {
    
    [progressIndicator stopAnimation:self];
    [updatingUsergroupsLabel setHidden:YES];
    NSLog(@"ok, updated user groups");
    
    [self close];
}

@end
