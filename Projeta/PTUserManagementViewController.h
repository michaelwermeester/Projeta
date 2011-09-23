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

@interface PTUserManagementViewController : NSViewController {
    NSMutableArray *arrUsr;     // array which holds the users
    NSTableView *usersTableView;
    NSArrayController *arrayCtrl;   // array controller
}

@property (strong) NSMutableArray *arrUsr;
@property (strong) IBOutlet NSTableView *usersTableView;
@property (strong) IBOutlet NSArrayController *arrayCtrl;
@property (strong) IBOutlet NSButton *deleteButton;
// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;

// NSURLConnection
- (void)requestFinished:(NSMutableData*)data;
- (void)requestFailed:(NSError*)error;
- (IBAction)deleteButtonClicked:(id)sender;

- (void)updateUser:(User *)theUser;

@end
