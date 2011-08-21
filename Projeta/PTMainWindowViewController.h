//
//  PTMainWindowViewController.h
//  Projeta
//
//  Created by Michael Wermeester on 13/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PXSourceList.h"
@class MainWindowController;

@interface PTMainWindowViewController : NSViewController <PXSourceListDataSource, PXSourceListDelegate> {
    NSMutableArray *sourceListItems;
    NSSplitView *splitView;
    NSView *leftView;
    NSView *rightView;
}

@property (strong) IBOutlet PXSourceList *sourceList;
@property (strong) IBOutlet NSSplitView *splitView;
@property (strong) IBOutlet NSView *leftView;
@property (strong) IBOutlet NSView *rightView;
// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;

- (void)initializeSidebar;

@end
