//
//  Project.h
//  Projeta
//
//  Created by Michael Wermeester on 25/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OutlineCollection.h"

#import "User.h"

@interface Project : OutlineCollection <NSCopying> {
    NSDate *dateCreated;
    NSDate *endDate;
    BOOL flagPublic;
    BOOL completed;
    BOOL canceled;
    NSString *projectDescription;
    NSNumber *projectId;
    NSNumber *parentProjectId;
    NSString *projectTitle;
    NSDate *startDate;
    User *userAssigned;
    User *userCreated;
    NSDate *startDateReal;
    NSDate *endDateReal;
    
    NSString *projectStatus;
    NSNumber *projectPercentage;
    
    NSMutableArray *childProject;
}

@property (nonatomic, copy) NSDate *dateCreated;
@property (nonatomic, copy) NSDate *endDate;
@property (nonatomic, copy) NSDate *endDateReal;
@property (nonatomic, assign) BOOL flagPublic;
@property (nonatomic, assign) BOOL completed;
@property (nonatomic, assign) BOOL canceled;
@property (nonatomic, copy) NSString *projectDescription;
@property (nonatomic, copy) NSNumber *projectId;
@property (nonatomic, copy) NSNumber *parentProjectId;
@property (nonatomic, copy) NSString *projectTitle;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *startDateReal;
@property (nonatomic, retain) User *userAssigned;
@property (nonatomic, retain) User *userCreated;
@property (strong) NSMutableArray *childProject;

// retourne le pourcentage d'avancement du projet.
@property (readonly) NSString *percentageCompleteString;

// état du projet
@property (nonatomic, copy) NSString *projectStatus;
@property (nonatomic, copy) NSNumber *projectPercentage;

@property (readonly, nonatomic, copy) NSString *projectPercentageStatus;

@property (readonly, nonatomic, copy) NSString *stringEndDate;
@property (readonly, nonatomic, copy) NSString *stringStartDate;
@property (readonly, nonatomic, copy) NSString *stringEndDateReal;
@property (readonly, nonatomic, copy) NSString *stringStartDateReal;


// pour calendar control.
@property (nonatomic, copy) NSDate *calendarStartDateReal;

+ (Project *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

// Required by NSCopying protocol.
- (id) copyWithZone:(NSZone *)zone;

- (NSArray *)createProjectKeys;
- (NSArray *)projectIdKey;
- (NSArray *)updateProjectKeys;

- (BOOL)isLeaf;

@end