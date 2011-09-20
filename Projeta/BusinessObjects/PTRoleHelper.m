//
//  PTRoleHelper.m
//  Projeta
//
//  Created by Michael Wermeester on 20/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "PTRoleHelper.h"

#import "Role.h"

@implementation PTRoleHelper

@synthesize role = role;

+ (PTRoleHelper *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    PTRoleHelper *instance = [[PTRoleHelper alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    
    NSArray *receivedRole = [aDictionary objectForKey:@"role"];
    if ([receivedRole isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *parsedRole = [NSMutableArray arrayWithCapacity:[receivedRole count]];
        for (NSDictionary *item in receivedRole) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedRole addObject:[Role instanceFromDictionary:item]];
            }
        }
        
        self.role = parsedRole;
        
    }
}

+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary {
    
    if (!aDictionary) {
        return nil;
    }
    
    
    NSArray *receivedRoles = [aDictionary objectForKey:@"role"];
    if (receivedRoles) {
        
        NSMutableArray *parsedRoles = [NSMutableArray arrayWithCapacity:[receivedRoles count]];
        for (id item in receivedRoles) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedRoles addObject:[Role instanceFromDictionary:item]];
            }
        }
        
        //self.users = parsedUsers;
        return parsedRoles;
    }
    
    return nil;
}


@end
