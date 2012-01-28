//
//  PTUserGroupWindowController.h
//  Projeta
//
//  Created by Michael Wermeester on 1/22/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;
@class PTGroupManagementViewController;
@class Usergroup;

@interface PTGroupUserWindowController : NSWindowController {

    PTGroupManagementViewController *parentGroupManagementViewCtrl;
    NSArrayController *groupUsersArrayCtrl;
    NSArrayController *availableUsersArrayCtrl;
    __weak NSTextField *updatingUsergroupsLabel;
    __weak NSProgressIndicator *progressIndicator;
}

// Holds the available usergroups which can be affected. 
@property (strong) NSMutableArray *availableUsers;
// parent user management view controller.
@property (strong) PTGroupManagementViewController *parentGroupManagementViewCtrl;
// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;
// User
@property (strong) Usergroup *usergroup;
@property (strong) IBOutlet NSArrayController *groupUsersArrayCtrl;
@property (strong) IBOutlet NSArrayController *availableUsersArrayCtrl;
@property (weak) IBOutlet NSTextField *updatingUsergroupsLabel;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;


- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)assignUser:(id)sender;
- (IBAction)removeUser:(id)sender;
- (IBAction)okButtonClicked:(id)sender;

// update usergroup's users (in database).
- (BOOL)updateUsergroupUsers;
- (void)failedUpdatingUsergroups:(NSError *)failure;
- (void)finishedUpdatingUsergroups:(NSMutableData *)data;

@end
