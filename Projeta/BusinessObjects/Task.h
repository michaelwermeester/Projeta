//
//  Task.h
//  Projeta
//
//  Created by Michael Wermeester on 11/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"

@interface Task : NSObject <NSCopying> {
    NSDate *endDate;
    NSDate *startDate;
    NSString *taskDescription;
    NSNumber *taskId;
    NSString *taskTitle;
    User *userAssigned;
    User *userCreated;
    BOOL completed;
    BOOL isPersonal;
    NSMutableArray *childTask;
    NSNumber *parentTaskId;
    
    NSNumber *priority;
    
    NSString *taskStatus;
    NSNumber *taskPercentage;
    
    NSString *projectTitle;
    
    NSNumber *projectId;
    
    NSDate *startDateReal;
    NSDate *endDateReal;
}

@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, copy) NSString *taskDescription;
@property (nonatomic, copy) NSNumber *taskId;
@property (nonatomic, copy) NSString *taskTitle;
@property (nonatomic, retain) User *userAssigned;
@property (nonatomic, retain) User *userCreated;
@property (nonatomic, assign) BOOL completed;
@property (nonatomic, assign) BOOL isPersonal;
@property (strong) NSMutableArray *childTask;
@property (nonatomic, copy) NSNumber *parentTaskId;
@property (nonatomic, copy) NSNumber *priority;

@property (nonatomic, copy) NSString *projectTitle;

@property (nonatomic, copy) NSNumber *projectId;

// état et pourcentage de la tâche.
@property (nonatomic, copy) NSString *taskStatus;
@property (nonatomic, copy) NSNumber *taskPercentage;

// Required by NSCopying protocol.
- (id) copyWithZone:(NSZone *)zone;

+ (Task *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSArray *)createTaskKeys;
- (NSArray *)taskIdKey;
- (NSArray *)updateTaskKeys;

@property (readonly, nonatomic, copy) NSString *stringEndDate;
@property (readonly, nonatomic, copy) NSString *stringStartDate;
@property (readonly, nonatomic, copy) NSString *stringEndDateReal;
@property (readonly, nonatomic, copy) NSString *stringStartDateReal;

@end
