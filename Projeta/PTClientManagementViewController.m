//
//  PTClientManagementViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 1/30/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "MainWindowController.h"
#import "PTClientDetailsWindowController.h"
#import "PTClientHelper.h"
#import "PTClientManagementViewController.h"
#import "PTClientUserWindowController.h"
#import "PTUserHelper.h"

@implementation PTClientManagementViewController

@synthesize arrClients;
@synthesize clientsArrayCtrl;
@synthesize clientsTableView;
@synthesize mainWindowController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"PTClientManagementView" bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
        arrClients = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [self viewDidLoad];
}

// bouton 'ajouter un client' cliqué.
- (IBAction)addClientButtonClicked:(id)sender {
}

// bouton 'supprimer un client' cliqué.
- (IBAction)deleteClientButtonClicked:(id)sender {
}

// bouton 'détails' cliqué.
- (IBAction)clientDetailsButtonClicked:(id)sender {
    
    clientDetailsWindowController = [[PTClientDetailsWindowController alloc] init];
    
    [clientDetailsWindowController showWindow:self];
}

// bouton 'utilisateurs' cliqué.
- (IBAction)clientUsersButtonClicked:(id)sender {

    
    // get selected usergroups.
    NSArray *selectedObjects = [clientsArrayCtrl selectedObjects];
    
    // si un groupe a été sélectionné.
    if ([selectedObjects count] == 1) {
        
        clientUserWindowController = [[PTClientUserWindowController alloc] init];
        clientUserWindowController.parentClientManagementViewCtrl = self;
        clientUserWindowController.mainWindowController = mainWindowController;
        clientUserWindowController.client = [selectedObjects objectAtIndex:0];
        
        // fetch usersgroups.
        [PTUserHelper usersForClient:clientUserWindowController.client successBlock:^(NSMutableArray *users) {
            
            // sort user roles alphabetically.
            [users sortUsingComparator:^NSComparisonResult(User *u1, User *u2) {
                
                return [u1.username compare:u2.username];
            }];
            
            //if (isNewUser == NO) {
            clientUserWindowController.client.users = users;
            
        } failureBlock:^(NSError *error) {
            
        }];
        
        // fetch available users.
        [PTUserHelper allUsers:^(NSMutableArray *availableUsers) { 
            
            // sort available roles alphabetically.
            [availableUsers sortUsingComparator:^NSComparisonResult(User *u1, User *u2) {
                
                return [u1.username compare:u2.username];
            }];
            
            clientUserWindowController.availableUsers = availableUsers;
            
            [clientUserWindowController showWindow:self];
        } failureBlock:^(NSError *error) { }];
        
    }
}

- (void)viewDidLoad {
    
    [[mainWindowController searchField] bind:@"predicate" toObject:clientsArrayCtrl withKeyPath:@"filterPredicate" options:
     [NSDictionary dictionaryWithObjectsAndKeys:
      @"predicate", NSDisplayNameBindingOption,
      @"(clientName contains[cd] $value)",
      NSPredicateFormatBindingOption,
      nil]];
    
    // show loading indicator animation.
    [mainWindowController startProgressIndicatorAnimation];
    
    [PTClientHelper getClientNames:^(NSMutableArray *clients) { 
        [self getClientNamesRequestFinished:clients]; 
    } failureBlock:^(NSError *error) {
        [self getClientNamesRequestFailed:error];
    }];
    
}

- (void)getClientNamesRequestFinished:(NSMutableArray *)users 
{
    [[self mutableArrayValueForKey:@"arrClients"] addObjectsFromArray:users];
    
    // sort the user list by username. 
    [clientsTableView setSortDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"clientName" ascending:YES selector:@selector(compare:)], nil]];
    
    // stop showing loading indicator animation.
    [mainWindowController stopProgressIndicatorAnimation];
    
}

- (void)getClientNamesRequestFailed:(NSError*)error
{
    
    // stop showing loading indicator animation.
    [mainWindowController stopProgressIndicatorAnimation];
}

@end
