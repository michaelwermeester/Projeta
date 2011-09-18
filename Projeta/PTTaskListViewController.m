//
//  PTTaskListViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 06/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "PTTaskListViewController.h"
#import <Foundation/NSJSONSerialization.h>
#import "MainWindowController.h"
#import "MWConnectionController.h"
#import "PTCommon.h"
#import "PTTaskHelper.h"
#import "Task.h"

@implementation PTTaskListViewController

@synthesize arrTask;
@synthesize taskArrayCtrl;
@synthesize taskTreeCtrl;
@synthesize taskOutlineView;
@synthesize mainWindowController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self = [super initWithNibName:@"PTTaskListView" bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
        // Initialize the array which holds the list of task 
        arrTask = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    // get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    urlString = [urlString stringByAppendingString:@"resources/be.luckycode.projetawebservice.task/"];
    
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
    [[self mutableArrayValueForKey:@"arrTask"] addObjectsFromArray:[PTTaskHelper setAttributesFromJSONDictionary:dict]];
    
    // stop animating the main window's circular progress indicator.
    [mainWindowController stopProgressIndicatorAnimation];
}

- (void)requestFailed:(NSError*)error
{
    // stop animating the main window's circular progress indicator.
    [mainWindowController stopProgressIndicatorAnimation];
    
    NSLog(@"Failed %@ with code %ld and with userInfo %@",[error domain],[error code],[error userInfo]);
}

-(void)insertObject:(Project *)p inArrTaskAtIndex:(NSUInteger)index {
    [arrTask insertObject:p atIndex:index];
}

-(void)removeObjectFromArrTaskAtIndex:(NSUInteger)index {
    [arrTask removeObjectAtIndex:index];
}

// outlineView's willDisplayCell delegate method
/*- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    // display task titles
    if ([[tableColumn identifier] isEqual:@"TaskTitleColumn"]) {
        Task *task = [item representedObject];
    
        [cell setTitle:task.taskTitle];
    }
}*/

/*- (void)outlineView:(NSOutlineView *)outlineView sortDescriptorsDidChange:(NSArray *)oldDescriptors {
    NSLog(@"called");
    
    NSSortDescriptor *taskTitleDescriptor = [[NSSortDescriptor alloc] initWithKey:@"taskTitle"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:taskTitleDescriptor];
    
    NSLog(@"before: ");
    for (Task *t in arrTask) {
        NSLog(@"%@", t.taskTitle);
    }
    
    //NSArray *newDescriptors = [outlineView sortDescriptors];
	[arrTask sortUsingDescriptors:sortDescriptors];
    NSLog(@"after: ");
    for (Task *t in arrTask) {
        NSLog(@"%@", t.taskTitle);
    }
    
    [taskOutlineView reloadData];
}*/

- (void)outlineView:(NSTableView *)outlineView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
    [[self mutableArrayValueForKey:@"arrTask"] sortUsingDescriptors:[outlineView sortDescriptors]];
    [outlineView reloadData];
    NSLog(@"sort");
}

- (NSArray *)mySortOrder {
    NSSortDescriptor *taskTitleDescriptor = [[NSSortDescriptor alloc] initWithKey:@"taskTitle"
                                                                        ascending:YES];
    
    NSLog(@"called2");
    
    
    
    //[arrTask sortUsingDescriptors:[NSArray arrayWithObject:taskTitleDescriptor]];
    return [NSArray arrayWithObject:taskTitleDescriptor];
}

- (void)setMySortOrder:(NSArray *)mySortOrder {
    NSLog(@"set");
}

- (IBAction)testButtonClick:(id)sender {
    [arrTask sortUsingDescriptors:[taskOutlineView sortDescriptors]];
    [taskOutlineView reloadData];
    NSLog(@"sort");
}
@end
