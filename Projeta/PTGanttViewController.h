//
//  PTGanttViewController.h
//  Projeta
//
//  Created by Michael Wermeester on 5/5/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Project;
@class MainWindowController;
@class PTProjectDetailsViewController;

@interface PTGanttViewController : NSViewController


// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;
// reference to the (parent) PTProjectDetailsViewController
@property (assign) PTProjectDetailsViewController *parentProjectDetailsViewController;

@property (strong) Project *project;

- (void)loadGantt;

@end
