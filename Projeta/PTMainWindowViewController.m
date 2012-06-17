//
//  PTMainWindowViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 13/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "PTMainWindowViewController.h"
#import "SourceListItem.h"
#import "MainWindowController.h"
#import "MWConnectionController.h"
#import "PTBugCategoryManagementViewController.h"
#import "PTBugListViewController.h"
#import "PTClientManagementViewController.h"
#import "PTCommon.h"
#import "PTRoleHelper.h"
#import "PTUserHelper.h"
#import "PTGroupManagementViewController.h"
#import "PTUserManagementViewController.h"
#import "Role.h"
#import "PTTaskListViewController.h"

// array which holds the user roles of the connected user.
static NSMutableArray *_currentUserRoles = nil;
// logged in User.
static User *_loggedInUser = nil;

SourceListItem *bugsHeaderItem;
SourceListItem *bugsItem;

SourceListItem *projectsHeaderItem;
SourceListItem *projectsItem;
SourceListItem *projectsPublicItem;

SourceListItem *tasksHeaderItem;
SourceListItem *tasksItem;
SourceListItem *personalTasksItem;

@implementation PTMainWindowViewController

@synthesize sourceList;
@synthesize splitView;
@synthesize leftView;
@synthesize rightView;
// reference to the (parent) MainWindowController
@synthesize mainWindowController;

@synthesize projectListViewController;
@synthesize taskListViewController;
@synthesize bugListViewController;
@synthesize userManagementViewController;
@synthesize groupManagementViewController;
@synthesize clientManagementViewController;
@synthesize bugCategoryManagementViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self = [super initWithNibName:@"PTMainWindowView" bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
        // Register observer to be notified when value for _currentUserRoles array changes.
        [self addObserver:self forKeyPath:@"_currentUserRoles" options:0 context:nil];
    }
    
    return self;
}

- (void)dealloc
{
    // remove the observer.
    [self removeObserver:self forKeyPath:@"_currentUserRoles"];
}

// handle observer events
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change 
                      context:(void *)context {
    
    // if value for _currentUserRoles array changes. 
    if ( [keyPath isEqualToString:@"_currentUserRoles"] ) {
        
        // afficher points de menu supplémentaires si l'utilisateur est un administrateur ou développeur.
        [self showBugMenuByUserRole];
        [self showProjectMenuByUserRole];
        [self showTaskMenuByUserRole];
        
        // Afficher menu administrateur si l'utilisateur est un administrateur.
        [self showAdminMenu];
    }
}

- (void)loadView
{
    [super loadView];
    
    // initialize the sidebar (sourcelist)
    [self initializeSidebar];
    
    // expand tâches.
    [sourceList expandItem:[sourceListItems objectAtIndex:1]];
    // expand bugs.
    [sourceList expandItem:[sourceListItems objectAtIndex:2]];
    // expand messagerie.
    //[sourceList expandItem:[sourceListItems objectAtIndex:3]];
    
    [self removeViewsFromRightView];
    
    if (!projectListViewController) {
        
        projectListViewController = [[PTProjectListViewController alloc] initWithNibName:@"PTProjectListView" bundle:nil];
        
        projectListViewController.projectURL = @"resources/projects/public";
        
        // set reference to (parent) window
        [projectListViewController setMainWindowController:mainWindowController];
        
        // resize the view to fit and fill the right splitview view
        [projectListViewController.view setFrameSize:rightView.frame.size];
        
        [self.rightView addSubview:projectListViewController.view];
        
        // auto resize the view.
        [projectListViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    }
}

#pragma mark -
#pragma mark Source List Data Source Methods

- (NSUInteger)sourceList:(PXSourceList*)sourceList numberOfChildrenOfItem:(id)item
{
	//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return [sourceListItems count];
	}
	else {
		return [[item children] count];
	}
}


- (id)sourceList:(PXSourceList*)aSourceList child:(NSUInteger)index ofItem:(id)item
{
	//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return [sourceListItems objectAtIndex:index];
	}
	else {
		return [[item children] objectAtIndex:index];
	}
}

- (id)sourceList:(PXSourceList*)aSourceList objectValueForItem:(id)item
{
	return [item title];
}


- (void)sourceList:(PXSourceList*)aSourceList setObjectValue:(id)object forItem:(id)item
{
	[item setTitle:object];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList isItemExpandable:(id)item
{
	return [item hasChildren];
}

- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasBadge:(id)item
{
	return [item hasBadge];
}


- (NSInteger)sourceList:(PXSourceList*)aSourceList badgeValueForItem:(id)item
{
	return [item badgeValue];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasIcon:(id)item
{
	return [item hasIcon];
}


- (NSImage*)sourceList:(PXSourceList*)aSourceList iconForItem:(id)item
{
	return [item icon];
}

- (NSMenu*)sourceList:(PXSourceList*)aSourceList menuForEvent:(NSEvent*)theEvent item:(id)item
{
	if ([theEvent type] == NSRightMouseDown || ([theEvent type] == NSLeftMouseDown && ([theEvent modifierFlags] & NSControlKeyMask) == NSControlKeyMask)) {
		NSMenu __autoreleasing *m = [[NSMenu alloc] init];
		if (item != nil) {
			[m addItemWithTitle:[item title] action:nil keyEquivalent:@""];
		} else {
			[m addItemWithTitle:@"clicked outside" action:nil keyEquivalent:@""];
		}
		return m;
	}
	return nil;
}


#pragma mark -
#pragma mark Source List Delegate Methods

- (BOOL)sourceList:(PXSourceList*)aSourceList isGroupAlwaysExpanded:(id)group
{
	if([[group identifier] isEqualToString:@"projectsHeader"] || [[group identifier] isEqualToString:@"administrationHeader"])
		return YES;
	
	return NO;
}

- (void)sourceListSelectionDidChange:(NSNotification *)notification
{
	NSIndexSet *selectedIndexes = [sourceList selectedRowIndexes];
	
	//Set the label text to represent the new selection
	if([selectedIndexes count]>1)
    {
		//[selectedItemLabel setStringValue:@"(multiple)"];
    }
	else if([selectedIndexes count]==1) {
		NSString *identifier = [[sourceList itemAtRow:[selectedIndexes firstIndex]] identifier];
		
        if (identifier == @"projects" || identifier == @"projectsPublic" || identifier == @"projectsAssigned" || identifier == @"projectsParClientItem" || identifier == @"projectsParDeveloppeurItem") {
            
            [self removeViewsFromRightView];
            
            if (!projectListViewController) {
       
                //projectListViewController = [[PTProjectListViewController alloc] init];
                if (identifier == @"projects" || identifier == @"projectsPublic") 
                    projectListViewController = [[PTProjectListViewController alloc] initWithNibName:@"PTProjectListView" bundle:nil];
                else if (identifier == @"projectsParClientItem") 
                    projectListViewController = [[PTProjectListViewController alloc] initWithNibName:@"PTProjectListViewClient" bundle:nil];
                else if (identifier == @"projectsParDeveloppeurItem")
                    projectListViewController = [[PTProjectListViewController alloc] initWithNibName:@"PTProjectListViewDeveloper" bundle:nil];
                else if (identifier == @"projectsAssigned")
                    projectListViewController = [[PTProjectListViewController alloc] initWithNibName:@"PTProjectListViewAssigned" bundle:nil];
                
                if (identifier == @"projectsPublic")
                    projectListViewController.projectURL = @"resources/projects/public";
                else if (identifier == @"projectsAssigned")
                    projectListViewController.projectURL = @"resources/projects/assigned";
                
                // set reference to (parent) window
                [projectListViewController setMainWindowController:mainWindowController];
                
                // resize the view to fit and fill the right splitview view
                [projectListViewController.view setFrameSize:rightView.frame.size];
                
                [self.rightView addSubview:projectListViewController.view];
                
                // auto resize the view.
                [projectListViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
            }
        }
        else if (identifier == @"tasks" || identifier == @"tasksPersonal" || identifier == @"tasksAssigned" || identifier == @"tasksParClientItem" || identifier == @"tasksParDeveloppeurItem") {
            
            [self removeViewsFromRightView];
            
            if (!taskListViewController) {
                
                
                if (identifier == @"tasks" || identifier == @"tasksPersonal" || identifier == @"tasksAssigned") 
                    taskListViewController = [[PTTaskListViewController alloc] initWithNibName:@"PTTaskListView" bundle:nil];
                else if (identifier == @"tasksParClientItem") 
                    taskListViewController = [[PTTaskListViewController alloc] initWithNibName:@"PTTaskListViewClient" bundle:nil];
                else if (identifier == @"tasksParDeveloppeurItem") 
                    taskListViewController = [[PTTaskListViewController alloc] initWithNibName:@"PTTaskListViewDeveloper" bundle:nil];
                
                
                // tâche public.
                if (identifier == @"tasksPersonal") {
                    taskListViewController.isPersonalTask = YES;
                    // cacher la colonne 'projet'.
                    [taskListViewController.outlineViewProjetColumn setHidden:YES];
                }
                else
                    taskListViewController.isPersonalTask = NO;
                
                if (identifier == @"tasksAssigned")
                    taskListViewController.taskURL = @"resources/tasks/assigned";
                
                
                // set reference to (parent) window
                [taskListViewController setMainWindowController:mainWindowController];
                
                // resize the view to fit and fill the right splitview view
                [taskListViewController.view setFrameSize:rightView.frame.size];
                
                [self.rightView addSubview:taskListViewController.view];
                
                // auto resize the view.
                [taskListViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
                
                // hide add/remove buttons.
                if (identifier != @"tasks" && identifier != @"tasksPersonal") {
                    [taskListViewController.addTaskButton setHidden:YES];
                    [taskListViewController.removeTaskButton setHidden:YES];
                }
            }
        }
        else if (identifier == @"bugs" || identifier == @"bugsAssigned" || identifier == @"bugsParClientItem" || identifier == @"bugsParDeveloppeurItem") {
            
            [self removeViewsFromRightView];
            
            if (!bugListViewController) {
                
                if (identifier == @"bugs" || identifier == @"bugsAssigned") 
                    bugListViewController = [[PTBugListViewController alloc] initWithNibName:@"PTBugListView" bundle:nil];
                else if (identifier == @"bugsParClientItem") 
                     bugListViewController = [[PTBugListViewController alloc] initWithNibName:@"PTBugListViewClient" bundle:nil];
                else if (identifier == @"bugsParDeveloppeurItem") 
                     bugListViewController = [[PTBugListViewController alloc] initWithNibName:@"PTBugListViewDeveloper" bundle:nil];
                
                if (identifier == @"bugsAssigned")
                    bugListViewController.bugURL = @"resources/bugs/assigned";
                
                // set reference to (parent) window
                [bugListViewController setMainWindowController:mainWindowController];
                
                // resize the view to fit and fill the right splitview view
                [bugListViewController.view setFrameSize:rightView.frame.size];
                
                [self.rightView addSubview:bugListViewController.view];
                
                // ne pas afficher les boutons pour ajouter ou supprimer des bogues.
                [bugListViewController.addBugButton setHidden:YES];
                [bugListViewController.removeBugButton setHidden:YES];
                
                // auto resize the view.
                [bugListViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
            }
        }
        else if (identifier == @"userAdmin") {
            
            [self removeViewsFromRightView];
            
            if (!userManagementViewController) {
                
                userManagementViewController = [[PTUserManagementViewController alloc] init];
                
                // set reference to (parent) window
                [userManagementViewController setMainWindowController:mainWindowController];
                
                // resize the view to fit and fill the right splitview view
                [userManagementViewController.view setFrameSize:rightView.frame.size];
                
                [self.rightView addSubview:userManagementViewController.view];
                
                // auto resize the view.
                [userManagementViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
            }
        }
        else if (identifier == @"groupAdmin") {
            
            [self removeViewsFromRightView];
            
            if (!groupManagementViewController) {
                
                groupManagementViewController = [[PTGroupManagementViewController alloc] init];
                
                // set reference to (parent) window
                [groupManagementViewController setMainWindowController:mainWindowController];
                
                // resize the view to fit and fill the right splitview view
                [groupManagementViewController.view setFrameSize:rightView.frame.size];
                
                [self.rightView addSubview:groupManagementViewController.view];
                
                // auto resize the view.
                [groupManagementViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
            }
        }
        else if (identifier == @"clientAdmin") {
            
            [self removeViewsFromRightView];
            
            if (!clientManagementViewController) {
                
                clientManagementViewController = [[PTClientManagementViewController alloc] init];
                
                // set reference to (parent) window
                [clientManagementViewController setMainWindowController:mainWindowController];
                
                // resize the view to fit and fill the right splitview view
                [clientManagementViewController.view setFrameSize:rightView.frame.size];
                
                [self.rightView addSubview:clientManagementViewController.view];
                
                // auto resize the view.
                [clientManagementViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
            }
        }
        else if (identifier == @"bugCategoryAdmin") {
            
            [self removeViewsFromRightView];
            
            if (!bugCategoryManagementViewController) {
                
                bugCategoryManagementViewController = [[PTBugCategoryManagementViewController alloc] init];
                
                // set reference to (parent) window
                [bugCategoryManagementViewController setMainWindowController:mainWindowController];
                
                // resize the view to fit and fill the right splitview view
                [bugCategoryManagementViewController.view setFrameSize:rightView.frame.size];
                
                [self.rightView addSubview:bugCategoryManagementViewController.view];
                
                // auto resize the view.
                [bugCategoryManagementViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
            }
        }
        else {
            // free some memory
            [self removeViewsFromRightView];
        }
	}
	else {
		//[selectedItemLabel setStringValue:@"(none)"];
	}
}

- (void)removeViewsFromRightView
{
    if (projectListViewController) {
        [projectListViewController.view removeFromSuperview];
        projectListViewController = nil;
    }
    
    if (taskListViewController) {
        [taskListViewController.view removeFromSuperview];
        taskListViewController = nil;
    }
    
    if (bugListViewController) {
        [bugListViewController.view removeFromSuperview];
        bugListViewController = nil;
    }
    
    if (userManagementViewController) {
        [userManagementViewController.view removeFromSuperview];
        userManagementViewController = nil;
    }
    
    if (groupManagementViewController) {
        [groupManagementViewController.view removeFromSuperview];
        groupManagementViewController = nil;
    }
    
    if (clientManagementViewController) {
        [clientManagementViewController.view removeFromSuperview];
        clientManagementViewController = nil;
    }
    
    if (bugCategoryManagementViewController) {
        [bugCategoryManagementViewController.view removeFromSuperview];
        bugCategoryManagementViewController = nil;
    }
}


- (void)sourceListDeleteKeyPressedOnRows:(NSNotification *)notification
{
	NSIndexSet *rows = [[notification userInfo] objectForKey:@"rows"];
	
	NSLog(@"Delete key pressed on rows %@", rows);
	
	//Do something here
}


#pragma mark -
#pragma mark Initialize and populate sidebar

// initialize sidebar.
- (void)initializeSidebar
{
    sourceListItems = [[NSMutableArray alloc] init];
	
	// Point de menu 'PROJETS'.
    projectsHeaderItem = [SourceListItem itemWithTitle:NSLocalizedString(@"PROJETS", nil) identifier:@"projectsHeader"];
	projectsItem = [SourceListItem itemWithTitle:@"Projets" identifier:@"projects"];
    projectsPublicItem = [SourceListItem itemWithTitle:@"Publics" identifier:@"projectsPublic"];

    [projectsHeaderItem setChildren:[NSArray arrayWithObjects:projectsItem, projectsPublicItem, nil]];
    
	
	// Point de menu 'TÂCHES'.
	tasksHeaderItem = [SourceListItem itemWithTitle:@"TÂCHES" identifier:@"tasksHeader"];
    // all tasks
    tasksItem = [SourceListItem itemWithTitle:@"Tâches" identifier:@"tasks"];
    personalTasksItem = [SourceListItem itemWithTitle:@"Personnels" identifier:@"tasksPersonal"];
    
    [tasksHeaderItem setChildren:[NSArray arrayWithObjects:tasksItem, personalTasksItem, nil]];
    
    // Point de menu 'BOGUES'.
	bugsHeaderItem = [SourceListItem itemWithTitle:@"BOGUES" identifier:@"bugsHeader"];
    bugsItem = [SourceListItem itemWithTitle:@"Bogues" identifier:@"bugs"];
    
    [bugsHeaderItem setChildren:[NSArray arrayWithObjects:bugsItem, nil]];
    
    
	
	[sourceListItems addObject:projectsHeaderItem];
	[sourceListItems addObject:tasksHeaderItem];
    [sourceListItems addObject:bugsHeaderItem];
	
	[sourceList reloadData];
    
    
    // charger l'infos de l'utilisateur authentifié (données utilisateur et rôles).
    [self loggedInUserInitializations];
}

// fetch logged in user its roles from web service.
- (void)loggedInUserInitializations {
    
    // start animating the main window's circular progress indicator.
    [mainWindowController startProgressIndicatorAnimation];
    
    
    if (!_loggedInUser) {
        // get server URL as string
        NSString *urlString = [PTCommon serverURLString];
        // build URL by adding resource path
        //urlString = [urlString stringByAppendingString:@"resources/be.luckycode.projetawebservice.users/getLoggedInUser"];
        urlString = [urlString stringByAppendingString:@"resources/users/"];
        
        // convert to NSURL
        NSURL *url = [NSURL URLWithString:urlString];
        
        // NSURLConnection - MWConnectionController
        MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                        initWithSuccessBlock:^(NSMutableData *data) {
                                                            [self loggedInUserInitializationsRequestFinished:data];
                                                        }
                                                        failureBlock:^(NSError *error) {
                                                            [self loggedInUserInitializationsRequestFailed:error];
                                                        }];
        
        
        NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
        
        [connectionController startRequestForURL:url setRequest:urlRequest];
    } else {
        [self showAdminMenu];
        
        // stop animating the main window's circular progress indicator.
        [mainWindowController stopProgressIndicatorAnimation];
    }
}

- (void)loggedInUserInitializationsRequestFinished:(NSMutableData*)data {
    NSError *error;
    
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSMutableArray *loggedInUserArr = [[NSMutableArray alloc] init];
    
    // créer un utilisateur à partir du dictionnaire et l'ajouter dans l'array.
    [loggedInUserArr addObjectsFromArray:[PTUserHelper setAttributesFromJSONDictionary:dict]];
    
    if ([loggedInUserArr count] == 1) {
        for (User *usr in loggedInUserArr) {
            _loggedInUser = usr;
            
            mainWindowController.loggedInUser = usr;
            
            // fetch user roles of logged in user from webservice
            [self userRoleInitializations];
        }
    }
    
    // stop animating the main window's circular progress indicator.
    [mainWindowController stopProgressIndicatorAnimation];
}
- (void)loggedInUserInitializationsRequestFailed:(NSError*)error {
    // stop animating the main window's circular progress indicator.
    [mainWindowController stopProgressIndicatorAnimation];
}

// fetch the logged in user's roles from web service.
// This method is being called at the end of loggedInUserInitializations method.
// There's usually no need to call this method alone. 
// Use loggedInUserInitializations instead or call it at least once before
// calling userRoleInitializations.
- (void)userRoleInitializations
{
    // start animating the main window's circular progress indicator.
    [mainWindowController startProgressIndicatorAnimation];
    
    if (!_currentUserRoles) {
        
        /*User *usr = [PTUserHelper loggedInUser];
        
        [self showAdminMenu];*/
        
        _currentUserRoles = [[NSMutableArray alloc] init];
                
        // get server URL as string
        NSString *urlString = [PTCommon serverURLString];
        // build URL by adding resource path
        /*
        urlString = [urlString stringByAppendingString:@"resources/be.luckycode.projetawebservice.users/username/"];
        urlString = [urlString stringByAppendingString:[_loggedInUser username]];
        urlString = [urlString stringByAppendingString:@"/roles"];
        */
        urlString = [urlString stringByAppendingString:@"resources/roles"];
        
        // convert to NSURL
        NSURL *url = [NSURL URLWithString:urlString];
        
        
        // NSURLConnection - MWConnectionController
        MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                        initWithSuccessBlock:^(NSMutableData *data) {
                                                            [self userRoleInitializationsRequestFinished:data];
                                                        }
                                                        failureBlock:^(NSError *error) {
                                                            [self userRoleInitializationsRequestFailed:error];
                                                        }];
        
        
        NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
        
        [connectionController startRequestForURL:url setRequest:urlRequest];
        
        
    } else {
        [self showAdminMenu];
        
        // stop animating the main window's circular progress indicator.
        [mainWindowController stopProgressIndicatorAnimation];
    }
}

- (void)userRoleInitializationsRequestFinished:(NSMutableData*)data {
    NSError *error;
    
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];

    [self willChangeValueForKey:@"_currentUserRoles"];
    [_currentUserRoles addObjectsFromArray:[PTRoleHelper setAttributesFromJSONDictionary:dict]];
    [self didChangeValueForKey:@"_currentUserRoles"];
    
    // stop animating the main window's circular progress indicator.
    [mainWindowController stopProgressIndicatorAnimation];
}

- (void)userRoleInitializationsRequestFailed:(NSError*)error {
    
    // stop animating the main window's circular progress indicator.
    [mainWindowController stopProgressIndicatorAnimation];
}

// affiche le menu administrateur si l'utilisateur authentifié appartient au role 'administrator'.
- (void)showAdminMenu {
    
    for (Role *r in _currentUserRoles) {
    //for (Role *r in [PTUserHelper currentUserRoles]) {
        
        // if user is in administrator role, add the admin menu to the sidebar.
        if ([r.code isEqualToString:@"administrator"])
        {
            SourceListItem *administrationHeaderItem = [SourceListItem itemWithTitle:NSLocalizedString(@"ADMINISTRATION", nil) identifier:@"administrationHeader"];
            
            // user admin.
            SourceListItem *userAdminItem = [SourceListItem itemWithTitle:NSLocalizedString(@"Utilisateurs", nil) identifier:@"userAdmin"];
            // group admin.
            SourceListItem *groupAdminItem = [SourceListItem itemWithTitle:NSLocalizedString(@"Groupes", nil) identifier:@"groupAdmin"];
            // clients admin.
            SourceListItem *clientAdminItem = [SourceListItem itemWithTitle:NSLocalizedString(@"Clients", nil) identifier:@"clientAdmin"];
            // type de bogue.
            SourceListItem *bugCategoryAdminItem = [SourceListItem itemWithTitle:NSLocalizedString(@"Types de bogue", nil) identifier:@"bugCategoryAdmin"];
            
            [administrationHeaderItem setChildren:[NSArray arrayWithObjects:userAdminItem, groupAdminItem, clientAdminItem, bugCategoryAdminItem, nil]];
            
            [sourceListItems addObject:administrationHeaderItem];
            
            [sourceList reloadData];
        }
    }
}

// afficher points de menu supplémentaires sous 'BOGUES' si l'utilisateur est un administrateur ou développeur.
- (void)showBugMenuByUserRole {
    
    for (Role *r in _currentUserRoles) {
        
        // if user is in administrator role, add the admin menu to the sidebar.
        if ([r.code isEqualToString:@"administrator"] || [r.code isEqualToString:@"developer"]) {
            SourceListItem *bugsAssignedItem = [SourceListItem itemWithTitle:@"Assignés" identifier:@"bugsAssigned"];
            SourceListItem *bugsParClientItem = [SourceListItem itemWithTitle:@"Par client" identifier:@"bugsParClientItem"];
            SourceListItem *bugsParDeveloppeurItem = [SourceListItem itemWithTitle:@"Par développeur" identifier:@"bugsParDeveloppeurItem"];
            
            [bugsHeaderItem setChildren:[NSArray arrayWithObjects:bugsItem, bugsAssignedItem, bugsParClientItem, bugsParDeveloppeurItem, nil]];
        }
    }
    
    [sourceList reloadData];
}

// afficher points de menu supplémentaires sous 'PROJETS' si l'utilisateur est un administrateur ou développeur.
- (void)showProjectMenuByUserRole {
    
    for (Role *r in _currentUserRoles) {
        
        // if user is in administrator role, add the admin menu to the sidebar.
        if ([r.code isEqualToString:@"administrator"] || [r.code isEqualToString:@"developer"]) {
            SourceListItem *projectsAssignedItem = [SourceListItem itemWithTitle:@"Assignés" identifier:@"projectsAssigned"];
            SourceListItem *projectsParClientItem = [SourceListItem itemWithTitle:@"Par client" identifier:@"projectsParClientItem"];
            SourceListItem *projectsParDeveloppeurItem = [SourceListItem itemWithTitle:@"Par responsable" identifier:@"projectsParDeveloppeurItem"];
            
            [projectsHeaderItem setChildren:[NSArray arrayWithObjects:projectsItem, projectsPublicItem, projectsAssignedItem, projectsParClientItem, projectsParDeveloppeurItem, nil]];
        }
    }
    
    [sourceList reloadData];
}

// afficher points de menu supplémentaires sous 'TÂCHES' si l'utilisateur est un administrateur ou développeur.
- (void)showTaskMenuByUserRole {
    
    for (Role *r in _currentUserRoles) {
        
        // if user is in administrator role, add the admin menu to the sidebar.
        if ([r.code isEqualToString:@"administrator"] || [r.code isEqualToString:@"developer"]) {
            SourceListItem *tasksAssignedItem = [SourceListItem itemWithTitle:@"Assignés" identifier:@"tasksAssigned"];
            SourceListItem *tasksParClientItem = [SourceListItem itemWithTitle:@"Par client" identifier:@"tasksParClientItem"];
            SourceListItem *tasksParDeveloppeurItem = [SourceListItem itemWithTitle:@"Par développeur" identifier:@"tasksParDeveloppeurItem"];
            
            [tasksHeaderItem setChildren:[NSArray arrayWithObjects:tasksItem, personalTasksItem, tasksAssignedItem, tasksParClientItem, tasksParDeveloppeurItem, nil]];
            
            mainWindowController.hideAdminControls = NO;
        }
    }
    
    [sourceList reloadData];
}


#pragma mark -
#pragma mark View resizing

// properly resize the splitview (only resize right view, don't touch the left one)
- (void)splitView:(NSSplitView *)sender resizeSubviewsWithOldSize:(NSSize)oldSize
{
    // IB outlets
    // IBOutlet NSView *leftView;
    // IBOutlet NSView *rightView;
    NSSize splitViewSize = [sender frame].size;
    
    NSSize leftSize = [leftView frame].size;
    leftSize.height = splitViewSize.height;
    
    NSSize rightSize;
    rightSize.height = splitViewSize.height;
    rightSize.width = splitViewSize.width - [sender dividerThickness] - leftSize.width;
    
    [leftView setFrameSize:leftSize];
    [rightView setFrameSize:rightSize];
}


#pragma mark -
#pragma mark Gestures handling (trackpad and mouse events)

//- (BOOL)wantsScrollEventsForSwipeTrackingOnAxis:(NSEventGestureAxis)axis 
//{
//    return (axis == NSEventGestureAxisHorizontal) ? YES : NO;
//}
//
//- (void)scrollWheel:(NSEvent *)event 
//{
//    // NSScrollView is instructed to only forward horizontal scroll gesture events (see code above). However, depending
//    // on where your controller is in the responder chain, it may receive other scrollWheel events that we don't want
//    // to track as a fluid swipe because the event wasn't routed though an NSScrollView first.
//    if ([event phase] == NSEventPhaseNone) return; // Not a gesture scroll event.
//    if (fabsf([event scrollingDeltaX]) <= fabsf([event scrollingDeltaY])) return; // Not horizontal
//    // If the user has disabled tracking scrolls as fluid swipes in system preferences, we should respect that.
//    // NSScrollView will do this check for us, however, depending on where your controller is in the responder chain,
//    // it may scrollWheel events that are not filtered by an NSScrollView.
//    if (![NSEvent isSwipeTrackingFromScrollEventsEnabled]) return;
//    
//    //NSLog(@"scrolled on PTMainViewController");
//    
//    __block BOOL animationCancelled = NO;
//    [event trackSwipeEventWithOptions:0 dampenAmountThresholdMin:-5 max:5
//                         usingHandler:^(CGFloat gestureAmount, NSEventPhase phase, BOOL isComplete, BOOL *stop) {
//                             if (animationCancelled) {
//                                 *stop = YES;
//                                 // Tear down animation overlay
//                                 return;
//                             }
//                             if (phase == NSEventPhaseBegan) {
//                                 // Setup animation overlay layers
//                             }
//                             // Update animation overlay to match gestureAmount
//                             if (phase == NSEventPhaseEnded) {
//                                 // The user has completed the gesture successfully.
//                                 // This handler will continue to get called with updated gestureAmount
//                                 // to animate to completion, but just in case we need
//                                 // to cancel the animation (due to user swiping again) setup the
//                                 // controller / view to point to the new content / index / whatever
//                                 
//                                 // if left swipe, switch to main view
//                                 if ([event deltaX] < 0) 
//                                     [mainWindowController switchToProjectView:self];
//                             } else if (phase == NSEventPhaseCancelled) {
//                                 // The user has completed the gesture un-successfully.
//                                 // This handler will continue to get called with updated gestureAmount
//                                 // But we don't need to change the underlying controller / view settings.
//                             }
//                             if (isComplete) {
//                                 // Animation has completed and gestureAmount is either -1, 0, or 1.
//                                 // This handler block will be released upon return from this iteration.
//                                 // Note: we already updated our view to use the new (or same) content
//                                 // above. So no need to do that here. Just...
//                                 // Tear down animation overlay here
//                                 //self->_swipeAnimationCanceled = NULL;
//                             }
//                         }];
//}

- (NSMutableArray *)currentUserRoles {
    return _currentUserRoles;
}


@end
