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
@class PTGanttView;
@class PTProjectDetailsViewController;

@interface PTGanttViewController : NSViewController {
    __weak PTGanttView *ganttView;
    __weak NSScrollView *scrollView;
}

// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;
// reference to the (parent) PTProjectDetailsViewController
@property (assign) PTProjectDetailsViewController *parentProjectDetailsViewController;
@property (weak) IBOutlet NSScrollView *scrollView;

// Le projet.
@property (strong) Project *project;
// La view Gantt.
@property (weak) IBOutlet PTGanttView *ganttView;

// initialiser les paramètres du diagramme de Gantt. 
- (void)loadGantt;

@end
