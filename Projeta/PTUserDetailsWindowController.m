//
//  PTUserDetailsWindowController.m
//  Projeta
//
//  Created by Michael Wermeester on 24/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "PTUserDetailsWindowController.h"

#import "MWConnectionController.h"
#import "PTCommon.h"
#import "User.h"
#import "Role.h"

@implementation PTUserDetailsWindowController
@synthesize userRolesArrayCtrl;
@synthesize availableRolesArrayCtrl;

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
                [[self mutableArrayValueForKey:@"availableRoles"] removeObjectAtIndex:i];
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

// assign selected user role(s) to user. 
- (IBAction)assignUserRoles:(id)sender {
    
    // get selection of roles to be affected to user.
    NSArray *selectedRoles = [availableRolesArrayCtrl selectedObjects];
     
    for (Role *role in selectedRoles) {
        // affect new role to user.
        [userRolesArrayCtrl addObject:role];
        
        // remove role from available roles.
        [availableRolesArrayCtrl removeObject:role];
        
        // sort user roles alphabetically.
        [user.roles sortUsingComparator:^NSComparisonResult(Role *r1, Role *r2) {
            
            return [r1.code compare:r2.code];
        }];
    }
}

// remove selected user role(s) from user.
- (IBAction)removeUserRoles:(id)sender {
    
    // get selection of roles to be removed from user.
    NSArray *selectedRoles = [userRolesArrayCtrl selectedObjects];
    
    for (Role *role in selectedRoles) {
        // make role available.
        [availableRolesArrayCtrl addObject:role];
        
        // remove role from user roles.
        [userRolesArrayCtrl removeObject:role];
        
        // sort user roles alphabetically.
        [availableRoles sortUsingComparator:^NSComparisonResult(Role *r1, Role *r2) {
            
            return [r1.code compare:r2.code];
        }];
    }
}

- (IBAction)okButtonClicked:(id)sender {
    
    [self updateUserRoles];
}

- (IBAction)cancelButtonClicked:(id)sender {
    
}

- (void)updateUserRoles {
    
    
    NSMutableArray *rolesArray = [[NSMutableArray alloc] init];
    
    for (Role *userRole in user.roles) {
        
        NSDictionary *tmpRoleDict = [userRole dictionaryWithValuesForKeys:[user updateRolesKeys]];

        [rolesArray addObject:tmpRoleDict];
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:rolesArray forKey:@"role"];
    
    // create NSData from dictionary
    NSError* error;
    NSData *requestData = [[NSData alloc] init];
    requestData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    
    // get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    urlString = [urlString stringByAppendingString:@"resources/roles?userId="];
    urlString = [urlString stringByAppendingString:[user.userId stringValue]];
    
    // convert to NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {
                                                        
                                                    }
                                                    failureBlock:^(NSError *error) {
                                                        
                                                    }];
    
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString* requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [requestData length]];
    
    //[urlRequest setHTTPMethod:@"POST"]; // create
    [urlRequest setHTTPMethod:@"PUT"]; // update
    [urlRequest setHTTPBody:requestData];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:requestDataLengthString forHTTPHeaderField:@"Content-Length"];
    [urlRequest setTimeoutInterval:30.0];
    
    [connectionController startRequestForURL:url setRequest:urlRequest];

}

@end
