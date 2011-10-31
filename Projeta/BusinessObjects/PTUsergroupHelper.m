//
//  PTUserGroupHelper.m
//  Projeta
//
//  Created by Michael Wermeester on 31/10/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "PTUsergroupHelper.h"
#import "Usergroup.h"

@implementation PTUsergroupHelper

@synthesize usergroup = usergroup;

+ (PTUsergroupHelper *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    PTUsergroupHelper *instance = [[PTUsergroupHelper alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    
    NSArray *receivedUsergroup = [aDictionary objectForKey:@"usergroup"];
    if ([receivedUsergroup isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *parsedUsergroup = [NSMutableArray arrayWithCapacity:[receivedUsergroup count]];
        for (NSDictionary *item in receivedUsergroup) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedUsergroup addObject:[Usergroup instanceFromDictionary:item]];
            }
        }
        
        self.usergroup = parsedUsergroup;
        
    }
    
    
}

+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary {
    
    if (!aDictionary) {
        return nil;
    }
    
    
    NSArray *receivedUsergroups = [aDictionary objectForKey:@"usergroup"];
    if (receivedUsergroups) {
        
        NSMutableArray *parsedUsergroups = [NSMutableArray arrayWithCapacity:[receivedUsergroups count]];
        for (id item in receivedUsergroups) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedUsergroups addObject:[Usergroup instanceFromDictionary:item]];
            }
        }
        
        return parsedUsergroups;
    }
    
    return nil;
}


@end
