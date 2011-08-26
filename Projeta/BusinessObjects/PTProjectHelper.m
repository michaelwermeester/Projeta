//
//  PTProjectHelper.m
//  Projeta
//
//  Created by Michael Wermeester on 26/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "PTProjectHelper.h"
#import "Project.h"

@implementation PTProjectHelper

@synthesize projects = projects;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (PTProjectHelper *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    PTProjectHelper *instance = [[PTProjectHelper alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (!aDictionary) {
        return;
    }
    
    
    NSArray *receivedProjects = [aDictionary objectForKey:@"project"];
    if (receivedProjects) {
        
        NSMutableArray *parsedProjects = [NSMutableArray arrayWithCapacity:[receivedProjects count]];
        for (id item in receivedProjects) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedProjects addObject:[Project instanceFromDictionary:item]];
            }
        }
        
        self.projects = parsedProjects;
        
    }
    
}

+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary {
    
    if (!aDictionary) {
        return nil;
    }
    
    // if dictionary contains array of dictionaries
    if ([[aDictionary objectForKey:@"project"] isKindOfClass:[NSArray class]]) {
        
        NSArray *receivedProjects = [aDictionary objectForKey:@"project"];
        if (receivedProjects) {
            
            NSMutableArray *parsedProjects = [NSMutableArray arrayWithCapacity:[receivedProjects count]];
            
            for (id item in receivedProjects) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedProjects addObject:[Project instanceFromDictionary:item]];
                }
            }
            
            return parsedProjects;
        }
    }
    // if dictionary contains just a dictionary
    else if ([[aDictionary objectForKey:@"project"] isKindOfClass:[NSDictionary class]]) {
        
        NSMutableArray *parsedProjects = [NSMutableArray arrayWithCapacity:1];
        
        [parsedProjects addObject:[Project instanceFromDictionary:[aDictionary objectForKey:@"project"]]];
        
        return parsedProjects;
    }
    
    return nil;
}

@end