//
//  PTTaskListViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 06/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "PTBugListViewController.h"
#import <Foundation/NSJSONSerialization.h>
#import "Bug.h"
#import "MainWindowController.h"
#import "MWConnectionController.h"
#import "PTBugDetailsWindowController.h"
#import "PTBugHelper.h"
#import "PTCommon.h"
#import "PTProjectDetailsViewController.h"

@implementation PTBugListViewController
@synthesize addBugButton;
@synthesize outlineViewProjetColumn;
@synthesize projectButton;
@synthesize removeBugButton;

@synthesize arrBug;
@synthesize bugArrayCtrl;
@synthesize bugTreeCtrl;
@synthesize bugOutlineView;
@synthesize mainWindowController;

@synthesize parentProjectDetailsViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self = [super initWithNibName:@"PTBugListView" bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
        // Initialize the array which holds the list of task 
        arrBug = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    // get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    urlString = [urlString stringByAppendingString:@"resources/bugs/"];
    
    // convert to NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    // NSURLConnection - MWConnectionController
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {
                                                        [self requestFinished:data];
                                                    }
                                                    failureBlock:^(NSError *error) {
                                                        [self requestFailed:error];
                                                    }];
    
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    // start animating the main window's circular progress indicator.
    [mainWindowController startProgressIndicatorAnimation];
    
    [connectionController startRequestForURL:url setRequest:urlRequest];
    
    // désactiver le bouton 'vue projet'.
    [[mainWindowController detailViewToolbarItem] setEnabled:NO];
}

- (void)loadView
{
    [super loadView];
    
    [self viewDidLoad];
}

// NSURLConnection
- (IBAction)addNewBugButtonClicked:(id)sender {
    NSNumber *parentID;
    
    NSArray *selectedObjects = [bugArrayCtrl selectedObjects];
    
    // if a project is selected, open the window to show its details.
    if ([selectedObjects count] == 1) {
        
        Bug *bug = [[Bug alloc] init];
        
        [bugArrayCtrl insertObject:bug atArrangedObjectIndex:[bugArrayCtrl selectionIndex]];
    }
    
    [self openBugDetailsWindow:YES];
}

- (void)requestFinished:(NSMutableData*)data
{
    NSError *error;

    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
    [[self mutableArrayValueForKey:@"arrBug"] addObjectsFromArray:[PTBugHelper setAttributesFromJSONDictionary:dict]];
        
    // stop animating the main window's circular progress indicator.
    [mainWindowController stopProgressIndicatorAnimation];
}

- (void)requestFailed:(NSError*)error
{
    // stop animating the main window's circular progress indicator.
    [mainWindowController stopProgressIndicatorAnimation];
}

-(void)insertObject:(Project *)p inArrBugAtIndex:(NSUInteger)index {
    [arrBug insertObject:p atIndex:index];
}

-(void)removeObjectFromArrBugAtIndex:(NSUInteger)index {
    [arrBug removeObjectAtIndex:index];
}

- (void)outlineView:(NSTableView *)outlineView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
    [[self mutableArrayValueForKey:@"arrBug"] sortUsingDescriptors:[outlineView sortDescriptors]];
}

- (IBAction)detailsButtonClicked:(id)sender {
    [self openBugDetailsWindow:NO];
}

// update user when finished editing cell in table view
- (void)editingDidEnd:(NSNotification *)notification
{
    // continue and update the user only if the object is the usersTableView
    if ([notification object] == bugOutlineView) {
        
        NSArray *selectedObjects = [bugArrayCtrl selectedObjects];
    }
}

- (void)openBugDetailsWindow:(BOOL)isNewBug {
    // get selected bugs.
    NSArray *selectedObjects;
    selectedObjects = [bugArrayCtrl selectedObjects];
    
    // si un bogue a été sélectionné. 
    if ([selectedObjects count] == 1) {
        bugDetailsWindowController = [[PTBugDetailsWindowController alloc] init];
        bugDetailsWindowController.parentBugListViewController = self;
        bugDetailsWindowController.mainWindowController = mainWindowController;
        bugDetailsWindowController.isNewBug = isNewBug;
        bugDetailsWindowController.bug = [selectedObjects objectAtIndex:0];
        bugDetailsWindowController.bug.project = [parentProjectDetailsViewController project];
        
        [bugDetailsWindowController showWindow:self];
    }
}

@end
