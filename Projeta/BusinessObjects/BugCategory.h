//
//  UserGroup.h
//  Projeta
//
//  Created by Michael Wermeester on 31/10/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BugCategory : NSObject {
    NSString *bugCategoryName;
    NSString *description;
    NSNumber *bugCategoryId;
}

@property (nonatomic, copy) NSString *bugCategoryName;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSNumber *bugCategoryId;

+ (BugCategory *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSArray *)allKeys;

@end
