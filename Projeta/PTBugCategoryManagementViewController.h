//
//  PTGroupManagementViewController.h
//  Projeta
//
//  Created by Michael Wermeester on 31/10/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;
@class Usergroup;

@interface PTBugCategoryManagementViewController : NSViewController {
    NSMutableArray *arrUsrGrp;     // array which holds the user groups.
    NSArrayController *usergroupArrayCtrl;
    NSTableView *usergroupTableView;
    __weak NSButton *usersButton;
}

@property (strong) NSMutableArray *arrUsrGrp;
@property (strong) IBOutlet NSArrayController *usergroupArrayCtrl;
@property (strong) IBOutlet NSTableView *usergroupTableView;
@property (weak) IBOutlet NSButton *usersButton;

// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;

// Fetch user groups from webservice.
- (void)fetchUsergroups;

- (void)fetchRequestFinished:(NSMutableData*)data;
- (void)fetchRequestFailed:(NSError*)error;

- (IBAction)addUsergroupButtonClicked:(id)sender;
- (IBAction)usersButtonClicked:(id)sender;

- (void)updateUsergroup:(Usergroup *)theUsergroup;


@end
