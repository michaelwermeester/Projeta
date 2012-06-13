//
//  PTUsersView.h
//  Projeta
//
//  Created by Michael Wermeester on 04/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "User.h"

@class MainWindowController;
@class PTUserDetailsWindowController;
@class PTUserGroupWindowController;

@interface PTUserManagementViewController : NSViewController {
    NSMutableArray *arrUsr;     // array qui contient les utilisateurs.
    NSArrayController *arrayCtrl;   // array controller pour l'array arrUsr.
    NSTableView *usersTableView;
    
    // user details window
    PTUserDetailsWindowController *userDetailsWindowController;
    PTUserGroupWindowController *userGroupWindowController;
    
    __weak NSSearchField *searchField;
    __weak NSButton *groupsButton;
}

@property (strong) NSMutableArray *arrUsr;      // array qui contient les utilisateurs.
@property (strong) IBOutlet NSTableView *usersTableView;    // array controller pour l'array arrUsr.
@property (strong) IBOutlet NSArrayController *arrayCtrl;
@property (strong) IBOutlet NSButton *deleteButton;
// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;
@property (weak) IBOutlet NSButton *groupsButton;
@property (weak) IBOutlet NSSearchField *searchField;

- (IBAction)addButtonClicked:(id)sender;
- (IBAction)removeButtonClicked:(id)sender;
- (IBAction)deleteButtonClicked:(id)sender;
- (IBAction)detailsButtonClicked:(id)sender;
- (IBAction)groupsButtonClicked:(id)sender;

- (void)openUserDetailsWindow:(BOOL)isNewUser;
- (void)openUserGroupWindow;

- (void)allUsersRequestFinished:(NSMutableArray *)users;
- (void)allUsersRequestFailed:(NSError*)error;

- (IBAction)findUser:(id)sender;

@end
