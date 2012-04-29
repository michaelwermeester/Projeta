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
@class Progress;
@class Project;
@class Task;

@interface PTProgressWindowController : NSWindowController {
    __weak WebView *progressWebView;
    __weak NSButton *sendProgressButton;
    
    Progress *progress;
    
    NSMutableArray *arrStatus;
    __weak NSComboBox *statusComboBox;
}


@property (strong) NSMutableArray *arrStatus;

@property (strong) Bug *bug;
@property (strong) Project *project;
@property (strong) Task *task;

@property (strong) Progress *progress;

// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;
@property (weak) IBOutlet WebView *progressWebView;
@property (weak) IBOutlet NSButton *sendProgressButton;
- (IBAction)sendProgressButtonClicked:(id)sender;
@property (weak) IBOutlet NSComboBox *statusComboBox;

- (void)initStatusArray;

@end
