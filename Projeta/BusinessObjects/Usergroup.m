//
//  UserGroup.m
//  Projeta
//
//  Created by Michael Wermeester on 31/10/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "Usergroup.h"

@implementation Usergroup

@synthesize code = code;
@synthesize comment = comment;
@synthesize usergroupId = usergroupId;

// Required by NSCopying protocol.
- (id) copyWithZone:(NSZone *)zone {
    
    Usergroup *copy = [[Usergroup alloc] init];
    
    copy.code = [code copyWithZone:zone];
    copy.usergroupId = [usergroupId copyWithZone:zone];
    copy.comment = [comment copyWithZone:zone];
    
    return copy;
}

// Override isEqual method.
- (BOOL)isEqual:(id)anObject {
    
    if (self == anObject) {
        return YES;
    } else if (!anObject || ![anObject isKindOfClass:[self class]]) {
        return NO;
    } // compare if id and code are equal.
    else if ([[self code] isEqual:[(Usergroup *)anObject code]] && [[self usergroupId] isEqual:[(Usergroup *)anObject usergroupId]]) {
        return YES;
    } else {
        return NO;
    }
}

+ (Usergroup *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    Usergroup *instance = [[Usergroup alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.code = [aDictionary objectForKey:@"code"];
    self.comment = [aDictionary objectForKey:@"comment"];
    self.usergroupId = [NSDecimalNumber decimalNumberWithString:(NSString *)[aDictionary objectForKey:@"usergroupId"]];
}

// keys needed for updating usergroup.
- (NSArray *)allKeys {
    
    NSArray *retArr = [[NSArray alloc] initWithObjects: @"usergroupId", @"code", @"comment", nil];
    
    return retArr;
}

@end
