//
//  PTUsersWindowController.m
//  Projeta
//
//  Created by Michael Wermeester on 04/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import "PTUserManagementWindowController.h"
#import "PTUserManagementViewController.h"

@implementation PTUserManagementWindowController
@synthesize usersView;

- (id)init
{
    self = [super initWithWindowNibName:@"PTUserManagementWindow"];
    if(self)
    {
        //perform any initializations
    }
    return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    PTUserManagementViewController *usrView = [[PTUserManagementViewController alloc] init];
    [self.usersView addSubview:usrView.view];
}

@end
