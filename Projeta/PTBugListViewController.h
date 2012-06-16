//
//  PTTaskListViewController.h
//  Projeta
//
//  Created by Michael Wermeester on 06/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;
@class PTBugDetailsWindowController;
@class PTCommentairesWindowController;
@class PTProjectDetailsViewController;

@interface PTBugListViewController : NSViewController {
    NSMutableArray *arrBug;     // array which holds the projects
    NSArrayController *bugArrayCtrl;
    NSTreeController *bugTreeCtrl;
    NSOutlineView *bugOutlineView;
    __weak NSTableColumn *outlineViewProjetColumn;
    __weak NSButton *projectButton;
    __weak NSButton *removeBugButton;
    
    // task details window
    PTBugDetailsWindowController *bugDetailsWindowController;
    // fenêtre commentaires.
    PTCommentairesWindowController *commentWindowController;
    __weak NSButton *addBugButton;
}

@property (strong) NSMutableArray *arrBug;
@property (strong) IBOutlet NSArrayController *bugArrayCtrl;
@property (strong) IBOutlet NSTreeController *bugTreeCtrl;
@property (strong) IBOutlet NSOutlineView *bugOutlineView;
- (IBAction)detailsButtonClicked:(id)sender;
@property (weak) IBOutlet NSButton *addBugButton;

@property (weak) IBOutlet NSTableColumn *outlineViewProjetColumn;
@property (weak) IBOutlet NSButton *projectButton;
@property (weak) IBOutlet NSButton *removeBugButton;

// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;

@property (strong) NSString *bugURL;           // optionel. Contient l'URL à utiliser. 

// reference to the (parent) PTProjectDetailsViewController
@property (assign) PTProjectDetailsViewController *parentProjectDetailsViewController;
- (IBAction)addNewBugButtonClicked:(id)sender;

- (void)requestFinished:(NSMutableData*)data;
- (void)requestFailed:(NSError*)error;

- (void)openBugDetailsWindow:(BOOL)isNewBug;

@end
