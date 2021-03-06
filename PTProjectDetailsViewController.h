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
@class PTGanttViewController;
@class PTProjectViewController;
@class Project;
//@class Usergroup;

@interface PTProjectDetailsViewController : NSViewController {
    
    PTProjectViewController *projectViewController;
    
    __weak NSButton *startDateRealCalendarButton;
    NSPopover *calendarPopover;
    __weak NSButton *endDateRealCalendarButton;
    __weak NSButton *startDateCalendarButton;
    __weak NSButton *endDateCalendarButton;
    __weak NSButton *saveProjectButton;
    
    NSArrayController *availableClientsArrayCtrl;
    NSArrayController *availableUsergroupsArrayCtrl;
    NSArrayController *availableUsersArrayCtrl;
    __weak NSView *tabTaskView;
    __weak NSView *tabBugView;
    __weak NSView *tabCommentView;
    __weak NSView *tabGanttView;
    __weak NSComboBox *comboDevelopers;
    __weak NSDatePicker *projectStartDateDatePicker;
    __weak NSDatePicker *projectEndDateDatePicker;
    
    NSDate *parentProjectStartDate;
    NSDate *parentProjectEndDate;
    
    BOOL isNewProject;
    
    Project *projectCopy;
    
    NSMutableArray *arrDevelopers;
    __weak NSTabView *tabView;
    
    NSTabViewItem *activityTab;
    NSTabViewItem *clientTab;
    NSTabViewItem *visibilityTab;
    __weak NSButton *removeUser;
    
    //NSMutableArray *assignedUsers;
}

@property (strong) NSMutableArray *assignedClients;
@property (strong) IBOutlet NSArrayController *assignedClientsArrayCtrl;
@property (strong) NSMutableArray *assignedUsers;
@property (strong) IBOutlet NSArrayController *assignedUsersArrayCtrl;
@property (strong) NSMutableArray *assignedUsergroups;
@property (strong) IBOutlet NSArrayController *assignedUsersgroupsArrayCtrl;

@property (strong) PTProjectViewController *projectViewController;
@property (assign) IBOutlet NSTreeController *prjTreeController;
@property (weak) IBOutlet NSTabView *tabView;

@property (strong) NSMutableArray *arrDevelopers;

@property (strong) Project *project;

@property (weak) IBOutlet NSButton *startDateRealCalendarButton;
@property (strong) IBOutlet NSPopover *calendarPopover;
@property (weak) IBOutlet NSButton *endDateRealCalendarButton;
@property (weak) IBOutlet NSButton *startDateCalendarButton;
@property (weak) IBOutlet NSButton *endDateCalendarButton;
@property (weak) IBOutlet NSButton *saveProjectButton;

@property (assign) BOOL isNewProject;
@property (strong) Project *projectCopy;


- (IBAction)startDateRealCalendarButtonClicked:(id)sender;
- (IBAction)endDateRealCalendarButtonClicked:(id)sender;
- (IBAction)startDateCalendarButtonClicked:(id)sender;
- (IBAction)endDateCalendarButtonClicked:(id)sender;
- (IBAction)saveProjectButtonClicked:(id)sender;
- (IBAction)assignUser:(id)sender;
- (IBAction)removeUser:(id)sender;
- (IBAction)assignGroup:(id)sender;
- (IBAction)removeGroup:(id)sender;
- (IBAction)assignClient:(id)sender;
- (IBAction)removeClient:(id)sender;



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
@property (weak) IBOutlet NSView *tabGanttView;
@property (weak) IBOutlet NSComboBox *comboDevelopers;

@property (weak) IBOutlet NSDatePicker *projectStartDateDatePicker;
@property (weak) IBOutlet NSDatePicker *projectEndDateDatePicker;


@property (nonatomic, copy) NSDate *parentProjectStartDate;
@property (nonatomic, copy) NSDate *parentProjectEndDate;

@property (assign) MainWindowController *mainWindowController;

// task-list view
@property (strong) PTTaskListViewController *taskListViewController;
// bug-list view
@property (strong) PTBugListViewController *bugListViewController;
// commentaires-list view
@property (strong) PTCommentairesViewController *commentViewController;
// Gantt view
@property (strong) PTGanttViewController *ganttViewController;

// charger les utilisateurs, groupes et clients liés au projet.
- (void)loadProjectDetails;
// charger les tâches liés au projet sélectionné.
- (void)loadTasks;
// charger les bogues liés au projet sélectionné.
- (void)loadBugs;
// charger les commentaires liés au projet sélectionné.
- (void)loadComments;
// charger le diagramme de Gantt lié au projet sélectionné.
- (void)loadGantt;

// affiche l'onglet 'Visibilité' et 'Client(s)' si l'utilisateur authentifié est un développeur ou administrateur.
- (void)showClientAndVisibilityTab;

- (BOOL)updateUserVisibility;

@end
