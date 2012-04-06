//
//  PTProjectDetailsViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 2/4/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "MainWindowController.h"
#import "PTClientHelper.h"
#import "PTProjectDetailsViewController.h"
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

@synthesize availableUsergroups;
@synthesize availableUsergroupsArrayCtrl;
@synthesize availableUsers;
@synthesize availableUsersArrayCtrl;
@synthesize tabTaskView;
@synthesize availableClients;
@synthesize availableClientsArrayCtrl;

@synthesize mainWindowController;

@synthesize taskListViewController;

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
    //[taskListViewController.outlineViewProjetColumn setHidden:YES];
    //[taskListViewController.projectButton removeFromSuperview];
    [taskListViewController.projectButton setHidden:YES];
}

- (IBAction)startDateRealCalendarButtonClicked:(id)sender {
    
    // si bouton clicked...
    if (self.startDateRealCalendarButton.intValue == 1) {
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
        [self.calendarPopover showRelativeToRect:[endDateRealCalendarButton bounds]
                                          ofView:endDateRealCalendarButton
                                   preferredEdge:NSMaxYEdge];
    } else {
        [self.calendarPopover close];
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

@end
