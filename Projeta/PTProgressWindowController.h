//
//  PTProgressWindowController.h
//  Projeta
//
//  Created by Michael Wermeester on 4/28/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Webkit/Webkit.h>

@class Bug;
@class MainWindowController;
@class Project;
@class Task;

@interface PTProgressWindowController : NSWindowController {
    __weak WebView *progressWebView;
}



@property (strong) Bug *bug;
@property (strong) Project *project;
@property (strong) Task *task;

// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;
@property (weak) IBOutlet WebView *progressWebView;

@end
