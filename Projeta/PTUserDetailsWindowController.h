//
//  PTUserDetailsWindowController.h
//  Projeta
//
//  Created by Michael Wermeester on 24/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "User.h"

@interface PTUserDetailsWindowController : NSWindowController {
    NSTableView *userRolesTableView;
}


@property (strong) User *user;
@property (strong) IBOutlet NSTableView *userRolesTableView;

@end
