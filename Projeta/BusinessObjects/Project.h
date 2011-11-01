//
//  Project.h
//  Projeta
//
//  Created by Michael Wermeester on 25/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"
//@class User;

@interface Project : NSObject {
    NSDate *dateCreated;
    NSDate *endDate;
    BOOL flagPublic;
    BOOL completed;
    BOOL canceled;
    NSDate *projectDescription;
    NSNumber *projectId;
    NSString *projectTitle;
    NSDate *startDate;
    User *userCreated;
    NSDate *startDateReal;
    NSDate *endDateReal;
    
    NSMutableArray *childProject;
}

@property (nonatomic, copy) NSDate *dateCreated;
@property (nonatomic, copy) NSDate *endDate;
@property (nonatomic, copy) NSDate *endDateReal;
@property (nonatomic, assign) BOOL flagPublic;
@property (nonatomic, assign) BOOL completed;
@property (nonatomic, assign) BOOL canceled;
@property (nonatomic, copy) NSDate *projectDescription;
@property (nonatomic, copy) NSNumber *projectId;
@property (nonatomic, copy) NSString *projectTitle;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *startDateReal;
@property (nonatomic, retain) User *userCreated;
@property (strong) NSMutableArray *childProject;

+ (Project *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end