//
//  PTUser.h
//  
//
//  Created by Michael Wermeester on 16/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "User.h"
#import "Usergroup.h"

@class Project;

@interface PTUserHelper : NSObject {
    NSArray *users;
}

@property (nonatomic, copy) NSArray *users;

+ (PTUserHelper *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
//+ (NSMutableArray *)setAttributesFromDictionary2:(NSDictionary *)aDictionary;
+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary;

#pragma mark Web service methods
/*********************************************************************************************
* mainWindowController parameter is used for animating the main window's progress indicator. *
*********************************************************************************************/

// creates a new user in database.
+ (BOOL)createUser:(User *)theUser successBlock:(void(^)(NSMutableData *))successBlock_ mainWindowController:(id)sender;
// updates username, first name and last name of a given user. 
+ (BOOL)updateUser:(User *)theUser mainWindowController:(id)sender;

+ (void)userExists:(NSString *)aUsername successBlock:(void(^)(BOOL))successBlock failureBlock:(void(^)())failureBlock;

+ (void)updateUserPassword:(NSNumber *)theUserId password:(NSString *)thePassword successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)(NSError *))failureBlock_;


+ (void)usersForUsergroup:(Usergroup *)aGroup successBlock:(void(^)(NSMutableArray *))successBlock failureBlock:(void(^)(NSError *))failureBlock;
+ (void)usersForUsergroupId:(NSNumber *)aGroupId successBlock:(void(^)(NSMutableArray *))successBlock failureBlock:(void(^)(NSError *))failureBlock;

+ (void)usersVisibleForProject:(Project *)aProject successBlock:(void(^)(NSMutableArray *))successBlock failureBlock:(void(^)(NSError *))failureBlock;
+ (void)usersVisibleForProjectId:(NSNumber *)aProjectId successBlock:(void(^)(NSMutableArray *))successBlock failureBlock:(void(^)(NSError *))failureBlock;

// Fetches users for the given resource URL into an NSMutableArray and executes the successBlock upon success.
+ (void)serverUsersToArray:(NSString *)urlString successBlock:(void (^)(NSMutableArray*))successBlock failureBlock:(void(^)(NSError *))failureBlock;

+ (void)allUsers:(void(^)(NSMutableArray *))successBlock failureBlock:(void(^)(NSError *))failureBlock;
+ (void)developers:(void(^)(NSMutableArray *))successBlock failureBlock:(void(^)(NSError *))failureBlock;

@end
