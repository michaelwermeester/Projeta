//
//  PTProjectDetailsWindowController.h
//  Projeta
//
//  Created by Michael Wermeester on 01/11/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;
@class Project;
@class PTProjectListViewController;

@interface PTProjectDetailsWindowController : NSWindowController {
    
    BOOL isNewProject;
    __weak NSButton *okButton;
    __weak NSComboBox *comboDevelopers;
    
    NSMutableArray *arrDevelopers;
}

@property (strong) Project *project;

@property (assign) BOOL isNewProject;

@property (strong) NSMutableArray *arrDevelopers;

// test -- can remove
@property (strong) NSIndexPath *prjTreeIndexPath;
@property (assign) NSUInteger prjArrCtrlIndex;

// parent project list view controller.
@property (strong) PTProjectListViewController *parentProjectListViewController;
// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;
@property (weak) IBOutlet NSButton *okButton;
@property (weak) IBOutlet NSComboBox *comboDevelopers;

@property (readonly) NSString *windowTitle;

- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)okButtonClicked:(id)sender;

// charger la liste des développeurs à partir du webservice et les mettre dans la combobox.
- (void)fetchDevelopersFromWebservice;

@end
