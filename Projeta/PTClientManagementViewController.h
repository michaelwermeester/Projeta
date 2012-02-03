//
//  PTClientManagementViewController.h
//  Projeta
//
//  Created by Michael Wermeester on 1/30/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PTClientDetailsWindowController;
@class PTClientUserWindowController;
@class MainWindowController;

@interface PTClientManagementViewController : NSViewController {
    // array qui contient les utilisateurs.
    NSMutableArray *arrClients;
    NSTableView *clientsTableView;
    NSArrayController *clientsArrayCtrl;   // array controller
    
    __weak NSButton *clientDetailsButtonClicked;
    __weak NSButton *addClientButtonClicked;
    __weak NSButton *deleteClientButtonClicked;
    
    // client details window
    PTClientDetailsWindowController *clientDetailsWindowController;
    
    PTClientUserWindowController *clientUserWindowController;
}

// array qui contient les utilisateurs.
@property (strong) NSMutableArray *arrClients;
@property (strong) IBOutlet NSTableView *clientsTableView;
@property (strong) IBOutlet NSArrayController *clientsArrayCtrl;
// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;
- (IBAction)addClientButtonClicked:(id)sender;
- (IBAction)deleteClientButtonClicked:(id)sender;
- (IBAction)clientDetailsButtonClicked:(id)sender;
- (IBAction)clientUsersButtonClicked:(id)sender;

- (void)viewDidLoad;

- (void)getClientNamesRequestFinished:(NSMutableArray *)users;
- (void)getClientNamesRequestFailed:(NSError*)error;

@end
