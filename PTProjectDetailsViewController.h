//
//  PTProjectDetailsViewController.h
//  Projeta
//
//  Created by Michael Wermeester on 2/4/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;
@class PTCommentairesViewController;
@class PTProjectViewController;
@class Project;

@interface PTProjectDetailsViewController : NSViewController {
    
    PTProjectViewController *projectViewController;
    //NSTreeController *prjTreeController;
    
    __weak NSButton *startDateRealCalendarButton;
    NSPopover *calendarPopover;
    __weak NSButton *endDateRealCalendarButton;
    
    NSArrayController *availableClientsArrayCtrl;
    NSArrayController *availableUsergroupsArrayCtrl;
    NSArrayController *availableUsersArrayCtrl;
    __weak NSView *tabTaskView;
    __weak NSView *tabBugView;
    __weak NSView *tabCommentView;
}

@property (strong) PTProjectViewController *projectViewController;
@property (assign) IBOutlet NSTreeController *prjTreeController;

@property (strong) Project *project;

@property (weak) IBOutlet NSButton *startDateRealCalendarButton;
@property (strong) IBOutlet NSPopover *calendarPopover;
@property (weak) IBOutlet NSButton *endDateRealCalendarButton;

- (IBAction)startDateRealCalendarButtonClicked:(id)sender;
- (IBAction)endDateRealCalendarButtonClicked:(id)sender;

// Holds the available clients which can be affected. 
@property (strong) NSMutableArray *availableClients;
@property (strong) IBOutlet NSArrayController *availableClientsArrayCtrl;
// Holds the available usergroups which can be affected. 
@property (strong) NSMutableArray *availableUsergroups;
@property (strong) IBOutlet NSArrayController *availableUsergroupsArrayCtrl;
// Holds the available users which can be affected. 
@property (strong) NSMutableArray *availableUsers;
@property (strong) IBOutlet NSArrayController *availableUsersArrayCtrl;
@property (weak) IBOutlet NSView *tabTaskView;
@property (weak) IBOutlet NSView *tabBugView;
@property (weak) IBOutlet NSView *tabCommentView;

@property (assign) MainWindowController *mainWindowController;

// task-list view
@property (strong) PTTaskListViewController *taskListViewController;
// bug-list view
@property (strong) PTBugListViewController *bugListViewController;
// commentaires-list view
@property (strong) PTCommentairesViewController *commentViewController;

// charger les utilisateurs, groupes et clients liés au projet.
- (void)loadProjectDetails;
// charger les tâches liés au projet sélectionné.
- (void)loadTasks;
// charger les bogues liés au projet sélectionné.
- (void)loadBugs;
// charger les commentaires liés au projet sélectionné.
- (void)loadComments;

@end
