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

// Fetches roles for the given resource URL into an NSMutableArray and executes the successBlock upon success.
+ (void)serverBugcategoriesToArray:(NSString *)urlString successBlock:(void (^)(NSMutableArray*))successBlock failureBlock:(void(^)(NSError *))failureBlock {
    
    // convert to NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableArray *bugcategories= [[NSMutableArray alloc] init];
    
    // NSURLConnection - MWConnectionController
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {
                                                        NSError *error;
                                                        
                                                        NSDictionary *dict = [[NSDictionary alloc] init];
                                                        dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                                                        
                                                        //NSLog(@"ugdict: %@", dict);
                                                        
                                                        [bugcategories addObjectsFromArray:[PTBugCategoryHelper setAttributesFromJSONDictionary:dict]];
                                                        //NSLog(@"ugcount: %lu", [usergroups count]);
                                                        successBlock(bugcategories);
                                                    }
                                                    failureBlock:^(NSError *error) {
                                                        //[self rolesForUserRequestFailed:error];
                                                    }];
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [connectionController startRequestForURL:url setRequest:urlRequest];
}

+ (void)bugcategories:(void(^)(NSMutableArray *))successBlock failureBlock:(void(^)(NSError *))failureBlock {
    
    // get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    urlString = [urlString stringByAppendingString:@"resources/bugcategories/all"];
    
    [self serverBugcategoriesToArray:urlString successBlock:successBlock failureBlock:failureBlock];
}

@end
