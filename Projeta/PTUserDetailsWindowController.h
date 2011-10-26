//
//  PTUserDetailsWindowController.h
//  Projeta
//
//  Created by Michael Wermeester on 24/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;
@class PTUserManagementViewController;
@class Role;
@class User;

@interface PTUserDetailsWindowController : NSWindowController {
    NSTableView *userRolesTableView;
    NSArrayController *userRolesArrayCtrl;
    NSArrayController *availableRolesArrayCtrl;
    
    PTUserManagementViewController *parentUserManagementViewCtrl;
    
    BOOL isNewUser;
    NSTextField *usernameTextField;
    NSProgressIndicator *userNameProgressIndicator;
    NSImageView *userNameInvalidImageView;
    NSImageView *passwordInvalidImageView;
}


@property (strong) User *user;
// Holds the available roles which can be affected. 
@property (strong) NSMutableArray *availableRoles;
@property (strong) IBOutlet NSTableView *userRolesTableView;
// array controllers which hold the user roles.
@property (strong) IBOutlet NSArrayController *userRolesArrayCtrl;
@property (strong) IBOutlet NSArrayController *availableRolesArrayCtrl;
// parent user management view controller.
@property (strong) PTUserManagementViewController *parentUserManagementViewCtrl;
@property (assign) BOOL isNewUser;
@property (strong) IBOutlet NSTextField *usernameTextField;
// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;
@property (strong) IBOutlet NSProgressIndicator *userNameProgressIndicator;
@property (strong) IBOutlet NSImageView *userNameInvalidImageView;
@property (strong) IBOutlet NSImageView *passwordInvalidImageView;

// assign/remove a user role.
- (IBAction)assignUserRoles:(id)sender;
- (IBAction)removeUserRoles:(id)sender;

- (IBAction)okButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

// update user roles (in database).
- (BOOL)updateUserRoles;

- (void)finishedCreatingUser:(NSMutableData*)data;

- (void)sucUserExists:(BOOL)userExists;
- (void)failUserExists;

- (void)checkUsernameExists;

@end
