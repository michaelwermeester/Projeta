//
//  PTProjectDetailsViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 2/4/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

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
@synthesize availableClients;
@synthesize availableClientsArrayCtrl;

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
        
        
        // charger la liste des groupes d'utilisateurs disponibles.
        [self fetchAvailableUsergroups];
        // charger la liste des utilisateurs disponibles.
        [self fetchAvailableUsers];
        // charger la liste des clients disponibles.
        [self fetchAvailableClients];
        
    }
    
    return self;
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
    // fetch available usergroups.
    [PTUsergroupHelper usergroupsAvailable:^(NSMutableArray *tmpAvailableUsergroups) {
        
        // sort available roles alphabetically.
        [tmpAvailableUsergroups sortUsingComparator:^NSComparisonResult(Usergroup *ug1, Usergroup *ug2) {
            
            return [ug1.code compare:ug2.code];
        }];
        
        // ajouter les groupes dans l'array.
        [[self mutableArrayValueForKey:@"availableUsergroups"] addObjectsFromArray:tmpAvailableUsergroups];
    }];
}

// charger les utilisateurs à partir du webservice.
- (void)fetchAvailableUsers {
    // fetch available users.
    [PTUserHelper allUsers:^(NSMutableArray *tmpAvailableUsers) { 
        
        // sort available roles alphabetically.
        [tmpAvailableUsers sortUsingComparator:^NSComparisonResult(User *u1, User *u2) {
            
            return [u1.username compare:u2.username];
        }];
        
        // ajouter les groupes dans l'array.
        [[self mutableArrayValueForKey:@"availableUsers"] addObjectsFromArray:tmpAvailableUsers];
        
    } failureBlock:^(NSError *error) { }];
}

// charger les clients à partir du webservice.
- (void)fetchAvailableClients {
    
    [PTClientHelper getClientNames:^(NSMutableArray *tmpAvailableClients) { 
        
        // sort available roles alphabetically.
        [tmpAvailableClients sortUsingComparator:^NSComparisonResult(Client *c1, Client *c2) {
            
            return [c1.clientName compare:c2.clientName];
        }];
        
        [[self mutableArrayValueForKey:@"availableClients"] addObjectsFromArray:tmpAvailableClients];
        
    } failureBlock:^(NSError *error) {
        //[self getClientNamesRequestFailed:error];
    }];
}

@end
