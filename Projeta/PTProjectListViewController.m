//
//  PTProjectListViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 26/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "PTProjectListViewController.h"
#import <Foundation/NSJSONSerialization.h>
#import "MainWindowController.h"
#import "MWConnectionController.h"
#import "PTCommon.h"
#import "Project.h"
#import "PTProjectHelper.h"
#import "PTProjectDetailsWindowController.h"

@implementation PTProjectListViewController

// true si on crée un nouveau projet.
//BOOL isNewProject = false;

@synthesize arrPrj;
@synthesize mainWindowController;
@synthesize prjTabView;
@synthesize prjTreeController;
@synthesize prjArrayCtrl;
@synthesize prjCollectionView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self = [super initWithNibName:@"PTProjectListView" bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
        // Initialize the array which holds the list of projects 
        arrPrj = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    // get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    urlString = [urlString stringByAppendingString:@"resources/projects/"];
    
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
    //[urlRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    // start animating the main window's circular progress indicator.
    [mainWindowController startProgressIndicatorAnimation];
    
    [connectionController startRequestForURL:url setRequest:urlRequest];
    
    // set label of 'detail view' toolbar item to 'Project view'.
    [[mainWindowController detailViewToolbarItem] setLabel:NSLocalizedString(@"Project view", nil)];
    
    // bind the main window's search field to the arraycontroller.
    [[mainWindowController searchField] bind:@"predicate" toObject:prjArrayCtrl withKeyPath:@"filterPredicate" options:
     [NSDictionary dictionaryWithObjectsAndKeys:
      @"predicate", NSDisplayNameBindingOption,
      @"projectTitle contains[cd] $value",
      NSPredicateFormatBindingOption,
      nil]];
}

- (void)loadView
{
    [super loadView];
    
    [self viewDidLoad];
}

// NSURLConnection
- (void)requestFinished:(NSMutableData*)data
{
    NSError *error;
    
    // Use when fetching text data
    //NSString *responseString = [request responseString];
    //NSLog(@"response: %@", responseString);
    //NSDictionary *dict = [[NSDictionary alloc] init];
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    //NSLog(@"DESC: %@", [dict description]);
    
    // see Cocoa and Objective-C up and running by Scott Stevenson.
    // page 242
    [[self mutableArrayValueForKey:@"arrPrj"] addObjectsFromArray:[PTProjectHelper setAttributesFromJSONDictionary:dict]];
    
    // stop animating the main window's circular progress indicator.
    [mainWindowController stopProgressIndicatorAnimation];
    
    for (Project *p in arrPrj)
    {
        NSLog(@"ID: %@", p.projectId);
        NSLog(@"Title: %@", p.projectTitle);
        NSLog(@"Description: %@", p.projectDescription);
        //NSLog(@"User: %@",[[p userCreated] objectForKey:@"username"]);
        NSLog(@"User: %@", p.userCreated.username);
        NSLog(@"Date: %@", p.dateCreated);
    }
    
    NSLog(@"%lu", [arrPrj count]);
    
    //[prjArrayCtrl addObjects:[PTProjectHelper setAttributesFromJSONDictionary:dict]];
    
    // add a new user programmatically
    /*
     User *user = [[User alloc] init];
     user.username = @"test";
     [arrayCtrl addObject:user];
     */
}

- (void)requestFailed:(NSError*)error
{
    // stop animating the main window's circular progress indicator.
    [mainWindowController stopProgressIndicatorAnimation];
    
    NSLog(@"Failed %@ with code %ld and with userInfo %@",[error domain],[error code],[error userInfo]);
}

- (IBAction)addNewProjectButtonClicked:(id)sender {
    
    NSNumber *parentID;
    
    NSArray *selectedObjects = [prjTreeController selectedObjects];
    
    // if a project is selected, open the window to show its details.
    if ([selectedObjects count] == 1) {
        parentID = [[selectedObjects objectAtIndex:0] projectId];
    }
    
    Project *prj = [[Project alloc] init];
    prj.parentProjectId = parentID;
    
    //[prjTreeController add:prj];
    NSIndexPath *indexPath = [prjTreeController selectionIndexPath];
    [prjTreeController insertObject:prj atArrangedObjectIndexPath:indexPath];
    
    //[prjTreeController insertObject:prj atArrangedObjectIndex:([arrPrj count])];
    
    // il s'agit d'un nouveau projet.
    //isNewProject = true;
    
    
    [self openProjectDetailsWindow:YES isSubProject:NO];
}

- (IBAction)addNewSubProjectButtonClicked:(id)sender {
    
    
    NSNumber *parentID;
    
    NSArray *selectedObjects = [prjTreeController selectedObjects];
    
    // if a project is selected, open the window to show its details.
    if ([selectedObjects count] == 1) {
        parentID = [[selectedObjects objectAtIndex:0] projectId];
    }
    
    Project *prj = [[Project alloc] init];
    prj.parentProjectId = parentID;
    
    Project *tmpPrj = [selectedObjects objectAtIndex:0]; 
    
    if ([tmpPrj childProject] == nil) {
     
        NSIndexPath *indexPath = [prjTreeController selectionIndexPath];
        
        tmpPrj.childProject = [[NSMutableArray alloc] init];
        [prjTreeController insertObject:prj atArrangedObjectIndexPath:[indexPath indexPathByAddingIndex:0]];
    } else {
    //else if ([[tmpPrj childProject] count] > 0) {

        NSIndexPath *indexPath = [prjTreeController selectionIndexPath];
        
        [prjTreeController insertObject:prj atArrangedObjectIndexPath:[indexPath indexPathByAddingIndex:0]];
    } 

    
    NSLog(@"count: %lu", [arrPrj count]);
    
    // il s'agit d'un nouveau projet.
    //isNewProject = true;
    
    [self openProjectDetailsWindow:YES isSubProject:YES];
}


-(void)insertObject:(Project *)p inArrPrjAtIndex:(NSUInteger)index {
    [arrPrj insertObject:p atIndex:index];
}

-(void)removeObjectFromArrPrjAtIndex:(NSUInteger)index {
    [arrPrj removeObjectAtIndex:index];
}

-(void)setArrPrj:(NSMutableArray *)a {
    arrPrj = a;
}

-(NSArray *)arrPrj {
    return arrPrj;
}

- (void)openProjectDetailsWindow:(BOOL)isNewProject isSubProject:(BOOL)isSubProject {
    // get selected projects.
    //NSArray *selectedObjects = [prjArrayCtrl selectedObjects];
    NSArray *selectedObjects = [prjTreeController selectedObjects];
    
    // if a project is selected, open the window to show its details.
    if ([selectedObjects count] == 1) {
        
        projectDetailsWindowController = [[PTProjectDetailsWindowController alloc] init];
        projectDetailsWindowController.parentProjectListViewController = self;
        projectDetailsWindowController.mainWindowController = mainWindowController;
        projectDetailsWindowController.isNewProject = isNewProject;
        projectDetailsWindowController.project = [selectedObjects objectAtIndex:0];
        
        // fetch available roles.
        /*[PTRoleHelper rolesAvailable:^(NSMutableArray *availableRoles){
            
            // sort available roles alphabetically.
            [availableRoles sortUsingComparator:^NSComparisonResult(Role *r1, Role *r2) {
                
                return [r1.code compare:r2.code];
            }];
            
            projectDetailsWindowController.availableRoles = availableRoles;*/
            
            [projectDetailsWindowController showWindow:self];
        //}];
    }
}

@end
