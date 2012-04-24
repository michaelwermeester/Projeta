//
//  PTBugHelper.m
//  Projeta
//
//  Created by Michael Wermeester on 4/21/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "Bug.h"
#import "PTBugHelper.h"

@implementation PTBugHelper

@synthesize bug = bug;

+ (PTBugHelper *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    PTBugHelper *instance = [[PTBugHelper alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    
    NSArray *receivedBug = [aDictionary objectForKey:@"bug"];
    if ([receivedBug isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *parsedBug = [NSMutableArray arrayWithCapacity:[receivedBug count]];
        for (NSDictionary *item in receivedBug) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedBug addObject:[Bug instanceFromDictionary:item]];
            }
        }
        
        self.bug = parsedBug;
    }
}

+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary {
    
    if (!aDictionary) {
        return nil;
    }
    
    // if dictionary contains array of dictionaries
    if ([[aDictionary objectForKey:@"bug"] isKindOfClass:[NSArray class]]) {
        
        NSArray *receivedBugs = [aDictionary objectForKey:@"bug"];
        if (receivedBugs) {
            
            NSMutableArray *parsedBugs = [NSMutableArray arrayWithCapacity:[receivedBugs count]];
            
            for (id item in receivedBugs) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedBugs addObject:[Bug instanceFromDictionary:item]];
                }
            }
            
            return parsedBugs;
        }
    }
    // if dictionary contains just a dictionary
    else if ([[aDictionary objectForKey:@"bug"] isKindOfClass:[NSDictionary class]]) {
        
        NSMutableArray *parsedBugs = [NSMutableArray arrayWithCapacity:1];
        
        [parsedBugs addObject:[Bug instanceFromDictionary:[aDictionary objectForKey:@"bug"]]];
        
        return parsedBugs;
    }
    
    return nil;
}


@end
