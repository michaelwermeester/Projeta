//
//  PTTaskListViewController.h
//  Projeta
//
//  Created by Michael Wermeester on 06/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;
@class PTCommentairesWindowController;
@class PTProjectDetailsViewController;
@class PTTaskDetailsWindowController;

@interface PTTaskListViewController : NSViewController {
    NSMutableArray *arrTask;     // array which holds the projects
    NSArrayController *taskArrayCtrl;
    NSTreeController *taskTreeCtrl;
    NSOutlineView *taskOutlineView;
    __weak NSTableColumn *outlineViewProjetColumn;
    __weak NSButton *projectButton;
    __weak NSButton *checkBoxShowTasksFromSubProjects;
    
    BOOL isPersonalTask;
    
    // task details window
    PTTaskDetailsWindowController *taskDetailsWindowController;
    // fenêtre commentaires.
    PTCommentairesWindowController *commentWindowController;
}

@property (strong) NSMutableArray *arrTask;
@property (strong) IBOutlet NSArrayController *taskArrayCtrl;
@property (strong) IBOutlet NSTreeController *taskTreeCtrl;
@property (strong) IBOutlet NSOutlineView *taskOutlineView;
- (IBAction)addTaskButtonClick:(id)sender;

@property (weak) IBOutlet NSTableColumn *outlineViewProjetColumn;
@property (weak) IBOutlet NSButton *projectButton;
@property (weak) IBOutlet NSButton *checkBoxShowTasksFromSubProjects;

@property (assign) BOOL isPersonalTask;

- (IBAction)addNewTaskButtonClicked:(id)sender;
- (IBAction)addNewSubTaskButtonClicked:(id)sender;
- (IBAction)detailsButtonClicked:(id)sender;
- (IBAction)removeTaskButtonClicked:(id)sender;
- (IBAction)commentButtonClicked:(id)sender;

// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;

// reference to the (parent) PTProjectDetailsViewController
@property (assign) PTProjectDetailsViewController *parentProjectDetailsViewController;

- (void)requestFinished:(NSMutableData*)data;
- (void)requestFailed:(NSError*)error;

- (void)openTaskDetailsWindow:(BOOL)isNewTask isSubTask:(BOOL)isSubTask;

@end
