//
//  PTProjectViewController.h
//  Projeta
//
//  Created by Michael Wermeester on 14/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;
@class PTProjectDetailsViewController;
@class PXSourceList;

@interface PTProjectViewController : NSViewController {
    NSMutableArray *sourceListItems;

    NSMutableArray *arrPrj;     // array which holds the projects
    NSTreeController *prjTreeController;
    
    NSSplitView *splitView;
    NSView *leftView;
    NSView *rightView;
    PXSourceList *sourceList;
    NSOutlineView *altSourceList;
    NSButton *testButton;
    NSOutlineView *outlineView;
    
    PTProjectDetailsViewController *projectDetailsViewController;
}


@property (strong) NSMutableArray *arrPrj;
@property (strong) IBOutlet NSTreeController *prjTreeController;

@property (assign) MainWindowController *mainWindowController;
@property (strong) PTProjectDetailsViewController *projectDetailsViewController;
@property (strong) IBOutlet NSSplitView *splitView;
@property (strong) IBOutlet NSView *leftView;
@property (strong) IBOutlet NSView *rightView;
@property (strong) IBOutlet PXSourceList *sourceList;
- (IBAction)testButtonClick:(id)sender;
@property (strong) IBOutlet NSOutlineView *altOutlineView;
@property (strong) IBOutlet NSButton *testButton;



@end
