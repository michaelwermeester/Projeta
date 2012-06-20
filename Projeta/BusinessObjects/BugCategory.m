//
//  UserGroup.m
//  Projeta
//
//  Created by Michael Wermeester on 31/10/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "BugCategory.h"

@implementation BugCategory

@synthesize categoryName = categoryName;
@synthesize description = description;
@synthesize bugcategoryId = bugcategoryId;

// Required by NSCopying protocol.
- (id) copyWithZone:(NSZone *)zone {
    
    BugCategory *copy = [[BugCategory alloc] init];
    
    copy.categoryName = [categoryName copyWithZone:zone];
    copy.bugcategoryId = [bugcategoryId copyWithZone:zone];
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
    else if ([[self categoryName] isEqual:[(BugCategory *)anObject categoryName]] && [[self bugcategoryId] isEqual:[(BugCategory *)anObject bugcategoryId]]) {
        return YES;
    } else {
        return NO;
    }
}

// Permet de créer un objet BugCategory à partir d'un dictionnaire. 
+ (BugCategory *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    BugCategory *instance = [[BugCategory alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

// initialise les propriétés à partir du dictionnaire. 
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.categoryName = [aDictionary objectForKey:@"categoryName"];
    self.description = [aDictionary objectForKey:@"description"];
    self.bugcategoryId = [NSDecimalNumber decimalNumberWithString:(NSString *)[aDictionary objectForKey:@"bugcategoryId"]];
}

// keys needed for updating usergroup.
- (NSArray *)allKeys {
    
    NSArray *retArr = [[NSArray alloc] initWithObjects: @"bugcategoryId", @"categoryName", @"description", nil];
    
    return retArr;
}

- (NSString *)description {
    return categoryName;
}

+ (BugCategory *)initWithId:(NSNumber *)anId name:(NSString *)aName {
    
    BugCategory *bugCategory = [[BugCategory alloc] init];
    
    if (bugCategory) {
        
        bugCategory.bugcategoryId = anId;
        bugCategory.categoryName = aName;
    }
    
    return bugCategory;
}

- (NSArray *)bugcategoryIdKey {
    NSArray *retArr = [[NSArray alloc] initWithObjects:@"bugcategoryId", nil];
    
    return retArr;
}

@end
