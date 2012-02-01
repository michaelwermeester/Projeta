//
//  PTClientManagementViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 1/30/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "MainWindowController.h"
#import "PTClientHelper.h"
#import "PTClientManagementViewController.h"

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

- (IBAction)addClientButtonClicked:(id)sender {
}

- (IBAction)deleteClientButtonClicked:(id)sender {
}

- (IBAction)clientDetailsButtonClicked:(id)sender {
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
