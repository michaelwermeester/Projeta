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
#import "PTCommentairesWindowController.h"
#import "PTProgressWindowController.h"
#import "PTProjectDetailsViewController.h"
#import "PTCommon.h"
#import "PTTaskDetailsWindowController.h"
#import "PTTaskHelper.h"
#import "Task.h"

@implementation PTTaskListViewController

@synthesize outlineViewProjetColumn;
@synthesize projectButton;
@synthesize checkBoxShowTasksFromSubProjects;

@synthesize arrTask;
@synthesize taskArrayCtrl;
@synthesize taskTreeCtrl;
@synthesize taskOutlineView;
@synthesize mainWindowController;
@synthesize parentProjectDetailsViewController;

@synthesize isPersonalTask;

@synthesize taskURL;

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
    if (isPersonalTask == YES)
        urlString = [urlString stringByAppendingString:@"resources/tasks/personal"];
    /*else if (taskUrl) {
        
    }*/
    else
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
    //[[mainWindowController detailViewToolbarItem] setLabel:NSLocalizedString(@"Task view", nil)];
    
    // désactiver le bouton 'vue projet'.
    [[mainWindowController detailViewToolbarItem] setEnabled:NO];
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
/*- (void)editingDidEnd:(NSNotification *)notification
{
    //NSLog(@"notification object: %@", [notification object]);
    
    // continue and update the user only if the object is the usersTableView
    if ([notification object] == taskOutlineView) {
        //NSLog(@"UPDATE");

        NSArray *selectedObjects = [taskTreeCtrl selectedObjects];
        
        for (Task *task in selectedObjects)
        {
            // update Task
            [self updateTask:task];
        }
    }
}*/

- (void)updateTask:(Task *)aTask {
    
    BOOL taskUpdSuc = NO;
    
    taskUpdSuc = [PTTaskHelper updateTask:aTask successBlock:^(NSMutableData *data) {
        //[self finishedCreatingTask:data];
    } failureBlock:^() {
        
    }
                     mainWindowController:self];
}

- (IBAction)addNewTaskButtonClicked:(id)sender {
    NSNumber *parentID;
    
    NSArray *selectedObjects = [taskTreeCtrl selectedObjects];
    
    // if a project is selected, open the window to show its details.
    if ([selectedObjects count] == 1) {
        //parentID = [[selectedObjects objectAtIndex:0] projectId];
        //parentID = [[selectedObjects objectAtIndex:0] parentProjectId];
        
        //[prjTreeController add:prj];
        
        Task *tsk = [[Task alloc] init];
        // set current date.
        tsk.startDate = [NSDate date];
        tsk.endDate = [NSDate date];
        
        tsk.isPersonal = isPersonalTask;
        
        // get parent node.
        NSTreeNode *parent = [[[[taskTreeCtrl selectedNodes] objectAtIndex:0] parentNode] parentNode];
        NSMutableArray *parentTasks = [[parent representedObject] mutableArrayValueForKeyPath:
                                          [taskTreeCtrl childrenKeyPathForNode:parent]];
        //NSLog(@"test: %@", [[[[prjTreeController selectedNodes] objectAtIndex:] parent] projectTitle]); 
        
        //[prjTreeController 
        //parentrowforrow
        
        //NSLog(@"test: %@", [[objects objectAtIndex:0] projectTitle]);
        //int line = [prjOutlineView selectedRow];
        //NSLog(@"test: %@", [[parentProjects objectAtIndex:line] projectTitle]);
        
        // get projectid du projet parent. 
        for (Task *p in parentTasks)
        {
            if ([p.childTask containsObject:[selectedObjects objectAtIndex:0]])
            {
                parentID = p.taskId;
                
                //NSLog(@"TEST: %d", [[p projectId] intValue]);
                
                break;
            }
        }
        
        //NSLog(@"test: %@", [[parent representedObject] projectTitle]);
        
        //prj.parentProjectId = parentID;
        //prj.parentProjectId = p.projectId;
        if (parentID != nil){
            tsk.parentTaskId = parentID;
        }
        
        //NSLog(@"parentprojectid: %@", p.projectTitle);
        
        //[prjTreeController add:prj];
        NSIndexPath *indexPath = [taskTreeCtrl selectionIndexPath];
        //NSLog(@"indexpath: %@", indexPath);
        if ([indexPath length] > 1) {
            [taskTreeCtrl insertObject:tsk atArrangedObjectIndexPath:indexPath];
        } else {
            // construire nouveau NSIndexPath avec comme valeur 0 -> l'élément sera inséré à la première position.
            // https://discussions.apple.com/thread/1585148?start=0&tstart=0
            NSUInteger indexes[1]={0};
            indexPath=[NSIndexPath indexPathWithIndexes:indexes length:1];
            
            [taskTreeCtrl insertObject:tsk atArrangedObjectIndexPath:indexPath];
        }
    }
    
    // il s'agit d'un nouveau projet.
    //isNewProject = true;
    
    [self openTaskDetailsWindow:YES isSubTask:NO];
}

- (IBAction)addNewSubTaskButtonClicked:(id)sender {
    
    NSNumber *parentID;
    
    NSArray *selectedObjects = [taskTreeCtrl selectedObjects];
    
    // if a project is selected, open the window to show its details.
    if ([selectedObjects count] == 1) {
        parentID = [[selectedObjects objectAtIndex:0] taskId];
        
        
        Task *tsk = [[Task alloc] init];
        // set current date.
        tsk.startDate = [NSDate date];
        tsk.endDate = [NSDate date];
        
        tsk.parentTaskId = parentID;
        
        tsk.isPersonal = isPersonalTask;
        
        Task *tmpTask = [selectedObjects objectAtIndex:0]; 
        
        if ([tmpTask childTask] == nil) {
            
            NSIndexPath *indexPath = [taskTreeCtrl selectionIndexPath];
            
            tmpTask.childTask = [[NSMutableArray alloc] init];
            [taskTreeCtrl insertObject:tsk atArrangedObjectIndexPath:[indexPath indexPathByAddingIndex:0]];
        } else {
            //else if ([[tmpPrj childProject] count] > 0) {
            
            NSIndexPath *indexPath = [taskTreeCtrl selectionIndexPath];
            
            [taskTreeCtrl insertObject:tsk atArrangedObjectIndexPath:[indexPath indexPathByAddingIndex:0]];
        } 
    }
    
    
    NSLog(@"count: %lu", [arrTask count]);
    
    // il s'agit d'un nouveau projet.
    //isNewProject = true;
    
    [self openTaskDetailsWindow:YES isSubTask:YES];
}

- (IBAction)detailsButtonClicked:(id)sender {
    [self openTaskDetailsWindow:NO isSubTask:NO];
}

- (IBAction)removeTaskButtonClicked:(id)sender {
    
    // index du tab actuel.
    //int selectedTabIndex = [prjTabView indexOfTabViewItem:[prjTabView selectedTabViewItem]];
    
    NSArray *selectedObjects;
    
    //if (selectedTabIndex == 1) {
        selectedObjects = [taskTreeCtrl selectedObjects];
    //} else if (selectedTabIndex == 0) {
    //    selectedObjects = [prjArrayCtrl selectedObjects];
    //}
    
    // supprimer en DB.
    [PTTaskHelper deleteTask:[selectedObjects objectAtIndex:0] successBlock:^(NSMutableData *data){
        //[self sucUserExists:userExists];
        
        //if (selectedTabIndex == 1) {
            [taskTreeCtrl remove:self];
        //} else if (selectedTabIndex == 0) {
        //    [prjArrayCtrl remove:self];
        //}
    } failureBlock:^(){
        //[self failUserExists];
    } mainWindowController:mainWindowController];
}

- (IBAction)commentButtonClicked:(id)sender {
    
    commentWindowController = [[PTCommentairesWindowController alloc] init];

    NSArray *selectedObjects;
    selectedObjects = [taskTreeCtrl selectedObjects];
    commentWindowController.task = [selectedObjects objectAtIndex:0];
    
    // référence vers mainWindowController. 
    commentWindowController.mainWindowController = mainWindowController;
    
    [commentWindowController showWindow:self];
}

- (IBAction)progressButtonClicked:(id)sender {
    
    progressWindowController = [[PTProgressWindowController alloc] init];
    
    NSArray *selectedObjects;
    selectedObjects = [taskTreeCtrl selectedObjects];
    progressWindowController.task = [selectedObjects objectAtIndex:0];
    
    // référence vers mainWindowController. 
    progressWindowController.mainWindowController = mainWindowController;
    
    // initialiser statuts.
    [progressWindowController initStatusArray];
    
    [progressWindowController showWindow:self];
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
    NSIndexPath *tskTreeIndexPath;
    //NSUInteger prjArrCtrlIndex;
    
    //if (selectedTabIndex == 1) {
        selectedObjects = [taskTreeCtrl selectedObjects];
        
        tskTreeIndexPath = [taskTreeCtrl selectionIndexPath];
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
            taskDetailsWindowController.tskTreeIndexPath = tskTreeIndexPath;
            //taskDetailsWindowControllers.prjArrCtrlIndex = prjArrCtrlIndex;
        }
        
        [taskDetailsWindowController showWindow:self];
        //}];
    }
    //}
}

@end
