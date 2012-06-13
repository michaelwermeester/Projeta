//
//  PTUsersView.m
//  Projeta
//
//  Created by Michael Wermeester on 04/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import "PTUserManagementViewController.h"
#import "PTUserHelper.h"
#import "User.h"
#import <Foundation/NSJSONSerialization.h>
#import "MWConnectionController.h"
#import "PTCommon.h"
#import "PTRoleHelper.h"
#import "PTUserGroupHelper.h"
#import "PTUserHelper.h"
#import "PTUserDetailsWindowController.h"
#import "PTUserGroupWindowController.h"
#import "MainWindowController.h"
#import "Role.h"
#import "Usergroup.h"

@implementation PTUserManagementViewController

@synthesize arrUsr;          // array qui contient les utilisateurs.
@synthesize arrayCtrl;      // array controller pour l'array arrUsr.

@synthesize searchField;
@synthesize deleteButton;
@synthesize usersTableView;

@synthesize mainWindowController;
@synthesize groupsButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"PTUserManagementView" bundle:nibBundleOrNil];
    
    if (self) {
        // Initialization code here.
        
        // Instancier l'array qui contient les utilisateurs. 
        arrUsr = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    // lier le champ de recherche de la fenêtre principale. 
    [[mainWindowController searchField] bind:@"predicate" toObject:arrayCtrl withKeyPath:@"filterPredicate" options:
     [NSDictionary dictionaryWithObjectsAndKeys:
      @"predicate", NSDisplayNameBindingOption,
      @"(username contains[cd] $value) OR (firstName contains[cd] $value) OR (lastName contains[cd] $value) OR (emailAddress contains[cd] $value)",
      NSPredicateFormatBindingOption,
      nil]];
    
    // afficher animation de chargement. 
    [mainWindowController startProgressIndicatorAnimation];
    
    // charger les utilisateurs. 
    [PTUserHelper allUsers:^(NSMutableArray *users) { 
        [self allUsersRequestFinished:users]; 
    } failureBlock:^(NSError *error) {
        [self allUsersRequestFailed:error];
    }];
}

- (void)loadView
{
    [super loadView];
    
    [self viewDidLoad];
}


- (void)tableView:(NSTableView *)aTableView
   setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)aTableColumn
              row:(int)rowIndex {
    
    NSArray *selectedObjects = [arrayCtrl selectedObjects];
    
    for (User *usr in selectedObjects)
    {
        // mettre à jour l'utilisateur. 
        [PTUserHelper updateUser:usr mainWindowController:mainWindowController];
    }
}

- (void)allUsersRequestFinished:(NSMutableArray *)users
{
    [[self mutableArrayValueForKey:@"arrUsr"] addObjectsFromArray:users];
    
    // trier la liste d'utilisateurs par nom d'utilisateur.  
    [usersTableView setSortDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"username" ascending:YES selector:@selector(compare:)], nil]];
    
    // arrêter l'animation d'indicateur de chargement. 
    [mainWindowController stopProgressIndicatorAnimation];
         
}
     
- (void)allUsersRequestFailed:(NSError*)error
{
    // arrêter l'animation d'indicateur de chargement. 
    [mainWindowController stopProgressIndicatorAnimation];
}

- (IBAction)deleteButtonClicked:(NSButton*)sender {
    
    // afficher message d'erreur.
    NSRunAlertPanel(@"Not implemented", @"Not implemented yet.", @"OK", nil, nil);
}

- (IBAction)detailsButtonClicked:(id)sender {
    
    // open user details window. 
    // NO means that the user already exists.
    [self openUserDetailsWindow:NO];
}

- (IBAction)groupsButtonClicked:(id)sender {
    
    [self openUserGroupWindow];
}

- (void)openUserDetailsWindow:(BOOL)isNewUser {
    // get selected users.
    NSArray *selectedObjects = [arrayCtrl selectedObjects];
    
    // if a user is selected, open the window to show its user details.
    if ([selectedObjects count] == 1) {
        
        userDetailsWindowController = [[PTUserDetailsWindowController alloc] init];
        userDetailsWindowController.parentUserManagementViewCtrl = self;
        userDetailsWindowController.mainWindowController = mainWindowController;
        userDetailsWindowController.isNewUser = isNewUser;
        userDetailsWindowController.user = [selectedObjects objectAtIndex:0];
        
        // fetch user roles.
        [PTRoleHelper rolesForUser:userDetailsWindowController.user successBlock:^(NSMutableArray *userRoles){
            
            // sort user roles alphabetically.
            [userRoles sortUsingComparator:^NSComparisonResult(Role *r1, Role *r2) {
                
                return [r1.code compare:r2.code];
            }];
            
            userDetailsWindowController.user.roles = userRoles;
        }];
        
        // fetch available roles.
        [PTRoleHelper rolesAvailable:^(NSMutableArray *availableRoles){
            
            // sort available roles alphabetically.
            [availableRoles sortUsingComparator:^NSComparisonResult(Role *r1, Role *r2) {
                
                return [r1.code compare:r2.code];
            }];
            
            userDetailsWindowController.availableRoles = availableRoles;
            
            [userDetailsWindowController showWindow:self];
        }];
    }
}

// Don't allow table view selection to be changed when user details window is open.
- (BOOL)selectionShouldChangeInTableView:(NSTableView *)aTableView {
    
    if ([[userDetailsWindowController window] isVisible])
        return NO;
    else
        return YES;
}

// update user when finished editing cell in table view
- (void)editingDidEnd:(NSNotification *)notification
{
    // continue and update the user only if the object is the usersTableView
    if ([notification object] == usersTableView) {
        
        NSArray *selectedObjects = [arrayCtrl selectedObjects];
        
        for (User *usr in selectedObjects)
        {
            // update User
            [PTUserHelper updateUser:usr mainWindowController:mainWindowController];
        }
    }
}

// bouton 'ajouter utilisateur' cliqué.
- (IBAction)addButtonClicked:(id)sender {
    
    User *usr = [[User alloc] init];
    [arrayCtrl insertObject:usr atArrangedObjectIndex:([arrUsr count])];

    // open user details window. 
    // YES means that we're creating a new user.
    [self openUserDetailsWindow:YES];
    
    
}

// bouton 'supprimer utilisateur' cliqué.
- (IBAction)removeButtonClicked:(id)sender {
    
}

// fires, when user types something in the search field.
- (IBAction)findUser:(id)sender {
    NSLog(@"find: %@", [searchField stringValue]);
}

- (void)openUserGroupWindow {
    // get selected users.
    NSArray *selectedObjects = [arrayCtrl selectedObjects];
    
    // if a user is selected, open the window to show its user details.
    if ([selectedObjects count] == 1) {
        
        userGroupWindowController = [[PTUserGroupWindowController alloc] init];
        userGroupWindowController.parentUserManagementViewCtrl = self;
        userGroupWindowController.mainWindowController = mainWindowController;
        userGroupWindowController.user = [selectedObjects objectAtIndex:0];
        
        // fetch user's usergroups.
        [PTUsergroupHelper usergroupsForUser:userGroupWindowController.user successBlock:^(NSMutableArray *userGroups){
            
            // sort user roles alphabetically.
            [userGroups sortUsingComparator:^NSComparisonResult(Usergroup *ug1, Usergroup *ug2) {
                
                return [ug1.code compare:ug2.code];
            }];

            userGroupWindowController.user.usergroups = userGroups;
        }];
        
        // fetch available usergroups.
        [PTUsergroupHelper usergroupsAvailable:^(NSMutableArray *availableUsergroups) {
            
            // sort available roles alphabetically.
            [availableUsergroups sortUsingComparator:^NSComparisonResult(Usergroup *ug1, Usergroup *ug2) {
                
                return [ug1.code compare:ug2.code];
            }];
            
            userGroupWindowController.availableUsergroups = availableUsergroups;
            
            [userGroupWindowController showWindow:self];
        }];
        
    }

}



@end
