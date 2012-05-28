//
//  Role.m
//  Projeta
//
//  Created by Michael Wermeester on 20/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "Role.h"

@implementation Role

@synthesize code = code;
@synthesize roleId = roleId;

// Requis pour le protocole NSCopying.
- (id) copyWithZone:(NSZone *)zone {
    
    Role *copy = [[Role alloc] init];
    
    copy.code = [code copyWithZone:zone];
    copy.roleId = [roleId copyWithZone:zone];
    
    return copy;
}

// Override isEqual method.
// Compare deux objets et retourne 'YES' s'ils sont égaux.
- (BOOL)isEqual:(id)anObject {
    
    if (self == anObject) {
        return YES;
    } else if (!anObject || ![anObject isKindOfClass:[self class]]) {
        return NO;
    } // comparer si ID et 'code' sont les mêmes.
    else if ([[self code] isEqual:[(Role *)anObject code]] && [[self roleId] isEqual:[(Role *)anObject roleId]]) {
        return YES;
    } else {
        return NO;
    }
}

+ (Role *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    Role *instance = [[Role alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.code = [aDictionary objectForKey:@"code"];
    self.roleId = [NSDecimalNumber decimalNumberWithString:(NSString *)[aDictionary objectForKey:@"roleId"]];
    
}

@end
