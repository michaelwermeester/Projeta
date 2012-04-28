//
//  PTProgressWindowController.m
//  Projeta
//
//  Created by Michael Wermeester on 4/28/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "PTProgressWindowController.h"

@interface PTProgressWindowController ()

@end

@implementation PTProgressWindowController

@synthesize bug;
@synthesize mainWindowController;
@synthesize progressWebView;
@synthesize project;
@synthesize task;

- (id)init
{
    self = [super initWithWindowNibName:@"PTProgressWindow"];
    //self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
