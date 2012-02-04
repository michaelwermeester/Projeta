//
//  UserGroup.m
//  Projeta
//
//  Created by Michael Wermeester on 31/10/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "BugCategory.h"

@implementation BugCategory

@synthesize categoryName = bugCategoryName;
@synthesize description = description;
@synthesize bugCategoryId = bugCategoryId;

// Required by NSCopying protocol.
- (id) copyWithZone:(NSZone *)zone {
    
    BugCategory *copy = [[BugCategory alloc] init];
    
    copy.categoryName = [categoryName copyWithZone:zone];
    copy.bugCategoryId = [bugCategoryId copyWithZone:zone];
    copy.description = [description copyWithZone:zone];
    
    return copy;
}

// Override isEqual method.
- (BOOL)isEqual:(id)anObject {
    
    if (self == anObject) {
        return YES;
    } else if (!anObject || ![anObject isKindOfClass:[self class]]) {
        return NO;
    } // compare if id and code are equal.
    else if ([[self categoryName] isEqual:[(BugCategory *)anObject categoryName]] && [[self bugCategoryId] isEqual:[(BugCategory *)anObject bugCategoryId]]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BugCategory *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    BugCategory *instance = [[BugCategory alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.categoryName = [aDictionary objectForKey:@"categoryName"];
    self.description = [aDictionary objectForKey:@"description"];
    self.bugCategoryId = [NSDecimalNumber decimalNumberWithString:(NSString *)[aDictionary objectForKey:@"bugCategoryId"]];
}

// keys needed for updating usergroup.
- (NSArray *)allKeys {
    
    NSArray *retArr = [[NSArray alloc] initWithObjects: @"bugCategoryId", @"categoryName", @"description", nil];
    
    return retArr;
}

@end
