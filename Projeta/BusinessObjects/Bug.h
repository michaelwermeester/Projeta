//
//  Bug.h
//  Projeta
//
//  Created by Michael Wermeester on 4/21/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BugCategory;
@class Project;
@class User;

@interface Bug : NSObject <NSCopying> {
    BugCategory *bugCategory;
    NSNumber *bugId;
    BOOL canceled;
    BOOL deleted;
    NSDate *dateReported;
    NSString *details;
    BOOL fixed;
    NSNumber *priority;
    Project *project;
    NSString *title;
    User *userAssigned;
    User *userReported;
}

@property (nonatomic, retain) BugCategory *bugCategory;
@property (nonatomic, copy) NSNumber *bugId;
@property (nonatomic, assign) BOOL canceled;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, copy) NSDate *dateReported;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, assign) BOOL fixed;
@property (nonatomic, copy) NSNumber *priority;
@property (nonatomic, retain) Project *project;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) User *userAssigned;
@property (nonatomic, retain) User *userReported;


// Required by NSCopying protocol.
- (id) copyWithZone:(NSZone *)zone;

+ (Bug *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSArray *)bugIdKey;

- (NSArray *)createBugKeys;
- (NSArray *)updateBugKeys;

@end
