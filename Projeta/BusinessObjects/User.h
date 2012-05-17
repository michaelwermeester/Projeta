//
//  User.h
//  
//
//  Created by Michael Wermeester on 16/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface User : NSObject <NSCopying> {
    NSString *password;
    NSNumber *userId;
    NSString *username;
    
    NSString *emailAddress;
    NSString *firstName;
    NSString *lastName;
    
    NSMutableArray *roles;
    NSMutableArray *usergroups;
    
    // retourne le nom complet de l'utilisateur (prénom + nom).
    //NSString *fullName;
    //NSString *fullNameAndUsername;
}

@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *emailAddress;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (strong) NSMutableArray *roles;
@property (strong) NSMutableArray *usergroups;

@property (strong, readonly) NSString *fullName;
@property (strong, readonly) NSString *fullNameAndUsername;

+ (User *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

//
- (NSArray *)allKeys;
// keys needed for updating username, first name, last name and email address.
- (NSArray *)namesEmailKeys;
// keys needed for updating username, password, first name, last name, email address.
- (NSArray *)namesEmailKeysWithPassword;

- (NSArray *)userIdKey;
// keys needed for updating a user's password.
- (NSArray *)userIdPasswordKeys;
// keys needed for updating user roles.
- (NSArray *)updateRolesKeys;
// keys needed for updating user's usergroups.
- (NSArray *)updateUsergroupsKeys;

// Required by NSCopying protocol.
- (id) copyWithZone:(NSZone *)zone;

@end
