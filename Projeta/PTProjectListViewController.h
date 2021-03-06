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
@class PTProgressWindowController;
@class PTProjectDetailsWindowController;

@interface PTProjectListViewController : NSViewController {
    NSMutableArray *arrPrj;     // array qui contient les projets. 
    NSArrayController *prjArrayCtrl;    // array controller
    NSCollectionView *prjCollectionView;
    
    // project details window
    PTProjectDetailsWindowController *projectDetailsWindowController;
    NSTreeController *prjTreeController;
    __weak NSTabView *prjTabView;
    __weak NSOutlineView *prjOutlineView;
    __weak NSMenuItem *addSubProjectButton;
    __weak NSComboBox *clientComboBox;

    // fenêtre avancement.
    PTProgressWindowController *progressWindowController;
    
    // array qui contient les développeurs/responsables. 
    NSMutableArray *arrDevelopers;
    NSMutableArray *arrClients;
    __weak NSPopUpButton *comboStatusFilter;
    __weak NSTextField *minDateFilter;
    __weak NSTextField *maxDateFilter;
    __weak NSButton *filterButton;
    __weak NSPopUpButton *addProjectButton;
    __weak NSButton *removeProjectButton;
}

// array qui contient les projets. 
@property (strong) NSMutableArray *arrPrj;
@property (strong) IBOutlet NSArrayController *prjArrayCtrl;
@property (strong) IBOutlet NSTreeController *prjTreeController;
@property (strong) IBOutlet NSCollectionView *prjCollectionView;
// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;
@property (weak) IBOutlet NSTabView *prjTabView;
@property (weak) IBOutlet NSOutlineView *prjOutlineView;
@property (weak) IBOutlet NSMenuItem *addSubProjectButton;
@property (weak) IBOutlet NSComboBox *clientComboBox;
@property (weak) IBOutlet NSComboBox *developerComboBox;

@property (nonatomic, retain) NSDate *minDateFilterDate;
@property (nonatomic, retain) NSDate *maxDateFilterDate;
@property (weak) IBOutlet NSPopUpButton *addProjectButton;
@property (weak) IBOutlet NSButton *removeProjectButton;

@property (weak) IBOutlet NSButton *startDateCalendarButton;
@property (weak) IBOutlet NSButton *endDateCalendarButton;
@property (strong) IBOutlet NSPopover *calendarPopover;
- (IBAction)startDateCalendarButtonClicked:(id)sender;
- (IBAction)endDateCalendarButtonClicked:(id)sender;

// array qui contient les développeurs/responsables. 
@property (strong) NSMutableArray *arrDevelopers;

// array qui contient les développeurs/responsables. 
@property (strong) NSMutableArray *arrClients;

// nom de la nib file. 
@property (strong) NSString *nibFileName;

// URL à utiliser.
@property (strong) NSString *projectURL;
@property (weak) IBOutlet NSPopUpButton *comboStatusFilter;
@property (weak) IBOutlet NSTextField *minDateFilter;
@property (weak) IBOutlet NSTextField *maxDateFilter;
@property (weak) IBOutlet NSButton *filterButton;

- (void)requestFinished:(NSMutableData*)data;
- (void)requestFailed:(NSError*)error;

// ouvre une fenêtre avec les détails du projet. 
- (void)openProjectDetailsWindow:(BOOL)isNewProject isSubProject:(BOOL)isSubProject ;

- (IBAction)addNewProjectButtonClicked:(id)sender;
- (IBAction)addNewSubProjectButtonClicked:(id)sender;
- (IBAction)detailsButtonClicked:(id)sender;
- (IBAction)removeProjectButtonClicked:(id)sender;
- (IBAction)switchToProjectViewButtonClicked:(id)sender;
- (IBAction)progressButtonClicked:(id)sender;
- (IBAction)commentButtonClicked:(id)sender;
- (IBAction)filterButtonClicked:(id)sender;

@end
