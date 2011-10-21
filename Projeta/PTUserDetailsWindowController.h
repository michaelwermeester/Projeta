//
//  PTUserDetailsWindowController.h
//  Projeta
//
//  Created by Michael Wermeester on 24/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class User;
@class Role;

@interface PTUserDetailsWindowController : NSWindowController {
    NSTableView *userRolesTableView;
    NSArrayController *userRolesArrayCtrl;
    NSArrayController *availableRolesArrayCtrl;
}


@property (strong) User *user;
// Holds the available roles which can be affected. 
@property (strong) NSMutableArray *availableRoles;
@property (strong) IBOutlet NSTableView *userRolesTableView;
// array controllers which hold the user roles.
@property (strong) IBOutlet NSArrayController *userRolesArrayCtrl;
@property (strong) IBOutlet NSArrayController *availableRolesArrayCtrl;

// assign/remove a user role.
- (IBAction)assignUserRoles:(id)sender;
- (IBAction)removeUserRoles:(id)sender;

- (IBAction)okButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

- (void)updateUserRoles;

@end
