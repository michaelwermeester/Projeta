//
//  MainWindow.h
//  Projeta
//
//  Created by Michael Wermeester on 17/06/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PTSidebarViewController.h"

@interface MainWindowController : NSWindowController <NSWindowDelegate> {
    
    NSView *sidebarView;
}

@property (strong) PTSidebarViewController *sidebarViewController;
@property (strong) IBOutlet NSView *sidebarView;

@end
