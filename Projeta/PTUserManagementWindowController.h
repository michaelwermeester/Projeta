//
//  PTUsersWindowController.h
//  Projeta
//
//  Created by Michael Wermeester on 04/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PTUserManagementViewController.h"

@interface PTUserManagementWindowController : NSWindowController {
    NSView *usersView;
}

@property (strong) PTUserManagementViewController *userManagementViewController;
@property (strong) IBOutlet NSView *usersView;

@end
