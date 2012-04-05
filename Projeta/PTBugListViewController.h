//
//  PTTaskListViewController.h
//  Projeta
//
//  Created by Michael Wermeester on 06/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;

@interface PTBugListViewController : NSViewController {
    NSMutableArray *arrBug;     // array which holds the projects
    NSArrayController *bugArrayCtrl;
    NSTreeController *bugTreeCtrl;
    NSOutlineView *bugOutlineView;
    __weak NSTableColumn *outlineViewProjetColumn;
    __weak NSButton *projectButton;
}

@property (strong) NSMutableArray *arrBug;
@property (strong) IBOutlet NSArrayController *bugArrayCtrl;
@property (strong) IBOutlet NSTreeController *bugTreeCtrl;
@property (strong) IBOutlet NSOutlineView *bugOutlineView;
- (IBAction)addTaskButtonClick:(id)sender;

@property (weak) IBOutlet NSTableColumn *outlineViewProjetColumn;
@property (weak) IBOutlet NSButton *projectButton;

// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;

- (void)requestFinished:(NSMutableData*)data;
- (void)requestFailed:(NSError*)error;

@end