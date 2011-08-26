//
//  Project.h
//  Projeta
//
//  Created by Michael Wermeester on 25/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface Project : NSObject {
    NSDate *dateCreated;
    NSDate *endDate;
    BOOL flagPublic;
    NSDate *projectDescription;
    NSNumber *projectId;
    NSString *projectTitle;
    NSDate *startDate;
    User *userCreated;
}

@property (nonatomic, copy) NSDate *dateCreated;
@property (nonatomic, copy) NSDate *endDate;
@property (nonatomic, assign) BOOL flagPublic;
@property (nonatomic, copy) NSDate *projectDescription;
@property (nonatomic, copy) NSNumber *projectId;
@property (nonatomic, copy) NSString *projectTitle;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, retain) User *userCreated;

+ (Project *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end