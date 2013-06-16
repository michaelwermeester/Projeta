//
//  User.m
//  
//
//  Created by Michael Wermeester on 16/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize password = password;
@synthesize userId = userId;
@synthesize username = username;
@synthesize emailAddress = emailAddress;
@synthesize firstName = firstName;
@synthesize lastName = lastName;
@synthesize roles = roles;
@synthesize usergroups = usergroups;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

// Override isEqual method.
- (BOOL)isEqual:(id)anObject {
    
    if (self == anObject) {
        return YES;
    } else if (!anObject || ![anObject isKindOfClass:[self class]]) {
        return NO;
    } // compare if id and code are equal.
    else if ([[self userId] isEqual:[(User *)anObject userId]] && [[self username] isEqual:[(User *)anObject username]]) {
        return YES;
    } else {
        return NO;
    }
}

// Required by NSCopying protocol.
- (id) copyWithZone:(NSZone *)zone {
    
    User *copy = [[User alloc] init];
    
    copy.userId = [userId copyWithZone:zone];
    copy.password = [password copyWithZone:zone];
    copy.username = [username copyWithZone:zone];
    copy.emailAddress = [emailAddress copyWithZone:zone];
    copy.firstName = [firstName copyWithZone:zone];
    copy.lastName = [lastName copyWithZone:zone];
    
    return copy;
}

// Permet de créer un objet User à partir d'un dictionnaire. 
+ (User *)instanceFromDictionary:(NSDictionary *)aDictionary {

    User *instance = [[User alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

// initialise les propriétés à partir du dictionnaire. 
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (!aDictionary) {
        return;
    }

    self.password = [aDictionary objectForKey:@"password"];
    self.userId = [NSDecimalNumber decimalNumberWithString:(NSString *)[aDictionary objectForKey:@"userId"]];[aDictionary objectForKey:@"userId"];
    self.username = [aDictionary objectForKey:@"username"];
    
    self.emailAddress = [aDictionary objectForKey:@"emailAddress"];
    self.firstName = [aDictionary objectForKey:@"firstName"];
    self.lastName = [aDictionary objectForKey:@"lastName"];

}

// In your custom class
+ (id)customClassWithProperties:(NSDictionary *)properties {
    return [[self alloc] initWithProperties:properties];
}

- (id)initWithProperties:(NSDictionary *)properties {
    if (self = [self init]) {
        [self setValuesForKeysWithDictionary:properties];
    }
    return self;
}

- (NSArray *)allKeys
{
    NSArray *retArr = [[NSArray alloc] initWithObjects: @"username", @"password", @"userId", nil];
    
    return retArr;
}

// keys needed for updating username, first name, last name and email address.
- (NSArray *)namesEmailKeys {
    
    NSArray *retArr = [[NSArray alloc] initWithObjects: @"username", @"firstName", @"lastName", @"emailAddress", @"userId", nil];
    
    return retArr;
}

// keys needed for updating username, password, first name, last name, email address.
- (NSArray *)namesEmailKeysWithPassword {
    
    NSArray *retArr = [[NSArray alloc] initWithObjects: @"username", @"firstName", @"lastName", @"emailAddress", @"userId", @"password", nil];
    
    return retArr;
}

- (NSArray *)userIdKey {
    NSArray *retArr = [[NSArray alloc] initWithObjects:@"userId", nil];
    
    return retArr;
}

// keys needed for updating a user's password.
- (NSArray *)userIdPasswordKeys {
    
    NSArray *retArr = [[NSArray alloc] initWithObjects: @"userId", @"password", nil];
    
    return retArr;
}


// keys needed for updating user roles.
- (NSArray *)updateRolesKeys {
 
    NSArray *retArr = [[NSArray alloc] initWithObjects: @"code", @"roleId", nil];
    
    return retArr;
}

// keys needed for updating user's usergroups.
- (NSArray *)updateUsergroupsKeys {
    
    NSArray *retArr = [[NSArray alloc] initWithObjects: @"code", @"usergroupId", nil];
    
    return retArr;
}

- (NSString *)fullName
{
    NSString *fullname = @"";
    if (firstName != nil) {
        fullname = [fullname stringByAppendingString:firstName];
    }
    if (firstName != nil && [firstName length] > 0 && lastName != nil && [lastName length] > 0) {
        fullname = [fullname stringByAppendingString:@" "];
    }
    if (lastName != nil) {
        fullname = [fullname stringByAppendingString:lastName];
    }
    
    return fullname;
}

- (NSString*)fullNameAndUsername {
    
    NSString *description = @"";
    
    
    if ([self fullName] != nil) {
        description = [description stringByAppendingString:[self fullName]];
    }
    
    if ([self fullName] != nil && [[self fullName] length] > 0 && username != nil)
         description = [description stringByAppendingString:@" "];
    
    if (username != nil) {
        description = [description stringByAppendingString:@"("];
        description = [description stringByAppendingString:username];
        description = [description stringByAppendingString:@")"];
    }
    
    return description;
}

@end
