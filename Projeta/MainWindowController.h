//
//  MainWindow.h
//  Projeta
//
//  Created by Michael Wermeester on 17/06/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PTMainWindowViewController.h"

@interface MainWindowController : NSWindowController <NSWindowDelegate> {
    
    NSView *mainView;
}

@property (strong) IBOutlet NSView *mainView;

@property (strong) PTMainWindowViewController *mainWindowViewController;

@end
