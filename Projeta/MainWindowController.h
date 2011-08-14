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

@interface MainWindowController : NSWindowController <NSWindowDelegate> {
    
    NSView *mainView;
}

@property (strong) IBOutlet NSView *mainView;

@property (strong) PTMainWindowViewController *mainWindowViewController;
@property (strong) PTProjectViewController *projectViewController;

- (IBAction)switchToMainView:(id)sender;
- (IBAction)switchToProjectView:(id)sender;

- (NSRect)frameWithContentViewFrameSize;

@end
