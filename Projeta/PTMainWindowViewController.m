//
//  PTMainWindowViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 13/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "PTMainWindowViewController.h"
#import "SourceListItem.h"
#import "MainWindowController.h"
#import "MWConnectionController.h"
#import "PTCommon.h"
#import "PTRoleHelper.h"
#import "Role.h"

static NSMutableArray *_currentUserRoles = nil;

@implementation PTMainWindowViewController

@synthesize sourceList;
@synthesize splitView;
@synthesize leftView;
@synthesize rightView;
// reference to the (parent) MainWindowController
@synthesize mainWindowController;

@synthesize projectListViewController;
@synthesize taskListViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self = [super initWithNibName:@"PTMainWindowView" bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    // initialize the sidebar (sourcelist)
    [self initializeSidebar];
    
    // expand the first group
    [sourceList expandItem:[sourceListItems objectAtIndex:1]];
}

#pragma mark -
#pragma mark Source List Data Source Methods

- (NSUInteger)sourceList:(PXSourceList*)sourceList numberOfChildrenOfItem:(id)item
{
	//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return [sourceListItems count];
	}
	else {
		return [[item children] count];
	}
}


- (id)sourceList:(PXSourceList*)aSourceList child:(NSUInteger)index ofItem:(id)item
{
	//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return [sourceListItems objectAtIndex:index];
	}
	else {
		return [[item children] objectAtIndex:index];
	}
}

- (id)sourceList:(PXSourceList*)aSourceList objectValueForItem:(id)item
{
	return [item title];
}


- (void)sourceList:(PXSourceList*)aSourceList setObjectValue:(id)object forItem:(id)item
{
	[item setTitle:object];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList isItemExpandable:(id)item
{
	return [item hasChildren];
}

- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasBadge:(id)item
{
	return [item hasBadge];
}


- (NSInteger)sourceList:(PXSourceList*)aSourceList badgeValueForItem:(id)item
{
	return [item badgeValue];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasIcon:(id)item
{
	return [item hasIcon];
}


- (NSImage*)sourceList:(PXSourceList*)aSourceList iconForItem:(id)item
{
	return [item icon];
}

- (NSMenu*)sourceList:(PXSourceList*)aSourceList menuForEvent:(NSEvent*)theEvent item:(id)item
{
	if ([theEvent type] == NSRightMouseDown || ([theEvent type] == NSLeftMouseDown && ([theEvent modifierFlags] & NSControlKeyMask) == NSControlKeyMask)) {
		NSMenu __autoreleasing *m = [[NSMenu alloc] init];
		if (item != nil) {
			[m addItemWithTitle:[item title] action:nil keyEquivalent:@""];
		} else {
			[m addItemWithTitle:@"clicked outside" action:nil keyEquivalent:@""];
		}
		return m;
	}
	return nil;
}


#pragma mark -
#pragma mark Source List Delegate Methods

- (BOOL)sourceList:(PXSourceList*)aSourceList isGroupAlwaysExpanded:(id)group
{
	if([[group identifier] isEqualToString:@"projectsHeader"] || [[group identifier] isEqualToString:@"administrationHeader"])
		return YES;
	
	return NO;
}

- (void)sourceListSelectionDidChange:(NSNotification *)notification
{
	NSIndexSet *selectedIndexes = [sourceList selectedRowIndexes];
	
	//Set the label text to represent the new selection
	if([selectedIndexes count]>1)
    {
		//[selectedItemLabel setStringValue:@"(multiple)"];
    }
	else if([selectedIndexes count]==1) {
		NSString *identifier = [[sourceList itemAtRow:[selectedIndexes firstIndex]] identifier];
		
        if (identifier == @"projects") {
            
            [self removeViewsFromRightView];
            
            if (!projectListViewController) {
       
                projectListViewController = [[PTProjectListViewController alloc] init];
                
                // set reference to (parent) window
                [projectListViewController setMainWindowController:mainWindowController];
                
                // resize the view to fit and fill the right splitview view
                [projectListViewController.view setFrameSize:rightView.frame.size];
                
                [self.rightView addSubview:projectListViewController.view];
                
                // auto resize the view.
                [projectListViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
            }
        }
        else if (identifier == @"tasks") {
            
            [self removeViewsFromRightView];
            
            if (!taskListViewController) {
                
                taskListViewController = [[PTTaskListViewController alloc] init];
                
                // set reference to (parent) window
                [taskListViewController setMainWindowController:mainWindowController];
                
                // resize the view to fit and fill the right splitview view
                [taskListViewController.view setFrameSize:rightView.frame.size];
                
                [self.rightView addSubview:taskListViewController.view];
                
                // auto resize the view.
                [taskListViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
            }
        }
        else {
            // free some memory
            [self removeViewsFromRightView];
        }
	}
	else {
		//[selectedItemLabel setStringValue:@"(none)"];
	}
}

- (void)removeViewsFromRightView
{
    if (projectListViewController) {
        [projectListViewController.view removeFromSuperview];
        projectListViewController = nil;
    }
    
    if (taskListViewController) {
        [taskListViewController.view removeFromSuperview];
        taskListViewController = nil;
    }
}


- (void)sourceListDeleteKeyPressedOnRows:(NSNotification *)notification
{
	NSIndexSet *rows = [[notification userInfo] objectForKey:@"rows"];
	
	NSLog(@"Delete key pressed on rows %@", rows);
	
	//Do something here
}


#pragma mark -
#pragma mark Initialize and populate sidebar

- (void)initializeSidebar
{
    sourceListItems = [[NSMutableArray alloc] init];
	
	//Set up the "Library" parent item and children
	//SourceListItem *libraryItem = [SourceListItem itemWithTitle:@"LIBRARY" identifier:@"library"];
    SourceListItem *projectsHeaderItem = [SourceListItem itemWithTitle:NSLocalizedString(@"PROJECTS", nil) identifier:@"projectsHeader"];
	SourceListItem *projectsItem = [SourceListItem itemWithTitle:@"Projects" identifier:@"projects"];
	[projectsItem setIcon:[NSImage imageNamed:@"music.png"]];
	SourceListItem *tasksItem = [SourceListItem itemWithTitle:@"Tasks" identifier:@"tasks"];
	[tasksItem setIcon:[NSImage imageNamed:@"movies.png"]];
	SourceListItem *podcastsItem = [SourceListItem itemWithTitle:@"Podcasts" identifier:@"podcasts"];
	[podcastsItem setIcon:[NSImage imageNamed:@"podcasts.png"]];
	[podcastsItem setBadgeValue:10];
	SourceListItem *audiobooksItem = [SourceListItem itemWithTitle:@"Audiobooks" identifier:@"audiobooks"];
	[audiobooksItem setIcon:[NSImage imageNamed:@"audiobooks.png"]];
	[projectsHeaderItem setChildren:[NSArray arrayWithObjects:projectsItem, tasksItem, podcastsItem,
							  audiobooksItem, nil]];
    
	
	//Set up the "Playlists" parent item and children
	SourceListItem *playlistsItem = [SourceListItem itemWithTitle:@"PLAYLISTS" identifier:@"playlists"];
	SourceListItem *playlist1Item = [SourceListItem itemWithTitle:@"Playlist1" identifier:@"playlist1"];
	
	//Create a second-level group to demonstrate
	SourceListItem *playlist2Item = [SourceListItem itemWithTitle:@"Playlist2" identifier:@"playlist2"];
	SourceListItem *playlist3Item = [SourceListItem itemWithTitle:@"Playlist3Playlist3Playlist3Playlist3Playlist3" identifier:@"playlist3"];
    [playlist3Item setBadgeValue:50];
	//[playlist1Item setIcon:[NSImage imageNamed:@"playlist.png"]];
	[playlist2Item setIcon:[NSImage imageNamed:@"playlist.png"]];
	[playlist3Item setIcon:[NSImage imageNamed:@"playlist.png"]];
	
	SourceListItem *playlistGroup = [SourceListItem itemWithTitle:@"Playlist Group" identifier:@"playlistgroup"];
	SourceListItem *playlistGroupItem = [SourceListItem itemWithTitle:@"Child Playlist" identifier:@"childplaylist"];
	[playlistGroup setIcon:[NSImage imageNamed:@"playlistFolder.png"]];
	[playlistGroupItem setIcon:[NSImage imageNamed:@"playlist.png"]];
	[playlistGroup setChildren:[NSArray arrayWithObject:playlistGroupItem]];
	
	[playlistsItem setChildren:[NSArray arrayWithObjects:playlist1Item, playlistGroup,playlist2Item,
								playlist3Item, nil]];
	
	[sourceListItems addObject:projectsHeaderItem];
	[sourceListItems addObject:playlistsItem];
	
	[sourceList reloadData];
    
    
    //
    [self userRoleInitializations];
}

- (void)userRoleInitializations
{
    if (!_currentUserRoles) {
        _currentUserRoles = [[NSMutableArray alloc] init];
        
        // get server URL as string
        NSString *urlString = [PTCommon serverURLString];
        // build URL by adding resource path
        urlString = [urlString stringByAppendingString:@"resources/be.luckycode.projetawebservice.users/username/"];
        urlString = [urlString stringByAppendingString:@"admin/roles"];
        
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
        
        [connectionController startRequestForURL:url setRequest:urlRequest];
        
        
    } else {
        [self showAdminMenu];
    }
}

- (void)requestFinished:(NSMutableData*)data {
    NSError *error;
    
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];

    [_currentUserRoles addObjectsFromArray:[PTRoleHelper setAttributesFromJSONDictionary:dict]];
    
    [self showAdminMenu];
}

- (void)requestFailed:(NSError*)error {
    
}

- (void)showAdminMenu {
    
    for (Role *r in _currentUserRoles) {
        
        if ([r.code isEqualToString:@"administrator"])
        {
            SourceListItem *administrationHeaderItem = [SourceListItem itemWithTitle:NSLocalizedString(@"ADMINISTRATION", nil) identifier:@"administrationHeader"];
            
            SourceListItem *userAdminItem = [SourceListItem itemWithTitle:@"Users" identifier:@"userAdmin"];
            
            [administrationHeaderItem setChildren:[NSArray arrayWithObjects:userAdminItem, nil]];
            
            [sourceListItems addObject:administrationHeaderItem];
            
            [sourceList reloadData];
        }
    }
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
    
    //NSLog(@"scrolled on PTMainViewController");
    
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
                                 
                                 // if left swipe, switch to main view
                                 if ([event deltaX] < 0) 
                                     [mainWindowController switchToProjectView:self];
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

@end
