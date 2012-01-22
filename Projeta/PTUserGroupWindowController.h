//
//  PTUserGroupWindowController.h
//  Projeta
//
//  Created by Michael Wermeester on 1/22/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;
@class PTUserManagementViewController;
@class User;

@interface PTUserGroupWindowController : NSWindowController {

    PTUserManagementViewController *parentUserManagementViewCtrl;
    NSArrayController *userUsergroupsArrayCtrl;
    NSArrayController *availableUsergroupsArrayCtrl;
    __weak NSTextField *updatingUsergroupsLabel;
    __weak NSProgressIndicator *progressIndicator;
}

// Holds the available usergroups which can be affected. 
@property (strong) NSMutableArray *availableUsergroups;
// parent user management view controller.
@property (strong) PTUserManagementViewController *parentUserManagementViewCtrl;
// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;
// User
@property (strong) User *user;
@property (strong) IBOutlet NSArrayController *userUsergroupsArrayCtrl;
@property (strong) IBOutlet NSArrayController *availableUsergroupsArrayCtrl;
@property (weak) IBOutlet NSTextField *updatingUsergroupsLabel;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;


- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)assignUsergroup:(id)sender;
- (IBAction)removeUsergroup:(id)sender;
- (IBAction)okButtonClicked:(id)sender;

// update user's usergroups (in database).
- (BOOL)updateUserUsergroups;
- (void)failedUpdatingUsergroups:(NSError *)failure;
- (void)finishedUpdatingUsergroups:(NSMutableData *)data;

@end
