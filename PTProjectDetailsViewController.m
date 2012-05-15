//
//  PTProjectDetailsViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 2/4/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "MainWindowController.h"
#import "MWCalendarViewController.h"
#import "PTBugListViewController.h"
#import "PTClientHelper.h"
#import "PTCommentairesViewController.h"
#import "PTGanttViewController.h"
#import "PTProjectDetailsViewController.h"
#import "PTProjectHelper.h"
#import "PTUsergroupHelper.h"
#import "PTUserHelper.h"
#import "Usergroup.h"



@implementation PTProjectDetailsViewController

@synthesize projectViewController;
@synthesize prjTreeController;

@synthesize project;
@synthesize startDateRealCalendarButton;
@synthesize calendarPopover;
@synthesize endDateRealCalendarButton;
@synthesize startDateCalendarButton;
@synthesize endDateCalendarButton;
@synthesize saveProjectButton;

@synthesize availableUsergroups;
@synthesize availableUsergroupsArrayCtrl;
@synthesize availableUsers;
@synthesize availableUsersArrayCtrl;
@synthesize tabTaskView;
@synthesize tabBugView;
@synthesize tabCommentView;
@synthesize tabGanttView;
@synthesize projectStartDateDatePicker;
@synthesize projectEndDateDatePicker;
@synthesize availableClients;
@synthesize availableClientsArrayCtrl;

@synthesize mainWindowController;

@synthesize bugListViewController;
@synthesize commentViewController;
@synthesize ganttViewController;
@synthesize taskListViewController;

@synthesize parentProjectStartDate;
@synthesize parentProjectEndDate;

@synthesize isNewProject;
@synthesize projectCopy;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"PTProjectDetailsView" bundle:nibBundleOrNil];
    if (self) {
        
        // Initialization code here.
        
        // initialiser l'array qui contient les groupes d'utilisateurs disponibles.
        availableUsergroups = [[NSMutableArray alloc] init];
        // initialiser l'array qui contient les utilisateurs disponibles.
        availableUsers = [[NSMutableArray alloc] init];
        // initialiser l'array qui contient les clients disponibles.
        availableClients = [[NSMutableArray alloc] init];
        
        // faire une copie du projet en cours.
        projectCopy = [[Project alloc] init];
        projectCopy = [project copy];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    //[self viewDidLoad];
}

// charger les utilisateurs, groupes et clients liés au projet.
- (void)loadProjectDetails {
    
    // charger la liste des groupes d'utilisateurs disponibles.
    [self fetchAvailableUsergroups];
    // charger la liste des utilisateurs disponibles.
    [self fetchAvailableUsers];
    // charger la liste des clients disponibles.
    [self fetchAvailableClients];
}

- (void)loadTasks {
    taskListViewController = [[PTTaskListViewController alloc] init];
    
    // set reference to (parent) window
    [taskListViewController setMainWindowController:mainWindowController];
    
    // set reference to (parent) project details view.
    [taskListViewController setParentProjectDetailsViewController:self];
    
    // resize the view to fit and fill the right splitview view
    [taskListViewController.view setFrameSize:tabTaskView.frame.size];
    
    [self.tabTaskView addSubview:taskListViewController.view];
    
    // auto resize the view.
    [taskListViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    // cacher lo colonne "projet".
    [taskListViewController.outlineViewProjetColumn setHidden:YES];
    [taskListViewController.checkBoxShowTasksFromSubProjects setHidden:NO];
    //[taskListViewController.projectButton removeFromSuperview];
    [taskListViewController.projectButton setHidden:YES];
}

- (void)loadBugs {
    bugListViewController = [[PTBugListViewController alloc] init];
    
    // set reference to (parent) window
    [bugListViewController setMainWindowController:mainWindowController];
    
    // set reference to (parent) project details view.
    [bugListViewController setParentProjectDetailsViewController:self];
    
    // resize the view to fit and fill the right splitview view
    [bugListViewController.view setFrameSize:tabBugView.frame.size];
    
    [self.tabBugView addSubview:bugListViewController.view];
    
    // auto resize the view.
    [bugListViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    // cacher lo colonne "projet".
    //[taskListViewController.outlineViewProjetColumn setHidden:YES];
    //[taskListViewController.checkBoxShowTasksFromSubProjects setHidden:NO];
    //[taskListViewController.projectButton removeFromSuperview];
    //[taskListViewController.projectButton setHidden:YES];
}

- (void)loadComments {
    commentViewController = [[PTCommentairesViewController alloc] init];
    
    // set reference to (parent) window
    [commentViewController setMainWindowController:mainWindowController];
    
    // set reference to (parent) project details view.
    [commentViewController setParentProjectDetailsViewController:self];
    
    // resize the view to fit and fill the right splitview view
    [commentViewController.view setFrameSize:tabCommentView.frame.size];
    
    [self.tabCommentView addSubview:commentViewController.view];
    
    // auto resize the view.
    [commentViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    
    commentViewController.project = [self project];
    
    // charger commentaires.
    [commentViewController loadComments];
    
    // cacher lo colonne "projet".
    //[taskListViewController.outlineViewProjetColumn setHidden:YES];
    //[taskListViewController.checkBoxShowTasksFromSubProjects setHidden:NO];
    //[taskListViewController.projectButton removeFromSuperview];
    //[taskListViewController.projectButton setHidden:YES];
}

// charger le diagramme de Gantt lié au projet sélectionné.
- (void)loadGantt {
    ganttViewController = [[PTGanttViewController alloc] init];
    
    // set reference to (parent) window
    [ganttViewController setMainWindowController:mainWindowController];
    
    // set reference to (parent) project details view.
    [ganttViewController setParentProjectDetailsViewController:self];
    
    // resize the view to fit and fill the right splitview view
    [ganttViewController.view setFrameSize:tabGanttView.frame.size];
    
    [self.tabGanttView addSubview:ganttViewController.view];
    
    // auto resize the view.
    [ganttViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    
    ganttViewController.project = [self project];
    
    // charger commentaires.
    [ganttViewController loadGantt];
    
    // cacher lo colonne "projet".
    //[taskListViewController.outlineViewProjetColumn setHidden:YES];
    //[taskListViewController.checkBoxShowTasksFromSubProjects setHidden:NO];
    //[taskListViewController.projectButton removeFromSuperview];
    //[taskListViewController.projectButton setHidden:YES];
}

- (IBAction)startDateRealCalendarButtonClicked:(id)sender {
    
    // si bouton clicked...
    if (self.startDateRealCalendarButton.intValue == 1) {
        
        // binder la propriété 'value' du datepicker avec la propriété correspondante de l'objet 'projet'. 
        MWCalendarViewController *calView = (MWCalendarViewController *)calendarPopover.contentViewController;
        [calView.datePicker bind:@"value" toObject:self withKeyPath:@"project.startDateReal" options:nil];
        //[calView.datePicker bind:@"minValue" toObject:self withKeyPath:@"parentProjectStartDate" options:nil];
        //[calView.datePicker bind:@"maxValue" toObject:self withKeyPath:@"parentProjectEndDate" options:nil];
        
        // afficher le popup avec le calendrier.
        [self.calendarPopover showRelativeToRect:[startDateRealCalendarButton bounds]
                                  ofView:startDateRealCalendarButton
                           preferredEdge:NSMaxYEdge];
    } else {
        [self.calendarPopover close];
    }

}

- (IBAction)endDateRealCalendarButtonClicked:(id)sender {
    
    // si bouton clicked...
    if (self.endDateRealCalendarButton.intValue == 1) {
        
        // binder la propriété 'value' du datepicker avec la propriété correspondante de l'objet 'projet'. 
        MWCalendarViewController *calView = (MWCalendarViewController *)calendarPopover.contentViewController;
        [calView.datePicker bind:@"value" toObject:self withKeyPath:@"project.endDateReal" options:nil];
        
        // afficher le popup avec le calendrier.
        [self.calendarPopover showRelativeToRect:[endDateRealCalendarButton bounds]
                                          ofView:endDateRealCalendarButton
                                   preferredEdge:NSMaxYEdge];
    } else {
        [self.calendarPopover close];
    }
}

- (IBAction)startDateCalendarButtonClicked:(id)sender {
    // si bouton clicked...
    if (self.startDateCalendarButton.intValue == 1) {
        
        // binder la propriété 'value' du datepicker avec la propriété correspondante de l'objet 'projet'. 
        MWCalendarViewController *calView = (MWCalendarViewController *)calendarPopover.contentViewController;
        [calView.datePicker bind:@"value" toObject:self withKeyPath:@"project.startDate" options:nil];
        
        // afficher le popup avec le calendrier.
        [self.calendarPopover showRelativeToRect:[startDateCalendarButton bounds]
                                          ofView:startDateCalendarButton
                                   preferredEdge:NSMaxYEdge];
    } else {
        [self.calendarPopover close];
    }
}

- (IBAction)endDateCalendarButtonClicked:(id)sender {
    // si bouton clicked...
    if (self.endDateCalendarButton.intValue == 1) {
        
        // binder la propriété 'value' du datepicker avec la propriété correspondante de l'objet 'projet'. 
        MWCalendarViewController *calView = (MWCalendarViewController *)calendarPopover.contentViewController;
        [calView.datePicker bind:@"value" toObject:self withKeyPath:@"project.endDate" options:nil];
        
        // afficher le popup avec le calendrier.
        [self.calendarPopover showRelativeToRect:[endDateCalendarButton bounds]
                                          ofView:endDateCalendarButton
                                   preferredEdge:NSMaxYEdge];
    } else {
        [self.calendarPopover close];
    }
}

- (IBAction)saveProjectButtonClicked:(id)sender {
    
    BOOL prjUpdSuc = NO;
    
    // donner le focus au bouton 'OK'.
    [mainWindowController.window makeFirstResponder:saveProjectButton];
    
    // créer un nouveau projet.
    if (isNewProject == YES) {
        
        // user created.
        project.userCreated = mainWindowController.loggedInUser;
        
        
        prjUpdSuc = [PTProjectHelper createProject:project successBlock:^(NSMutableData *data) {
            [self finishedCreatingProject:data];
        } 
                              mainWindowController:mainWindowController];
    }
    // mettre à jour projet existant.
    else {
        prjUpdSuc = [PTProjectHelper updateProject:project successBlock:^(NSMutableData *data) {
            [self finishedCreatingProject:data];
        } 
                              mainWindowController:mainWindowController];
    }
}

// charger les groupes d'utilisateurs à partir du webservice.
- (void)fetchAvailableUsergroups {
    
    // start animating the main window's circular progress indicator.
    [mainWindowController startProgressIndicatorAnimation];
    
    // fetch available usergroups.
    [PTUsergroupHelper usergroupsAvailable:^(NSMutableArray *tmpAvailableUsergroups) {
        
        // sort available roles alphabetically.
        [tmpAvailableUsergroups sortUsingComparator:^NSComparisonResult(Usergroup *ug1, Usergroup *ug2) {
            
            return [ug1.code compare:ug2.code];
        }];
        
        // ajouter les groupes dans l'array.
        [[self mutableArrayValueForKey:@"availableUsergroups"] addObjectsFromArray:tmpAvailableUsergroups];
        
        // stop animating the main window's circular progress indicator.
        [mainWindowController stopProgressIndicatorAnimation];
    }];
}

// charger les utilisateurs à partir du webservice.
- (void)fetchAvailableUsers {
    
    // start animating the main window's circular progress indicator.
    [mainWindowController startProgressIndicatorAnimation];
    
    // fetch available users.
    [PTUserHelper allUsers:^(NSMutableArray *tmpAvailableUsers) { 
        
        // sort available roles alphabetically.
        [tmpAvailableUsers sortUsingComparator:^NSComparisonResult(User *u1, User *u2) {
            
            return [u1.username compare:u2.username];
        }];
        
        // ajouter les groupes dans l'array.
        [[self mutableArrayValueForKey:@"availableUsers"] addObjectsFromArray:tmpAvailableUsers];
        
        // stop animating the main window's circular progress indicator.
        [mainWindowController stopProgressIndicatorAnimation];
        
    } failureBlock:^(NSError *error) { 
        // stop animating the main window's circular progress indicator.
        [mainWindowController stopProgressIndicatorAnimation];
    }];
}

// charger les clients à partir du webservice.
- (void)fetchAvailableClients {
    
    // start animating the main window's circular progress indicator.
    [mainWindowController startProgressIndicatorAnimation];
    
    [PTClientHelper getClientNames:^(NSMutableArray *tmpAvailableClients) { 
        
        // sort available roles alphabetically.
        [tmpAvailableClients sortUsingComparator:^NSComparisonResult(Client *c1, Client *c2) {
            
            return [c1.clientName compare:c2.clientName];
        }];
        
        [[self mutableArrayValueForKey:@"availableClients"] addObjectsFromArray:tmpAvailableClients];
        
        // stop animating the main window's circular progress indicator.
        [mainWindowController stopProgressIndicatorAnimation];
    } failureBlock:^(NSError *error) {
        //[self getClientNamesRequestFailed:error];
        // stop animating the main window's circular progress indicator.
        [mainWindowController stopProgressIndicatorAnimation];
    }];
}

- (void)finishedCreatingProject:(NSMutableData*)data {
    
    
    NSError *error;
    
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSMutableArray *createdProjectArray = [[NSMutableArray alloc] init];
    
    // see Cocoa and Objective-C up and running by Scott Stevenson.
    // page 242
    //[createdUserArray addObjectsFromArray:[PTUserHelper setAttributesFromDictionary2:dict]];
    [createdProjectArray addObjectsFromArray:[PTProjectHelper setAttributesFromJSONDictionary:dict]];
    
    NSLog(@"count: %lu", [createdProjectArray count]);
    
    if ([createdProjectArray count] == 1) {
        
        for (Project *prj in createdProjectArray) {
            
            
            //[parentProjectListViewController.prjTreeController removeObjectAtArrangedObjectIndexPath:prjTreeIndexPath];
            
            //[parentProjectListViewController.prjTreeController insertObject:prj atArrangedObjectIndexPath:prjTreeIndexPath];
            
            
            /*if (prj.parentProjectId) {
             [parentProjectListViewController.prjTreeController remove:project];
             
             NSIndexPath *indexPath = [parentProjectListViewController.prjTreeController selectionIndexPath];
             
             [parentProjectListViewController.prjTreeController insertObject:prj atArrangedObjectIndexPath:[indexPath indexPathByAddingIndex:0]];
             
             } else {
             [[parentProjectListViewController mutableArrayValueForKey:@"arrPrj"] replaceObjectAtIndex:[parentProjectListViewController.arrPrj indexOfObject:project] withObject:prj];
             }*/
            
            
            // reassign user with user returned from web-service.
            //self.project = prj;
            //self.project = [prj copy];
            self.project.projectId = [[NSNumber alloc] initWithInt:[prj.projectId intValue]];
            self.project = prj;
            
            //NSLog(@"projectid: %@", self.project.projectId);
            //NSLog(@"projectid: %d", [prj.projectId intValue]);
            
            //NSLog(@"id: %d", [prj.projectId intValue]);
            //NSLog(@"title: %@", prj.projectTitle);
        }
    }
    
    // close this window.
    //[self close];
}

@end
