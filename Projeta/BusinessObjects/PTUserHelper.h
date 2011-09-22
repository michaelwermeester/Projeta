//
//  PTUser.h
//  
//
//  Created by Michael Wermeester on 16/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "User.h"

@interface PTUserHelper : NSObject {
    NSArray *users;
}

@property (nonatomic, copy) NSArray *users;

+ (PTUserHelper *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
+ (NSMutableArray *)setAttributesFromDictionary2:(NSDictionary *)aDictionary;

// returns the current logged-in user.
+ (User *)loggedInUser;
+ (NSMutableArray *)currentUserRoles;

+ (void)setCurrentUserRoles:(NSMutableArray *)newRoles;

- (void)loadUserInfo;
- (void)loadUserRoles;
- (void)userRoleInitializationsRequestFinished:(NSMutableData*)data;
- (void)userRoleInitializationsRequestFailed:(NSError*)error;

@end
