//
//  MainWindow.h
//  Projeta
//
//  Created by Michael Wermeester on 17/06/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PTMainWindowViewController.h"
#import "PTProjectViewController.h"

@class User;

@interface MainWindowController : NSWindowController <NSWindowDelegate> {
    
    NSView *mainView;
    NSProgressIndicator *progressIndicator;
    NSToolbarItem *detailViewToolbarItem;
    NSSearchField *searchField;
    
    User *loggedInUser;
    __weak NSPopUpButton *addProjectButton;
    __weak NSMenuItem *addProjectMenuItem;
    __weak NSMenuItem *addSubProjectMenuItem;
    __weak NSButton *removeProjectButton;
}

@property (strong) IBOutlet NSView *mainView;
// circular progress indicator
@property (strong) IBOutlet NSProgressIndicator *progressIndicator;

@property (strong) PTMainWindowViewController *mainWindowViewController;
@property (strong) PTProjectViewController *projectViewController;

@property (strong) IBOutlet NSToolbarItem *detailViewToolbarItem;

// used for NSProgressIndicator
@property (assign) NSInteger progressCount;
@property (strong) IBOutlet NSSearchField *searchField;

@property (strong) User *loggedInUser;

// bouton pour ajouter des projets ou sous-projets.
@property (weak) IBOutlet NSPopUpButton *addProjectButton;
@property (weak) IBOutlet NSMenuItem *addProjectMenuItem;
@property (weak) IBOutlet NSMenuItem *addSubProjectMenuItem;
@property (weak) IBOutlet NSButton *removeProjectButton;

- (IBAction)switchToMainView:(id)sender;
- (IBAction)switchToProjectView:(id)sender;
- (IBAction)addProjectButtonClicked:(id)sender;
- (IBAction)addSubProjectButtonClicked:(id)sender;

- (NSRect)frameWithContentViewFrameSize;

// start/stop animating the circular progress indicator.
- (void)startProgressIndicatorAnimation;
- (void)stopProgressIndicatorAnimation;


@property (nonatomic, assign) BOOL hideAdminControls;

@end
