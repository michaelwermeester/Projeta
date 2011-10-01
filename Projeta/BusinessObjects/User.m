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

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
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

+ (User *)instanceFromDictionary:(NSDictionary *)aDictionary {

    User *instance = [[User alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

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

@end
