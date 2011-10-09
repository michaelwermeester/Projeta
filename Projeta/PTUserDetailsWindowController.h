//
//  PTUserDetailsWindowController.h
//  Projeta
//
//  Created by Michael Wermeester on 24/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class User;
@class Role;

@interface PTUserDetailsWindowController : NSWindowController {
    NSTableView *userRolesTableView;
}


@property (strong) User *user;
// Holds the available roles which can be affected. 
@property (strong) NSMutableArray *availableRoles;
@property (strong) IBOutlet NSTableView *userRolesTableView;

@end
