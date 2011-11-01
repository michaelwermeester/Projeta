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

@synthesize arrPrj;
@synthesize mainWindowController;
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
    urlString = [urlString stringByAppendingString:@"resources/be.luckycode.projetawebservice.project/"];
    
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
    [[mainWindowController detailViewToolbarItem] setLabel:@"Project view"];
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
    [self openProjectDetailsWindow:YES];
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

- (void)openProjectDetailsWindow:(BOOL)isNewProject {
    // get selected users.
    NSArray *selectedObjects = [prjArrayCtrl selectedObjects];
    
    // if a user is selected, open the window to show its user details.
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
