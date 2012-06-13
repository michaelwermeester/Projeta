//
//  PTUserGroupHelper.m
//  Projeta
//
//  Created by Michael Wermeester on 31/10/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "MWConnectionController.h"
#import "PTCommon.h"
#import "PTBugCategoryHelper.h"
#import "BugCategory.h"

@implementation PTBugCategoryHelper

@synthesize bugCategory = bugCategory;

+ (PTBugCategoryHelper *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    PTBugCategoryHelper *instance = [[PTBugCategoryHelper alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    
    NSArray *receivedBugCategories = [aDictionary objectForKey:@"bugcategory"];
    if ([receivedBugCategories isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *parsedBugCategory = [NSMutableArray arrayWithCapacity:[receivedBugCategories count]];
        for (NSDictionary *item in receivedBugCategories) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedBugCategory addObject:[BugCategory instanceFromDictionary:item]];
            }
        }
        
        self.bugCategory = parsedBugCategory;
        
    }
    
    
}

+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary {
    
    if (!aDictionary) {
        return nil;
    }
    
    
    NSArray *receivedBugCategories = [aDictionary objectForKey:@"bugcategory"];
    if (receivedBugCategories) {
        
        NSMutableArray *parsedUsergroups = [NSMutableArray arrayWithCapacity:[receivedBugCategories count]];
        for (id item in receivedBugCategories) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedUsergroups addObject:[BugCategory instanceFromDictionary:item]];
            }
        }
        
        return parsedUsergroups;
    }
    
    return nil;
}

@end
