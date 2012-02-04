//
//  PTGroupManagementViewController.h
//  Projeta
//
//  Created by Michael Wermeester on 31/10/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;
@class BugCategory;

@interface PTBugCategoryManagementViewController : NSViewController {
    NSMutableArray *arrBugCat;     // array which holds the user groups.
    NSArrayController *bugCategoryArrayCtrl;
    NSTableView *bugCategoryTableView;
}

@property (strong) NSMutableArray *arrBugCat;
@property (strong) IBOutlet NSArrayController *bugCategoryArrayCtrl;
@property (strong) IBOutlet NSTableView *bugCategoryTableView;

// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;

// Fetch user groups from webservice.
- (void)fetchBugCategories;

- (void)fetchRequestFinished:(NSMutableData*)data;
- (void)fetchRequestFailed:(NSError*)error;

- (IBAction)addBugCategoryButtonClicked:(id)sender;

- (void)updateBugCategory:(BugCategory *)theUsergroup;


@end
