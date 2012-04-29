//
//  UserGroup.h
//  Projeta
//
//  Created by Michael Wermeester on 31/10/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BugCategory : NSObject <NSCopying> {
    NSString *categoryName;
    NSString *description;
    NSNumber *bugcategoryId;
}

@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSNumber *bugcategoryId;

+ (BugCategory *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSArray *)allKeys;

+ (BugCategory *)initWithId:(NSNumber *)anId name:(NSString *)aName;

// Required by NSCopying protocol.
- (id) copyWithZone:(NSZone *)zone;

@end
