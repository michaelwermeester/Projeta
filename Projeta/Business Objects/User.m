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

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
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

- (NSArray*)allKeys
{
    NSArray *retArr = [[NSArray alloc] initWithObjects: @"username", @"password", @"userId", nil];
    
    return retArr;
}

@end
