//
//  PTUserDetailsWindowController.m
//  Projeta
//
//  Created by Michael Wermeester on 24/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "PTUserDetailsWindowController.h"

#import "User.h"
#import "Role.h"

@implementation PTUserDetailsWindowController

@synthesize user;
// Holds the available roles which can be affected.
@synthesize availableRoles;
@synthesize userRolesTableView;

- (id)init
{
    self = [super initWithWindowNibName:@"PTUserDetailsWindow"];
    //self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib {
    
    // remove roles already affected to user from available roles list.
    for (Role *r in user.roles) {
        
        for (NSUInteger i = 0; i < [availableRoles count]; i++) {
            
            // if role found.
            if ([[availableRoles objectAtIndex:i] isEqual:r]) {
                
                // remove role.
                [availableRoles removeObjectAtIndex:i];
            }
        }
    }
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    // sort user roles alphabetically. 
    //[self willChangeValueForKey:@"user.roles"];
    
    //[user.roles sortUsingComparator:^NSComparisonResult(Role *r1, Role *r2) {
    //    
    //    return [r1.code compare:r2.code];
    //    
    //    /*if ([r1.code compare:r2.code] == NSOrderedSame) {
    //        return [r1.code compare:r2.code];
    //    } else {
    //        return [r1.code compare:r2.code];
    //    }*/
    //}];
    //[self didChangeValueForKey:@"user.roles"];
    
    /*if ([user.roles isKindOfClass:[NSMutableArray class]])
        NSLog(@"mutable");
    else
        NSLog(@"nonmutable");*/
    
    
}

@end
