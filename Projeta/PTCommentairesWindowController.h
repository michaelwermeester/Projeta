//
//  PTCommentairesWindowController.h
//  Projeta
//
//  Created by Michael Wermeester on 4/9/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Bug;
@class MainWindowController;
@class Project;
@class PTCommentairesViewController;
@class Task;

@interface PTCommentairesWindowController : NSWindowController {
    __weak NSView *commentsView;
}

@property (strong) Bug *bug;
@property (strong) Project *project;
@property (strong) Task *task;

@property (strong) PTCommentairesViewController *commentViewController;

// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;

@property (weak) IBOutlet NSView *commentsView;

@end
