//
//  PTProjectDetailsWindowController.m
//  Projeta
//
//  Created by Michael Wermeester on 01/11/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "Project.h"
#import "PTProjectDetailsWindowController.h"

@implementation PTProjectDetailsWindowController

@synthesize project;

@synthesize isNewProject;

@synthesize parentProjectListViewController;
@synthesize mainWindowController;


- (id)init
{
    self = [super initWithWindowNibName:@"PTProjectDetailsWindow"];
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



- (IBAction)cancelButtonClicked:(id)sender {
}

- (IBAction)okButtonClicked:(id)sender {
}
@end
