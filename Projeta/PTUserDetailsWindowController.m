//
//  PTUserDetailsWindowController.m
//  Projeta
//
//  Created by Michael Wermeester on 24/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "PTUserDetailsWindowController.h"
#import "PTUserManagementViewController.h"

#import "MainWindowController.h"
#import "MWConnectionController.h"
#import "PTCommon.h"
#import "PTRoleHelper.h"
#import "PTSetPasswordWindowController.h"
#import "PTUserHelper.h"
#import "Role.h"
#import "User.h"

User *userCopy;

@implementation PTUserDetailsWindowController
@synthesize userRolesArrayCtrl;
@synthesize availableRolesArrayCtrl;

@synthesize user;
// Holds the available roles which can be affected.
@synthesize availableRoles;
@synthesize userRolesTableView;

@synthesize parentUserManagementViewCtrl;
@synthesize mainWindowController;
@synthesize userNameProgressIndicator;
@synthesize userNameInvalidImageView;
@synthesize passwordInvalidImageView;
@synthesize setPasswordButton;
@synthesize passwordTextField;

@synthesize isNewUser;
@synthesize usernameTextField;

@synthesize setPwdWindowCtrl;
@synthesize okButton;

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
    
    userCopy = [[User alloc] init];
    userCopy = [user copy];
    
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
        
        if (!user.roles) {
            user.roles = [[NSMutableArray alloc] init];
        }
        
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
    
    BOOL usrUpdSuc = NO;
    BOOL __block roleUpdSuc = NO;
    
    if ([userNameInvalidImageView isHidden] == YES) { 
        
        // move focus to OK button to make sure that no text field is in edit mode (which prevents saving).
        [[self window] makeFirstResponder:okButton];
        
        if (isNewUser == NO) {
            // update user details.
            if ([PTUserHelper updateUser:user mainWindowController:parentUserManagementViewCtrl] == YES) {
                // ok.
                usrUpdSuc = YES;
                
                // update user roles.
                roleUpdSuc = [self updateUserRoles];
                
                // if updating user and its roles was successful, close this window.
                if (usrUpdSuc == YES && roleUpdSuc == YES) {
                    // close this window.
                    [self close];
                }
            } else {
                // handle error.
            }
        } else {
            
            usrUpdSuc = [PTUserHelper createUser:user successBlock:^(NSMutableData *data) {
                [self finishedCreatingUser:data];
            } 
                            mainWindowController:parentUserManagementViewCtrl];
            
        }
        
    }
    
    // update user roles.
    //roleUpdSuc = [self updateUserRoles];
    
}

- (IBAction)cancelButtonClicked:(id)sender {

    if (isNewUser == NO) {
        // cancel changes -> replace current user with previously made copy of user.
        [[parentUserManagementViewCtrl mutableArrayValueForKey:@"arrUsr"] replaceObjectAtIndex:[parentUserManagementViewCtrl.arrUsr indexOfObject:user] withObject:userCopy];
    } else {
        // remove the temporary inserted/created user.
        [[parentUserManagementViewCtrl mutableArrayValueForKey:@"arrUsr"] removeObject:user];
    }
    
    // close this window.
    [self close];
}

- (IBAction)setPasswordButtonClicked:(id)sender {
    
    //
    setPwdWindowCtrl = [[PTSetPasswordWindowController alloc] init];

    [setPwdWindowCtrl setUserId:user.userId];
    
    /*NSModalSession session = [NSApp beginModalSessionForWindow:[setPwdWindowCtrl window]];
    
    for (;;) {
        if ([NSApp runModalSession:session] != NSRunContinuesResponse)
            break;
        //[self doSomeWork];
    }
    
    [NSApp endModalSession:session];*/
    
    [NSApp beginSheet:[setPwdWindowCtrl window]
       modalForWindow:[self window]
        modalDelegate:nil
       didEndSelector:NULL
          contextInfo:NULL];
    
    
}

- (void)finishedCreatingUser:(NSMutableData*)data {
    NSError *error;
    
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSMutableArray *createdUserArray = [[NSMutableArray alloc] init];
    
    // see Cocoa and Objective-C up and running by Scott Stevenson.
    // page 242
    //[createdUserArray addObjectsFromArray:[PTUserHelper setAttributesFromDictionary2:dict]];
    [createdUserArray addObjectsFromArray:[PTUserHelper setAttributesFromJSONDictionary:dict]];
    
    if ([createdUserArray count] == 1) {
        for (User *usr in createdUserArray) {

            [[parentUserManagementViewCtrl mutableArrayValueForKey:@"arrUsr"] replaceObjectAtIndex:[parentUserManagementViewCtrl.arrUsr indexOfObject:user] withObject:usr];
            
            // create temporary copy of user roles. 
            NSMutableArray* tmpUserRoles = [[NSMutableArray alloc] initWithArray:user.roles];
            // reassign user with user returned from web-service. 
            self.user = usr;
            // reaffect user roles.
            self.user.roles = tmpUserRoles;
            
            // update user roles.
            if ([self updateUserRoles] == YES) {
                // close this window.
                [self close];
            }
        }
    }
}

// update user roles (in database).
- (BOOL)updateUserRoles {
    
    BOOL success;
    
    // Initialize a new array to hold the roles.
    NSMutableArray *rolesArray = [[NSMutableArray alloc] init];
    
    // add (assigned) user roles to the array.
    for (Role *userRole in user.roles) {
        
        NSDictionary *tmpRoleDict = [userRole dictionaryWithValuesForKeys:[user updateRolesKeys]];

        [rolesArray addObject:tmpRoleDict];
    }
    
    // create a new dictionary which holds the user roles.
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:rolesArray forKey:@"role"];
    
    //
    // update user roles in database via web service.
    success = [PTRoleHelper updateRolesForUser:user roles:dict];
    
    return success;
    
    
    // -> moved to 'PTRoleHelper - updateUserRoles' method
    /*// create NSData from dictionary
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
     */

}

- (void)controlTextDidChange:(NSNotification *)aNotification
{
    // username NSTextField
    if([aNotification object] == usernameTextField)
    {
        [self checkUsernameExists];
    }
}

- (void)sucUserExists:(BOOL)userExists {
    
    // stop animation.
    [userNameProgressIndicator stopAnimation:self];
    
    // stop animating the main window's circular progress indicator.
    [mainWindowController stopProgressIndicatorAnimation];
    
    if (userExists == YES) {
        // make invalid image visible if username exists.
        [userNameInvalidImageView setHidden:NO];
    } else {
        [userNameInvalidImageView setHidden:YES];
    }
}

- (void)failUserExists {
    
    // stop animation.
    [userNameProgressIndicator stopAnimation:self];
    
    // stop animating the main window's circular progress indicator.
    [mainWindowController stopProgressIndicatorAnimation];
    
    // make invalid image visible.
    [userNameInvalidImageView setHidden:NO];
}

- (void)checkUsernameExists
{
    // start progress indicator animation.
    [userNameProgressIndicator startAnimation:self];
    
    // start animating the main window's circular progress indicator.
    [mainWindowController startProgressIndicatorAnimation];
    
    // if username hasn't changed.
    if ([[usernameTextField stringValue] isEqual:[userCopy username]]) {
        [self sucUserExists:NO];
    }
    // don't allow usernames shorter than 2 characters.
    else if ([[usernameTextField stringValue] length] > 1) {
        
        [PTUserHelper userExists:[usernameTextField stringValue] successBlock:^(BOOL userExists){
            [self sucUserExists:userExists];
        } 
                    failureBlock:^(){
                        [self failUserExists];
                    }];
    } 
    // if username is too short.
    else {   
        [self sucUserExists:YES];
    }
}

@end
