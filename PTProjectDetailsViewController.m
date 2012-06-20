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
#import "Role.h"
#import "Usergroup.h"
#import "PTCommon.h"



@implementation PTProjectDetailsViewController

@synthesize projectViewController;
@synthesize prjTreeController;
@synthesize tabView;

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
@synthesize comboDevelopers;
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

@synthesize arrDevelopers;

@synthesize assignedClients;
@synthesize assignedClientsArrayCtrl;

@synthesize assignedUsers;
@synthesize assignedUsersArrayCtrl;

@synthesize assignedUsergroups;
@synthesize assignedUsersgroupsArrayCtrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"PTProjectDetailsView" bundle:nibBundleOrNil];
    if (self) {
        
        // Initialization code here.
        
        assignedUsers = [[NSMutableArray alloc] init];
        assignedUsergroups = [[NSMutableArray alloc] init];
        assignedClients = [[NSMutableArray alloc] init];
        
        // initialiser l'array qui contient les groupes d'utilisateurs disponibles.
        availableUsergroups = [[NSMutableArray alloc] init];
        // initialiser l'array qui contient les utilisateurs disponibles.
        availableUsers = [[NSMutableArray alloc] init];
        // initialiser l'array qui contient les clients disponibles.
        availableClients = [[NSMutableArray alloc] init];
        
        arrDevelopers = [[NSMutableArray alloc] init];
        
        // faire une copie du projet en cours.
        projectCopy = [[Project alloc] init];
        projectCopy = [project copy];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    // cacher l'onglet 'Activité'.
    activityTab = [tabView tabViewItemAtIndex:7];
    [tabView removeTabViewItem:activityTab];
    
    [self showClientAndVisibilityTab];
    
    // charger la liste des développeurs à partir du webservice et les mettre dans la combobox.
    [self fetchDevelopersFromWebservice];
}

// affiche l'onglet 'Visibilité' et 'Client(s)' si l'utilisateur authentifié est un développeur ou administrateur.
- (void)showClientAndVisibilityTab {
    
    for (Role *r in mainWindowController.mainWindowViewController.currentUserRoles) {
        
        // if user is in administrator role, add the admin menu to the sidebar.
        if ([r.code isEqualToString:@"administrator"] == NO && [r.code isEqualToString:@"developer"] == NO) {
            
            visibilityTab = [tabView tabViewItemAtIndex:4];
            [tabView removeTabViewItem:visibilityTab];
            clientTab = [tabView tabViewItemAtIndex:4];
            [tabView removeTabViewItem:clientTab];
            
            // charger la liste des utilisateurs pour lesquelles le projet est visible. 
            [self loadUserVisibility];
        }
    }
}

- (void)loadClientVisibility {
    
    // remove users already affected to user from available users list.
    for (Client *c in assignedClients) {
        
        for (NSUInteger i = 0; i < [availableClients count]; i++) {
            
            // if user found.
            if ([[availableClients objectAtIndex:i] isEqual:c]) {
                
                // remove user.
                [[self mutableArrayValueForKey:@"availableClients"] removeObjectAtIndex:i];
            }
        }
    }
}

- (void)loadUserVisibility {
    
    // remove users already affected to user from available users list.
    for (User *u in assignedUsers) {
        
        for (NSUInteger i = 0; i < [availableUsers count]; i++) {
            
            // if user found.
            if ([[availableUsers objectAtIndex:i] isEqual:u]) {
                
                // remove user.
                [[self mutableArrayValueForKey:@"availableUsers"] removeObjectAtIndex:i];
            }
        }
    }
}

- (void)loadUsergroupVisibility {
    
    // remove users already affected to user from available users list.
    for (User *u in assignedUsergroups) {
        
        for (NSUInteger i = 0; i < [availableUsergroups count]; i++) {
            
            // if user found.
            if ([[availableUsergroups objectAtIndex:i] isEqual:u]) {
                
                // remove user.
                [[self mutableArrayValueForKey:@"availableUsergroups"] removeObjectAtIndex:i];
            }
        }
    }
}

// charger les utilisateurs, groupes et clients liés au projet.
- (void)loadProjectDetails {
    
    // charger la liste des groupes d'utilisateurs disponibles.
    [self fetchAvailableUsergroups];
    [self fetchAssignedUsergroups];
    // charger la liste des utilisateurs disponibles.
    [self fetchAvailableUsers];
    [self fetchAssignedUsers];
    // charger la liste des clients disponibles.
    [self fetchAvailableClients];
    [self fetchAssignedClients];
    
    
    //[self loadTasks];
    //[self loadComments];
    //[self loadBugs];
    
    //commentViewController.mainWindowController = mainWindowController;
    commentViewController.project = [self project];
    [commentViewController loadComments];
    
    // load tasks for selected project. 
    if (project.projectId) {
        // tasks.
        NSString *urlString = [NSString stringWithString:@"resources/tasks/?projectId="];
        urlString = [urlString stringByAppendingString:[project.projectId stringValue]];
     
        taskListViewController.taskURL = urlString;
    
        [taskListViewController loadTasks];
        
        
        // bugs.
        urlString = [NSString stringWithString:@"resources/bugs/?projectId="];
        urlString = [urlString stringByAppendingString:[project.projectId stringValue]];
        
        bugListViewController.bugURL = urlString;
        
        [bugListViewController loadBugs];
    }
    
}

- (void)loadTasks {
    taskListViewController = [[PTTaskListViewController alloc] initWithNibName:@"PTTaskListView" bundle:nil];
    
    if (project.projectId) {
        // tasks.
        NSString *urlString = [NSString stringWithString:@"resources/tasks/?projectId="];
        urlString = [urlString stringByAppendingString:[project.projectId stringValue]];
        
        taskListViewController.taskURL = urlString;
    }
    
    // get URL du serveur. 
    /*NSString *urlString = [PTCommon serverURLString];
    urlString = [urlString stringByAppendingString:@"resources/tasks/?projectId="];
    urlString = [urlString stringByAppendingString:[project.projectId stringValue]];
    
    taskListViewController.taskURL = urlString;*/
    
    // set reference to (parent) window
    [taskListViewController setMainWindowController:mainWindowController];
    
    // set reference to (parent) project details view.
    [taskListViewController setParentProjectDetailsViewController:self];
    
    // resize the view to fit and fill the right splitview view
    [taskListViewController.view setFrameSize:tabTaskView.frame.size];
    
    [self.tabTaskView addSubview:taskListViewController.view];
    
    // auto resize the view.
    [taskListViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    // cacher la colonne "projet".
    [taskListViewController.outlineViewProjetColumn setHidden:YES];
    [taskListViewController.checkBoxShowTasksFromSubProjects setHidden:NO];
    //[taskListViewController.projectButton removeFromSuperview];
    [taskListViewController.projectButton setHidden:YES];
    // afficher champ de recherche.
    [taskListViewController.searchField setHidden:NO];
}

- (void)loadBugs {
    bugListViewController = [[PTBugListViewController alloc] initWithNibName:@"PTBugListView" bundle:nil];
    
    if (project.projectId) {
        // bugs.
        NSString *urlString = [NSString stringWithString:@"resources/bugs/?projectId="];
        urlString = [urlString stringByAppendingString:[project.projectId stringValue]];
        
        bugListViewController.bugURL = urlString;
    }
    
    // set reference to (parent) window
    [bugListViewController setMainWindowController:mainWindowController];
    
    // set reference to (parent) project details view.
    [bugListViewController setParentProjectDetailsViewController:self];
    
    // resize the view to fit and fill the right splitview view
    [bugListViewController.view setFrameSize:tabBugView.frame.size];
    
    [self.tabBugView addSubview:bugListViewController.view];
    
    [bugListViewController.projectButton setHidden:YES];
    
    // auto resize the view.
    [bugListViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
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
}

- (IBAction)startDateRealCalendarButtonClicked:(id)sender {
    
    // si bouton clicked...
    if (self.startDateRealCalendarButton.intValue == 1) {
        
        // binder la propriété 'value' du datepicker avec la propriété correspondante de l'objet 'projet'. 
        MWCalendarViewController *calView = (MWCalendarViewController *)calendarPopover.contentViewController;
        [calView.datePicker bind:@"value" toObject:self withKeyPath:@"project.startDateReal" options:nil];
        
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
    
    if ([comboDevelopers indexOfSelectedItem] > -1) {
        User *selectedDev = [arrDevelopers objectAtIndex:[comboDevelopers indexOfSelectedItem]];
        
        project.userAssigned = selectedDev;
    } else {
        project.userAssigned = nil;
    }
    
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

- (IBAction)assignUser:(id)sender {
    // get selection of users to be affected to usergroup.
    NSArray *selectedUsers = [availableUsersArrayCtrl selectedObjects];
    
    for (User *user in selectedUsers) {
        
        if (!assignedUsers) {
            assignedUsers = [[NSMutableArray alloc] init];
        }
        
        // affect new user to usergroup.
        [assignedUsersArrayCtrl addObject:user];
        
        // remove user from available users.
        [availableUsersArrayCtrl removeObject:user];
        
        // sort user roles alphabetically.
        [assignedUsers sortUsingComparator:^NSComparisonResult(User *u1, User *u2) {
            
            return [u1.username compare:u2.username];
        }]; 
    }
    
    [self updateUserVisibility];
}

- (IBAction)removeUser:(id)sender {
    // get selection of users to be removed from usergroup.
    NSArray *selectedUsers = [assignedUsersArrayCtrl selectedObjects];
    
    for (User *user in selectedUsers) {
        // make usergroup available.
        [availableUsersArrayCtrl addObject:user];
        
        // remove usergroup from user's usergroups.
        [assignedUsersArrayCtrl removeObject:user];
        
        // sort user groups alphabetically.
        [availableUsers sortUsingComparator:^NSComparisonResult(User *u1, User *u2) {
            
            return [u1.username compare:u2.username];
        }];
    }
    
    [self updateUserVisibility];
}

- (IBAction)assignGroup:(id)sender {
    // get selection of users to be affected to usergroup.
    NSArray *selectedUsergroups = [availableUsergroupsArrayCtrl selectedObjects];
    
    for (Usergroup *usergroup in selectedUsergroups) {
        
        if (!assignedUsergroups) {
            assignedUsergroups = [[NSMutableArray alloc] init];
        }
        
        // affect new user to usergroup.
        [assignedUsersgroupsArrayCtrl addObject:usergroup];
        
        // remove user from available users.
        [availableUsergroupsArrayCtrl removeObject:usergroup];
        
        // sort user roles alphabetically.
        [assignedUsergroups sortUsingComparator:^NSComparisonResult(Usergroup *u1, Usergroup *u2) {
            
            return [u1.code compare:u2.code];
        }];
    }
    
    [self updateUsergroupVisibility];
}

- (IBAction)removeGroup:(id)sender {
    // get selection of users to be removed from usergroup.
    NSArray *selectedUsergroups = [assignedUsersgroupsArrayCtrl selectedObjects];
    
    for (Usergroup *usergroup in selectedUsergroups) {
        // make usergroup available.
        [availableUsergroupsArrayCtrl addObject:usergroup];
        
        // remove usergroup from user's usergroups.
        [assignedUsersgroupsArrayCtrl removeObject:usergroup];
        
        // sort user groups alphabetically.
        [availableUsergroups sortUsingComparator:^NSComparisonResult(Usergroup *u1, Usergroup *u2) {
            
            return [u1.code compare:u2.code];
        }];
    }
    
    [self updateUsergroupVisibility];
}

- (IBAction)assignClient:(id)sender {
    // get selection of users to be affected to usergroup.
    NSArray *selectedClients = [availableClientsArrayCtrl selectedObjects];
    
    for (Client *client in selectedClients) {
        
        if (!assignedClients) {
            assignedClients = [[NSMutableArray alloc] init];
        }
        
        // affect new user to usergroup.
        [assignedClientsArrayCtrl addObject:client];
        
        // remove user from available users.
        [availableClientsArrayCtrl removeObject:client];
        
        // sort user roles alphabetically.
        [assignedClients sortUsingComparator:^NSComparisonResult(Client *c1, Client *c2) {
            
            return [c1.clientName compare:c2.clientName];
        }];
    }
    
    [self updateClientVisibility];
}

- (IBAction)removeClient:(id)sender {
    // get selection of users to be removed from usergroup.
    NSArray *selectedClients = [assignedClientsArrayCtrl selectedObjects];
    
    for (Client *client in selectedClients) {
        // make usergroup available.
        [availableClientsArrayCtrl addObject:client];
        
        // remove usergroup from user's usergroups.
        [assignedClientsArrayCtrl removeObject:client];
        
        // sort user groups alphabetically.
        [availableClients sortUsingComparator:^NSComparisonResult(Client *c1, Client *c2) {
            
            return [c1.clientName compare:c2.clientName];
        }];
    }
    
    [self updateClientVisibility];
}

- (void)fetchAssignedClients {
    
    [[self mutableArrayValueForKey:@"assignedClients"] removeAllObjects];
    [[self mutableArrayValueForKey:@"availableClients"] removeAllObjects];
    
    // fetch usergroup's users.
    [PTClientHelper clientsVisibleForProject:project successBlock:^(NSMutableArray *clients) {
        
        // sort user roles alphabetically.
        [clients sortUsingComparator:^NSComparisonResult(Client *c1, Client *c2) {
            
            return [c1.clientName compare:c2.clientName];
        }];
        
        [[self mutableArrayValueForKey:@"assignedClients"] addObjectsFromArray:clients];
        
        [self loadClientVisibility];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)fetchAssignedUsers {
    
    [[self mutableArrayValueForKey:@"assignedUsers"] removeAllObjects];
    [[self mutableArrayValueForKey:@"availableUsers"] removeAllObjects];
    
    // fetch usergroup's users.
    [PTUserHelper usersVisibleForProject:project successBlock:^(NSMutableArray *users) {
        
        // sort user roles alphabetically.
        [users sortUsingComparator:^NSComparisonResult(User *u1, User *u2) {
            
            return [u1.username compare:u2.username];
        }];
        
        [[self mutableArrayValueForKey:@"assignedUsers"] addObjectsFromArray:users];
        
        [self loadUserVisibility];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)fetchAssignedUsergroups {
    
    [[self mutableArrayValueForKey:@"assignedUsergroups"] removeAllObjects];
    [[self mutableArrayValueForKey:@"availableUsergroups"] removeAllObjects];
    
    // fetch usergroup's users.
    [PTUsergroupHelper usergroupsVisibleForProject:project successBlock:^(NSMutableArray *usergroups) {
        
        // sort user roles alphabetically.
        [usergroups sortUsingComparator:^NSComparisonResult(Usergroup *u1, Usergroup *u2) {
            
            return [u1.code compare:u2.code];
        }];
        
        [[self mutableArrayValueForKey:@"assignedUsergroups"] addObjectsFromArray:usergroups];
        
        [self loadUsergroupVisibility];
        
    } failureBlock:^(NSError *error) {
        
    }];
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
        
        [self loadUserVisibility];
        
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
    
    // à partir du dictionnaire, créer un objet Projet et le rajouter à l'array. 
    [createdProjectArray addObjectsFromArray:[PTProjectHelper setAttributesFromJSONDictionary:dict]];
    
    NSLog(@"count: %lu", [createdProjectArray count]);
    
    if ([createdProjectArray count] == 1) {
        
        for (Project *prj in createdProjectArray) {
            
            // reassign user with user returned from web-service.
            self.project.projectId = [[NSNumber alloc] initWithInt:[prj.projectId intValue]];
            self.project = prj;
        }
    }
}

// charger la liste des développeurs à partir du webservice et les mettre dans la combobox.
- (void)fetchDevelopersFromWebservice
{
    // get developers from webservice.
    [PTUserHelper developers:^(NSMutableArray *developers) {
        
        // sort descriptors for array.
        NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fullNameAndUsername"
                                                                        ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
        
        // sort array and affect fetched array to local array.
        [[self mutableArrayValueForKey:@"arrDevelopers"] addObjectsFromArray:[developers sortedArrayUsingDescriptors:sortDescriptors]];
        
        // sélectionner développeur attribué (responsable du projet).
        for (NSInteger i = 0; i < [arrDevelopers count]; i++) {
            
            User *u = [arrDevelopers objectAtIndex:i];
            
            if ([u.userId intValue] == [project.userAssigned.userId intValue]) {
                
                [comboDevelopers selectItemAtIndex:i];
                break;
            }
        }
    }
                failureBlock:^(NSError *error) {
                    
                }];
}

// update user's usergroups (in database).
- (BOOL)updateUserVisibility {
    
    BOOL success;
    
    // Initialize a new array to hold the roles.
    NSMutableArray *usersArray = [[NSMutableArray alloc] init];
    
    // add (assigned) user roles to the array.
    for (User *user in assignedUsers) {
        
        NSDictionary *tmpUserDict = [user dictionaryWithValuesForKeys:[user userIdKey]];
        
        [usersArray addObject:tmpUserDict];
    }
    
    // create a new dictionary which holds the users.
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:usersArray forKey:@"user"];
    
    //
    // update usergroups in database via web service.
    success = [PTProjectHelper updateUsersVisibleForProject:project users:dict successBlock:^(NSMutableData *data) {[self finishedUpdatingUsersVisible:data];} failureBlock:^(NSError *error) {[self failedUpdatingUsersVisible:error];}];
    
    return success;
}

- (void)failedUpdatingUsersVisible:(NSError *)failure {
    
}

- (void)finishedUpdatingUsersVisible:(NSMutableData *)data {

}


- (BOOL)updateUsergroupVisibility {
    
    BOOL success;
    
    // Initialize a new array to hold the roles.
    NSMutableArray *usergroupsArray = [[NSMutableArray alloc] init];
    
    // add (assigned) user roles to the array.
    for (Usergroup *usergroup in assignedUsergroups) {
        
        NSDictionary *tmpUsergroupDict = [usergroup dictionaryWithValuesForKeys:[usergroup updateUsergroupsKeys]];
        
        [usergroupsArray addObject:tmpUsergroupDict];
    }
    
    // create a new dictionary which holds the users.
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:usergroupsArray forKey:@"usergroup"];
    
    // update usergroups in database via web service.
    success = [PTProjectHelper updateUsergroupsVisibleForProject:project usergroups:dict successBlock:^(NSMutableData *data) {[self finishedUpdatingUsergroupsVisible:data];} failureBlock:^(NSError *error) {[self failedUpdatingUsergroupsVisible:error];}];
    
    return success;
}

- (void)failedUpdatingUsergroupsVisible:(NSError *)failure {
    
}

- (void)finishedUpdatingUsergroupsVisible:(NSMutableData *)data {

}


- (BOOL)updateClientVisibility {
    
    BOOL success;
    
    // Initialize a new array to hold the roles.
    NSMutableArray *clientsArray = [[NSMutableArray alloc] init];
    
    // add (assigned) user roles to the array.
    for (Client *client in assignedClients) {
        
        NSDictionary *tmpClientDict = [client dictionaryWithValuesForKeys:[client updateClientsKeys]];
        
        [clientsArray addObject:tmpClientDict];
    }
    
    // create a new dictionary which holds the users.
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:clientsArray forKey:@"client"];
    
    // update usergroups in database via web service.
    success = [PTProjectHelper updateClientsVisibleForProject:project clients:dict successBlock:^(NSMutableData *data) {[self finishedUpdatingClientsVisible:data];} failureBlock:^(NSError *error) {[self failedUpdatingClientsVisible:error];}];
    
    return success;
}

- (void)failedUpdatingClientsVisible:(NSError *)failure {
    
}

- (void)finishedUpdatingClientsVisible:(NSMutableData *)data {
    
}

@end
