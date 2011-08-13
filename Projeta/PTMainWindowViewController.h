//
//  PTMainWindowViewController.h
//  Projeta
//
//  Created by Michael Wermeester on 13/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PXSourceList.h"

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

- (void)initializeSidebar;

@end
