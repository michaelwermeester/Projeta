//
//  PTTaskHelper.m
//  Projeta
//
//  Created by Michael Wermeester on 11/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "PTTaskHelper.h"
#import "Task.h"

@implementation PTTaskHelper

@synthesize task = task;

+ (PTTaskHelper *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    PTTaskHelper *instance = [[PTTaskHelper alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    
    NSArray *receivedTask = [aDictionary objectForKey:@"task"];
    if ([receivedTask isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *parsedTask = [NSMutableArray arrayWithCapacity:[receivedTask count]];
        for (NSDictionary *item in receivedTask) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedTask addObject:[Task instanceFromDictionary:item]];
            }
        }
        
        self.task = parsedTask;
        
    }
}

+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary {
    
    if (!aDictionary) {
        return nil;
    }
    
    // if dictionary contains array of dictionaries
    if ([[aDictionary objectForKey:@"task"] isKindOfClass:[NSArray class]]) {
        
        NSArray *receivedProjects = [aDictionary objectForKey:@"task"];
        if (receivedProjects) {
            
            NSMutableArray *parsedProjects = [NSMutableArray arrayWithCapacity:[receivedProjects count]];
            
            for (id item in receivedProjects) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedProjects addObject:[Task instanceFromDictionary:item]];
                }
            }
            
            return parsedProjects;
        }
    }
    // if dictionary contains just a dictionary
    else if ([[aDictionary objectForKey:@"task"] isKindOfClass:[NSDictionary class]]) {
        
        NSMutableArray *parsedProjects = [NSMutableArray arrayWithCapacity:1];
        
        [parsedProjects addObject:[Task instanceFromDictionary:[aDictionary objectForKey:@"task"]]];
        
        return parsedProjects;
    }
    
    return nil;
}

@end
