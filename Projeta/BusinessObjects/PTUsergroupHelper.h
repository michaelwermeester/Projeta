//
//  PTUserGroupHelper.h
//  Projeta
//
//  Created by Michael Wermeester on 31/10/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Project;
@class User;
@class Usergroup;

@interface PTUsergroupHelper : NSObject {
    NSArray *usergroup;
}

@property (nonatomic, copy) NSArray *usergroup;

+ (PTUsergroupHelper *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary;

+ (void)serverUsergroupsToArray:(NSString *)urlString successBlock:(void (^)(NSMutableArray*))successBlock;
+ (void)usergroupsAvailable:(void(^)(NSMutableArray *))successBlock;
+ (void)usergroupsForUser:(User *)aUser successBlock:(void(^)(NSMutableArray *))successBlock;
+ (void)usergroupsForUserName:(NSString *)aUsername successBlock:(void(^)(NSMutableArray *))successBlock;

+ (BOOL)updateUsergroupsForUser:(User *)aUser usergroups:(NSMutableDictionary *)usergroups successBlock:(void(^)(NSMutableData *))successBlock failureBlock:(void(^)(NSError *))failureBlock;
+ (BOOL)updateUsersForUsergroup:(Usergroup *)aUsergroup users:(NSMutableDictionary *)users successBlock:(void(^)(NSMutableData *))successBlock failureBlock:(void(^)(NSError *))failureBlock;

+ (void)usergroupsVisibleForProject:(Project *)aProject successBlock:(void(^)(NSMutableArray *))successBlock failureBlock:(void(^)(NSError *))failureBlock;
+ (void)usergroupsVisibleForProjectId:(NSNumber *)aProjectId successBlock:(void(^)(NSMutableArray *))successBlock failureBlock:(void(^)(NSError *))failureBlock;

@end
