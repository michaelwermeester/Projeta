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
#import "PTProjectDetailsViewController.h"
#import "PTCommon.h"
#import "PTTaskHelper.h"
#import "Task.h"
#import "PTTaskDetailsWindowController.h"

@implementation PTTaskListViewController
@synthesize outlineViewProjetColumn;
@synthesize projectButton;

@synthesize arrTask;
@synthesize taskArrayCtrl;
@synthesize taskTreeCtrl;
@synthesize taskOutlineView;
@synthesize mainWindowController;
@synthesize parentProjectDetailsViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self = [super initWithNibName:@"PTTaskListView" bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
        // Initialize the array which holds the list of task 
        arrTask = [[NSMutableArray alloc] init];
        
        // register for detecting changes in table view
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editingDidEnd:)
        //                                             name:NSControlTextDidEndEditingNotification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    // remove the observer
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:NSControlTextDidBeginEditingNotification object:nil];
}

- (void)viewDidLoad {
    // get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    urlString = [urlString stringByAppendingString:@"resources/tasks/"];
    
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
    
    // set label of 'detail view' toolbar item to 'Task view'.
    [[mainWindowController detailViewToolbarItem] setLabel:NSLocalizedString(@"Task view", nil)];
}

- (void)loadView
{
    [super loadView];
    
    [self viewDidLoad];
}

// NSURLConnection
- (void)requestFinished:(NSMutableData*)data
{
    // http://stackoverflow.com/questions/5037545/nsurlconnection-and-grand-central-dispatch
    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
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
        
    //});    
    

    //dispatch_async(dispatch_get_main_queue(), ^{
        
        [[self mutableArrayValueForKey:@"arrTask"] addObjectsFromArray:[PTTaskHelper setAttributesFromJSONDictionary:dict]];
        
        // stop animating the main window's circular progress indicator.
        [mainWindowController stopProgressIndicatorAnimation];
    //});
    //});
}

- (void)requestFailed:(NSError*)error
{
    // stop animating the main window's circular progress indicator.
    [mainWindowController stopProgressIndicatorAnimation];
    
    NSLog(@"Failed %@ with code %ld and with userInfo %@",[error domain],[error code],[error userInfo]);
}

-(void)insertObject:(Task *)p inArrTaskAtIndex:(NSUInteger)index {
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

- (void)outlineView:(NSTableView *)outlineView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
    [[self mutableArrayValueForKey:@"arrTask"] sortUsingDescriptors:[outlineView sortDescriptors]];
}

- (IBAction)addTaskButtonClick:(id)sender {
    
}

// update user when finished editing cell in table view
- (void)editingDidEnd:(NSNotification *)notification
{
    // continue and update the user only if the object is the usersTableView
    if ([notification object] == taskOutlineView) {
        
        NSArray *selectedObjects = [taskArrayCtrl selectedObjects];
        
        for (Task *task in selectedObjects)
        {
            // update Task
            //[self updateUser:usr];
        }
    }
}

- (IBAction)addNewTaskButtonClicked:(id)sender {
}

- (IBAction)addNewSubTaskButtonClicked:(id)sender {
}

- (IBAction)detailsButtonClicked:(id)sender {
    [self openTaskDetailsWindow:NO isSubTask:NO];
}

- (void)openTaskDetailsWindow:(BOOL)isNewTask isSubTask:(BOOL)isSubTask {
    // get selected projects.
    //NSArray *selectedObjects = [prjArrayCtrl selectedObjects];
    
    
    /*if (isNewProject == YES)
     {
     projectDetailsWindowController = [[PTProjectDetailsWindowController alloc] init];
     projectDetailsWindowController.parentProjectListViewController = self;
     projectDetailsWindowController.mainWindowController = mainWindowController;
     projectDetailsWindowController.isNewProject = isNewProject;
     
     [projectDetailsWindowController showWindow:self];
     }
     else {*/
    
    
    //int selectedTabIndex = [prjTabView indexOfTabViewItem:[prjTabView selectedTabViewItem]];
    
    NSArray *selectedObjects;
    NSIndexPath *prjTreeIndexPath;
    //NSUInteger prjArrCtrlIndex;
    
    //if (selectedTabIndex == 1) {
        selectedObjects = [taskTreeCtrl selectedObjects];
        
        prjTreeIndexPath = [taskTreeCtrl selectionIndexPath];
    //} else {
    //    selectedObjects = [prjArrayCtrl selectedObjects];
    //    
    //    prjArrCtrlIndex = [prjArrayCtrl selectionIndex];
    //}
    
    // if a task is selected, open the window to show its details.
    if ([selectedObjects count] == 1) {
        
        taskDetailsWindowController = [[PTTaskDetailsWindowController alloc] init];
        taskDetailsWindowController.parentTaskListViewController = self;
        taskDetailsWindowController.mainWindowController = mainWindowController;
        taskDetailsWindowController.isNewTask = isNewTask;
        taskDetailsWindowController.task = [selectedObjects objectAtIndex:0];
        
        if (isNewTask == NO) {
            taskDetailsWindowController.prjTreeIndexPath = prjTreeIndexPath;
            //taskDetailsWindowControllers.prjArrCtrlIndex = prjArrCtrlIndex;
        }
        
        [taskDetailsWindowController showWindow:self];
        //}];
    }
    //}
}

@end
