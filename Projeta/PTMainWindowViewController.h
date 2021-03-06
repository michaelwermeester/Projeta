//
//  PTMainWindowViewController.h
//  Projeta
//
//  Created by Michael Wermeester on 13/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PXSourceList.h"
#import "PTProjectListViewController.h"
#import "PTTaskListViewController.h"
#import "PTUserManagementViewController.h"

@class MainWindowController;
@class PTBugCategoryManagementViewController;
@class PTClientManagementViewController;
@class PTGroupManagementViewController;
@class PTBugListViewController;

@interface PTMainWindowViewController : NSViewController <PXSourceListDataSource, PXSourceListDelegate> {
    NSMutableArray *sourceListItems;
    NSSplitView *splitView;
    NSView *leftView;
    NSView *rightView;
}

@property (strong) IBOutlet PXSourceList *sourceList;
@property (strong) IBOutlet NSSplitView *splitView;
@property (strong) IBOutlet NSView *leftView;
@property (strong) IBOutlet NSView *rightView;
// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;

@property (readonly) NSMutableArray *currentUserRoles;

// project-list view
@property (strong) PTProjectListViewController *projectListViewController;
// task-list view
@property (strong) PTTaskListViewController *taskListViewController;
// bug-list view
@property (strong) PTBugListViewController *bugListViewController;
// user-management view
@property (strong) PTUserManagementViewController *userManagementViewController;
// group-management view
@property (strong) PTGroupManagementViewController *groupManagementViewController;
// client-management view
@property (strong) PTClientManagementViewController *clientManagementViewController;
// Gestion de types de bogue view.
@property (strong) PTBugCategoryManagementViewController *bugCategoryManagementViewController;

// removes any view from rightView
- (void)removeViewsFromRightView;

// initialize sidebar.
- (void)initializeSidebar;

// fetch logged in user its roles from web service.
- (void)loggedInUserInitializations;
// fetch the logged in user's roles from web service.
// This method is being called at the end of loggedInUserInitializations method.
// There's usually no need to call this method alone. 
// Use loggedInUserInitializations instead or call it at least once before
// calling userRoleInitializations.
- (void)userRoleInitializations;

// Finished and failed methods/handlers for previously declared methods. 
// Passed as blocks to MWConnectionController.
- (void)loggedInUserInitializationsRequestFinished:(NSMutableData*)data;
- (void)loggedInUserInitializationsRequestFailed:(NSError*)error;
- (void)userRoleInitializationsRequestFinished:(NSMutableData*)data;
- (void)userRoleInitializationsRequestFailed:(NSError*)error;

// affiche le menu administrateur si l'utilisateur authentifié appartient au role 'administrator'.
- (void)showAdminMenu;
// afficher points de menu supplémentaires sous 'BOGUES' si l'utilisateur est un administrateur ou développeur.
- (void)showBugMenuByUserRole;
// afficher points de menu supplémentaires sous 'PROJETS' si l'utilisateur est un administrateur ou développeur.
- (void)showProjectMenuByUserRole;
// afficher points de menu supplémentaires sous 'TÂCHES' si l'utilisateur est un administrateur ou développeur.
- (void)showTaskMenuByUserRole;

//@property (nonatomic, assign) BOOL hideAdminControls;

@end
