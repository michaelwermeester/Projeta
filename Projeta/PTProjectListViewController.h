//
//  PTProjectListViewController.h
//  Projeta
//
//  Created by Michael Wermeester on 26/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Project.h"

@class MainWindowController;
@class PTProjectDetailsWindowController;

@interface PTProjectListViewController : NSViewController {
    NSMutableArray *arrPrj;     // array which holds the projects
    NSArrayController *prjArrayCtrl;    // array controller
    NSCollectionView *prjCollectionView;
    
    // user details window
    PTProjectDetailsWindowController *projectDetailsWindowController;
    NSTreeController *prjTreeController;
    __weak NSTabView *prjTabView;
    __weak NSOutlineView *prjOutlineView;
    __weak NSMenuItem *addSubProjectButton;
}

@property (strong) NSMutableArray *arrPrj;
@property (strong) IBOutlet NSArrayController *prjArrayCtrl;
@property (strong) IBOutlet NSTreeController *prjTreeController;
@property (strong) IBOutlet NSCollectionView *prjCollectionView;
// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;
@property (weak) IBOutlet NSTabView *prjTabView;
@property (weak) IBOutlet NSOutlineView *prjOutlineView;
@property (weak) IBOutlet NSMenuItem *addSubProjectButton;

- (void)requestFinished:(NSMutableData*)data;
- (void)requestFailed:(NSError*)error;

- (IBAction)addNewProjectButtonClicked:(id)sender;
- (IBAction)addNewSubProjectButtonClicked:(id)sender;
- (IBAction)detailsButtonClicked:(id)sender;
- (IBAction)removeProjectButtonClicked:(id)sender;

- (void)openProjectDetailsWindow:(BOOL)isNewProject isSubProject:(BOOL)isSubProject ;

@end
