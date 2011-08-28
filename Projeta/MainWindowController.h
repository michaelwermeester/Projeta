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
    NSProgressIndicator *progressIndicator;
}

@property (strong) IBOutlet NSView *mainView;
// circular progress indicator
@property (strong) IBOutlet NSProgressIndicator *progressIndicator;

@property (strong) PTMainWindowViewController *mainWindowViewController;
@property (strong) PTProjectViewController *projectViewController;

// used for NSProgressIndicator
@property (assign) NSInteger progressCount;

- (IBAction)switchToMainView:(id)sender;
- (IBAction)switchToProjectView:(id)sender;

- (NSRect)frameWithContentViewFrameSize;

// start/stop animating the circular progress indicator.
- (void)startProgressIndicatorAnimation;
- (void)stopProgressIndicatorAnimation;

@end
