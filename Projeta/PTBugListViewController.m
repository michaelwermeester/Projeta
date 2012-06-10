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
@synthesize outlineViewProjetColumn;
@synthesize projectButton;

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
    
    // set label of 'detail view' toolbar item to 'Task view'.
    //[[mainWindowController detailViewToolbarItem] setLabel:NSLocalizedString(@"Bug view", nil)];
    
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
        //parentID = [[selectedObjects objectAtIndex:0] projectId];
        //parentID = [[selectedObjects objectAtIndex:0] parentProjectId];
        
        //[prjTreeController add:prj];
        
        Bug *bug = [[Bug alloc] init];
        // set current date.
        //bugAr.startDate = [NSDate date];
        //prj.endDate = [NSDate date];
        
        // get parent node.
        //NSTreeNode *parent = [[[[prjTreeController selectedNodes] objectAtIndex:0] parentNode] parentNode];
        //NSMutableArray *parentProjects = [[parent representedObject] mutableArrayValueForKeyPath:
  //                                        [prjTreeController childrenKeyPathForNode:parent]];
        //NSLog(@"test: %@", [[[[prjTreeController selectedNodes] objectAtIndex:] parent] projectTitle]); 
        
        //[prjTreeController 
        //parentrowforrow
        
        //NSLog(@"test: %@", [[objects objectAtIndex:0] projectTitle]);
        //int line = [prjOutlineView selectedRow];
        //NSLog(@"test: %@", [[parentProjects objectAtIndex:line] projectTitle]);
        
        // get projectid du projet parent. 
//        for (Project *p in parentProjects)
//        {
//            if ([p.childProject containsObject:[selectedObjects objectAtIndex:0]])
//            {
//                parentID = p.projectId;
//                
//                //NSLog(@"TEST: %d", [[p projectId] intValue]);
//                
//                break;
//            }
//        }
        
        //NSLog(@"test: %@", [[parent representedObject] projectTitle]);
        
        //prj.parentProjectId = parentID;
        //prj.parentProjectId = p.projectId;
//        /if (parentID != nil){
//            prj.parentProjectId = parentID;
//        }
        
        //NSLog(@"parentprojectid: %@", p.projectTitle);
        
        //[prjTreeController add:prj];
//        NSIndexPath *indexPath = [prjTreeController selectionIndexPath];
//        //NSLog(@"indexpath: %@", indexPath);
//        if ([indexPath length] > 1) {
//            [prjTreeController insertObject:prj atArrangedObjectIndexPath:indexPath];
//        } else {
//            // construire nouveau NSIndexPath avec comme valeur 0 -> l'élément sera inséré à la première position.
//            // https://discussions.apple.com/thread/1585148?start=0&tstart=0
//            NSUInteger indexes[1]={0};
//            indexPath=[NSIndexPath indexPathWithIndexes:indexes length:1];
//            
//            [prjTreeController insertObject:prj atArrangedObjectIndexPath:indexPath];
//        }
        
        [bugArrayCtrl insertObject:bug atArrangedObjectIndex:[bugArrayCtrl selectionIndex]];
    }
    
    // il s'agit d'un nouveau projet.
    //isNewProject = true;
    
    [self openBugDetailsWindow:YES];
}

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
        
        [[self mutableArrayValueForKey:@"arrBug"] addObjectsFromArray:[PTBugHelper setAttributesFromJSONDictionary:dict]];
        
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

-(void)insertObject:(Project *)p inArrBugAtIndex:(NSUInteger)index {
    [arrBug insertObject:p atIndex:index];
}

-(void)removeObjectFromArrBugAtIndex:(NSUInteger)index {
    [arrBug removeObjectAtIndex:index];
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
        
        /*for (Bug *bug in selectedObjects)
        {
            // update Task
            //[self updateUser:usr];
        }*/
    }
}



- (void)openBugDetailsWindow:(BOOL)isNewBug {
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
    //NSIndexPath *tskTreeIndexPath;
    //NSUInteger prjArrCtrlIndex;
    NSLog(@"ok");
    
    //if (selectedTabIndex == 1) {
    selectedObjects = [bugArrayCtrl selectedObjects];
    
    //tskTreeIndexPath = [taskTreeCtrl selectionIndexPath];
    //} else {
    //    selectedObjects = [prjArrayCtrl selectedObjects];
    //    
    //    prjArrCtrlIndex = [prjArrayCtrl selectionIndex];
    //}
    
    // if a task is selected, open the window to show its details.
    if ([selectedObjects count] == 1) {
        NSLog(@"ok1");
        bugDetailsWindowController = [[PTBugDetailsWindowController alloc] init];
        bugDetailsWindowController.parentBugListViewController = self;
        bugDetailsWindowController.mainWindowController = mainWindowController;
        bugDetailsWindowController.isNewBug = isNewBug;
        bugDetailsWindowController.bug = [selectedObjects objectAtIndex:0];
        bugDetailsWindowController.bug.project = [parentProjectDetailsViewController project];
        
        if (isNewBug == NO) {
            //bugDetailsWindowController.tskTreeIndexPath = tskTreeIndexPath;
            //taskDetailsWindowControllers.prjArrCtrlIndex = prjArrCtrlIndex;
        }
        
        [bugDetailsWindowController showWindow:self];
        //}];
    }
    //}
}

@end
