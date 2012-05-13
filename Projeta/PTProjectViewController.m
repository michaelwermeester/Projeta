//
//  PTProjectViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 14/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "MainWindowController.h"
#import "MWTableCellView.h"
#import "PTProjectDetailsViewController.h"
#import "PTProjectViewController.h"
#import "SourceListItem.h"
#import "Project.h"

@implementation PTProjectViewController
@synthesize altOutlineView;
@synthesize testButton;

@synthesize arrPrj;
@synthesize prjTreeController;

@synthesize mainWindowController;
@synthesize projectDetailsViewController;
@synthesize splitView;
@synthesize leftView;
@synthesize rightView;
@synthesize sourceList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self = [super initWithNibName:@"PTProjectView" bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.

        [outlineView setFloatsGroupRows:NO];
    }
    
    return self;
}

-(void)awakeFromNib {
    // expand item ( http://stackoverflow.com/questions/519751/nsoutlineview-auto-expand-all-nodes )
    [altOutlineView expandItem:nil expandChildren:YES];
    
    // sélectionner le premier élément de l'outlineview.
    //[altOutlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];
}

// sélectionner project principal. 
// Ne pas mettre cet appel de méthode dans awakeFromNib -> problème lors de création d'un nouveau projet.
- (void)selectMainProject {
    // sélectionner le premier élément de l'outlineview.
    [altOutlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];
}

- (void)loadView
{
    [super loadView];
    
    projectDetailsViewController = [[PTProjectDetailsViewController alloc] init];
    
    // set reference to self.
    projectDetailsViewController.projectViewController = self;
    projectDetailsViewController.mainWindowController = self.mainWindowController;
    
    // resize the view to fit and fill the right splitview view
    [projectDetailsViewController.view setFrameSize:rightView.frame.size];
    
    [self.rightView addSubview:projectDetailsViewController.view];
    
    // auto resize the view.
    [projectDetailsViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    // 
    projectDetailsViewController.project = [[prjTreeController selectedObjects] objectAtIndex:0];
    
    // charger les utilisateurs, groupes et clients liés au projet.
    [projectDetailsViewController loadProjectDetails];
    // charger les tâches liés au projet.
    [projectDetailsViewController loadTasks];
    // charger les bogues liés au projet.
    [projectDetailsViewController loadBugs];
    // charger les commentaires liés au projet.
    [projectDetailsViewController loadComments];
    // charger le diagramme de Gantt lié au projet.
    [projectDetailsViewController loadGantt];
}

#pragma mark -
#pragma mark View resizing

// properly resize the splitview (only resize right view, don't touch the left one)
- (void)splitView:(NSSplitView *)sender resizeSubviewsWithOldSize:(NSSize)oldSize
{
    // IB outlets
    // IBOutlet NSView *leftView;
    // IBOutlet NSView *rightView;
    NSSize splitViewSize = [sender frame].size;
    
    NSSize leftSize = [leftView frame].size;
    leftSize.height = splitViewSize.height;
    
    NSSize rightSize;
    rightSize.height = splitViewSize.height;
    rightSize.width = splitViewSize.width - [sender dividerThickness] - leftSize.width;
    
    [leftView setFrameSize:leftSize];
    [rightView setFrameSize:rightSize];
}

#pragma mark -
#pragma mark Gestures handling (trackpad and mouse events)

- (BOOL)wantsScrollEventsForSwipeTrackingOnAxis:(NSEventGestureAxis)axis 
{
    return (axis == NSEventGestureAxisHorizontal) ? YES : NO;
}

- (void)scrollWheel:(NSEvent *)event 
{
    // NSScrollView is instructed to only forward horizontal scroll gesture events (see code above). However, depending
    // on where your controller is in the responder chain, it may receive other scrollWheel events that we don't want
    // to track as a fluid swipe because the event wasn't routed though an NSScrollView first.
    if ([event phase] == NSEventPhaseNone) return; // Not a gesture scroll event.
    if (fabsf([event scrollingDeltaX]) <= fabsf([event scrollingDeltaY])) return; // Not horizontal
    // If the user has disabled tracking scrolls as fluid swipes in system preferences, we should respect that.
    // NSScrollView will do this check for us, however, depending on where your controller is in the responder chain,
    // it may scrollWheel events that are not filtered by an NSScrollView.
    if (![NSEvent isSwipeTrackingFromScrollEventsEnabled]) return;
    
    //NSLog(@"scrolled on PTProjectViewController");
    
    __block BOOL animationCancelled = NO;
    [event trackSwipeEventWithOptions:0 dampenAmountThresholdMin:-5 max:5
                         usingHandler:^(CGFloat gestureAmount, NSEventPhase phase, BOOL isComplete, BOOL *stop) {
                             if (animationCancelled) {
                                 *stop = YES;
                                 // Tear down animation overlay
                                 return;
                             }
                             if (phase == NSEventPhaseBegan) {
                                 // Setup animation overlay layers
                             }
                             // Update animation overlay to match gestureAmount
                             if (phase == NSEventPhaseEnded) {
                                 // The user has completed the gesture successfully.
                                 // This handler will continue to get called with updated gestureAmount
                                 // to animate to completion, but just in case we need
                                 // to cancel the animation (due to user swiping again) setup the
                                 // controller / view to point to the new content / index / whatever
                                 
                                 // if right swipe, switch to main view
                                 if ([event deltaX] > 0) 
                                     [mainWindowController switchToMainView:self];
                             } else if (phase == NSEventPhaseCancelled) {
                                 // The user has completed the gesture un-successfully.
                                 // This handler will continue to get called with updated gestureAmount
                                 // But we don't need to change the underlying controller / view settings.
                             }
                             if (isComplete) {
                                 // Animation has completed and gestureAmount is either -1, 0, or 1.
                                 // This handler block will be released upon return from this iteration.
                                 // Note: we already updated our view to use the new (or same) content
                                 // above. So no need to do that here. Just...
                                 // Tear down animation overlay here
                                 //self->_swipeAnimationCanceled = NULL;
                             }
                         }];
}


- (void)removeViewsFromRightView
{
    
}


- (void)sourceListDeleteKeyPressedOnRows:(NSNotification *)notification
{
	NSIndexSet *rows = [[notification userInfo] objectForKey:@"rows"];
	
	NSLog(@"Delete key pressed on rows %@", rows);
	
	//Do something here
}



- (IBAction)testButtonClick:(id)sender {
    NSLog(@"title: %@", [[altSourceList selectedCell] title]);
}

/*- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
    //In my case a item is group when the (Core Data) parent relationship is nil.
    if ([item isKindOfClass:[Project class]] == YES)
    {
        NSLog(@"YAY");
    if ([item parentProjectId] == nil)
        return YES;
    else
        return NO;
        return YES;
    } else
        return NO;
    
}*/

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
    if ([altOutlineView parentForItem:item]) {
        // If not nil; then the item has a parent.
        return NO;
    }
    return YES;
}

// needed for the outline view to show text.
- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    
    if ([[item representedObject] isKindOfClass:[Project class]]) {
        Project *tmpPrj = [item representedObject];
        
        if (tmpPrj.parentProjectId == nil) {
            return [altOutlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
        } else {
            // set badge count
            MWTableCellView *tmpView = [altOutlineView makeViewWithIdentifier:@"DataCell" owner:self];
            //[tmpView setBadgeCount:tmpPrj.projectDescription];
            //[tmpView setBadgeCount:@"1bkjbhjb;hbhj"];
            
            //NSRect r = tmpView.badgeButton.frame;
            
            //r.origin.x -= 15;
            //r.size.width -= 15;
            //r.size.height = 1;
            //r.origin.x = tmpView.badgeButton.frame.size.width - 100;
            
            //NSLog(@"bounds.origin.x: %f", label.bounds.origin.x);

            //[[tmpView badgeButton] setBoundsSize:s];
            //[[tmpView badgeButton] setFrame:r];
            //[[tmpView badgeButton] setFrame:CGRectMake(0, 0, 60, 60)];
            
            NSArray *supectConstraints = [tmpView.badgeButton constraintsAffectingLayoutForOrientation:NSLayoutConstraintOrientationHorizontal];
            
            [rightView addSubview:tmpView];
            [mainWindowController.window visualizeConstraints:supectConstraints];
            
            return tmpView;
        }
    }
    
    if ([[item representedObject] isKindOfClass:[OutlineCollection class]]) {
        return [altOutlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
    }   
    
    
    return nil;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    
    // si l'élément sélectionné est un projet, afficher le détail.
    if ([[[prjTreeController selectedObjects] objectAtIndex:0] isKindOfClass:[Project class]]) {
    
        projectDetailsViewController.project = [[prjTreeController selectedObjects] objectAtIndex:0];
        
        
        // mémoriser date début et date fin du projet parent.
        
        // get parent node.
        NSTreeNode *parent = [[[[prjTreeController selectedNodes] objectAtIndex:0] parentNode] parentNode];
        NSMutableArray *parentProjects = [[parent representedObject] mutableArrayValueForKeyPath:
                                          [prjTreeController childrenKeyPathForNode:parent]];
        // get projectid du projet parent. 
        for (Project *p in parentProjects)
        {
            
            if ([p.childObject containsObject:[[prjTreeController selectedObjects] objectAtIndex:0]])
            {
                if (p.startDate) {
                    projectDetailsViewController.parentProjectStartDate = p.startDate;
                }
                if (p.endDate)
                    projectDetailsViewController.parentProjectEndDate = p.endDate;

                break;
            }
        }
    } 
    else {
        projectDetailsViewController.project = nil;
    }
    
}

// Si l'élément sélectionné dans la source list est un project, sélectionner ce projet.
// S'il ne s'agit pas d'un projet, ne pas sélectionner l'élément.
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item {
    
    if ([[item representedObject] isKindOfClass:[Project class]]) {
        return YES;
    } else {
        return NO;
    }
}

@end
