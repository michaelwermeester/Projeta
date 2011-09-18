//
//  PTTaskListViewController.h
//  Projeta
//
//  Created by Michael Wermeester on 06/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;

@interface PTTaskListViewController : NSViewController {
    NSMutableArray *arrTask;     // array which holds the projects
    NSArrayController *taskArrayCtrl;
    NSTreeController *taskTreeCtrl;
    NSOutlineView *taskOutlineView;
}

@property (strong) NSMutableArray *arrTask;
@property (strong) IBOutlet NSArrayController *taskArrayCtrl;
@property (strong) IBOutlet NSTreeController *taskTreeCtrl;
@property (strong) IBOutlet NSOutlineView *taskOutlineView;
- (IBAction)testButtonClick:(id)sender;


// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;

- (void)requestFinished:(NSMutableData*)data;
- (void)requestFailed:(NSError*)error;

@property (strong) NSArray *mySortOrder;

@end
