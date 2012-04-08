//
//  Task.m
//  Projeta
//
//  Created by Michael Wermeester on 11/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "PTCommon.h"
#import "Task.h"
#import "User.h"

@implementation Task

@synthesize endDate = endDate;
@synthesize startDate = startDate;
@synthesize taskDescription = taskDescription;
@synthesize taskId = taskId;
@synthesize taskTitle = taskTitle;
@synthesize userCreated = userCreated;
@synthesize completed = completed;
@synthesize childTask = childTask;
@synthesize parentTaskId = parentTaskId;
@synthesize priority = priority;
@synthesize isPersonal = isPersonal;

+ (Task *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    Task *instance = [[Task alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    
    return instance;
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    //self.endDate = [aDictionary objectForKey:@"endDate"];
    //self.startDate = [aDictionary objectForKey:@"startDate"];
    self.endDate = [PTCommon dateFromJSONString:[aDictionary objectForKey:@"endDate"]];
    self.startDate = [PTCommon dateFromJSONString:[aDictionary objectForKey:@"startDate"]];
    self.taskDescription = [aDictionary objectForKey:@"taskDescription"];
    self.taskId = [NSDecimalNumber decimalNumberWithString:(NSString *)[aDictionary objectForKey:@"taskId"]];
    self.taskTitle = [aDictionary objectForKey:@"taskTitle"];
    
    if ([[aDictionary objectForKey:@"completed"] isKindOfClass:[NSNull class]])
        self.completed = NO;
    else
        self.completed = [(NSString *)[aDictionary objectForKey:@"completed"] boolValue];
    
    if ([[aDictionary objectForKey:@"isPersonal"] isKindOfClass:[NSNull class]])
        self.completed = NO;
    else
        self.completed = [(NSString *)[aDictionary objectForKey:@"isPersonal"] boolValue];
    
    self.userCreated = [User instanceFromDictionary:[aDictionary objectForKey:@"userCreated"]];
    
    self.priority = [NSDecimalNumber decimalNumberWithString:(NSString *)[aDictionary objectForKey:@"priority"]];
    
    // child task
    if ([[aDictionary objectForKey:@"childTask"] isKindOfClass:[NSArray class]]) {
        
        NSArray *tmpChildTasks = [aDictionary objectForKey:@"childTask"];
        if (tmpChildTasks) {
            
            NSMutableArray *parsedTasks = [NSMutableArray arrayWithCapacity:[tmpChildTasks count]];
            
            for (id item in tmpChildTasks) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedTasks addObject:[Task instanceFromDictionary:item]];
                }
            }
            
            childTask = parsedTasks;
        }
    }
}

// Required by NSCopying protocol.
- (id) copyWithZone:(NSZone *)zone {
    
    Task *copy = [[Task alloc] init];
    
    copy.taskTitle = [taskTitle copyWithZone:zone];
    copy.taskId = [taskId copyWithZone:zone];
    copy.taskDescription = [taskDescription copyWithZone:zone];
    copy.endDate = [endDate copyWithZone:zone];
    copy.completed = completed;
    copy.startDate = [startDate copyWithZone:zone];
    copy.userCreated = [userCreated copyWithZone:zone];
    copy.childTask = [childTask copyWithZone:zone];
    copy.parentTaskId = [parentTaskId copyWithZone:zone];
    copy.priority = [priority copyWithZone:zone];
    
    //copy.dateCreated = [dateCreated copyWithZone:zone];
    //copy.endDateReal = [endDateReal copyWithZone:zone];
    //copy.flagPublic = flagPublic;
    
    //copy.canceled = canceled;
    
    //copy.startDateReal = [startDateReal copyWithZone:zone];
    
    return copy;
}

- (BOOL)isLeaf {
    if ([childTask count] > 0)
        return NO;
    else
        return YES;
}

- (NSArray *)createTaskKeys
{
    //NSArray *retArr = [[NSArray alloc] initWithObjects: @"projectTitle", @"projectDescription", @"endDate", @"endDateReal", @"flagPublic", @"completed", @"parentProjectId", @"startDate", @"startDateReal", @"userCreated", nil];
    //NSArray *retArr = [[NSArray alloc] initWithObjects: @"projectTitle", @"projectDescription", @"flagPublic", nil];
    NSArray *retArr = [[NSArray alloc] initWithObjects: @"taskTitle", @"taskDescription", @"completed", @"startDate", @"endDate", nil];
    
    return retArr;
}

- (NSArray *)taskIdKey {
    NSArray *retArr = [[NSArray alloc] initWithObjects:@"taskId", nil];
    
    return retArr;
}

@end
