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
@synthesize userAssigned = userAssigned;
@synthesize userCreated = userCreated;
@synthesize completed = completed;
@synthesize childTask = childTask;
@synthesize parentTaskId = parentTaskId;
@synthesize priority = priority;
@synthesize isPersonal = isPersonal;

@synthesize taskStatus = taskStatus;
@synthesize taskPercentage = taskPercentage;

@synthesize projectTitle = projectTitle;

// Permet de créer un objet Task à partir d'un dictionnaire. 
+ (Task *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    Task *instance = [[Task alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    
    return instance;
}

// initialise les propriétés à partir du dictionnaire. 
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
        self.isPersonal = NO;
    else
        self.isPersonal = [(NSString *)[aDictionary objectForKey:@"isPersonal"] boolValue];
    
    self.userAssigned = [User instanceFromDictionary:[aDictionary objectForKey:@"userAssigned"]];
    self.userCreated = [User instanceFromDictionary:[aDictionary objectForKey:@"userCreated"]];
    
    self.priority = [NSDecimalNumber decimalNumberWithString:(NSString *)[aDictionary objectForKey:@"priority"]];
    
    // état de la tâche.
    self.taskStatus = [aDictionary objectForKey:@"taskStatus"];
    // pourcentage.
    if (([[aDictionary objectForKey:@"taskPercentage"] isKindOfClass:[NSNull class]] == NO) && [aDictionary objectForKey:@"taskPercentage"] != nil)
        self.taskPercentage = [NSDecimalNumber decimalNumberWithString:(NSString *)[aDictionary objectForKey:@"taskPercentage"]];
    
    // titre du projet.
    self.projectTitle = [aDictionary objectForKey:@"projectTitle"];
    
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
    copy.userAssigned = [userAssigned copyWithZone:zone];
    copy.userCreated = [userCreated copyWithZone:zone];
    copy.childTask = [childTask copyWithZone:zone];
    copy.parentTaskId = [parentTaskId copyWithZone:zone];
    copy.priority = [priority copyWithZone:zone];
    
    copy.taskPercentage = [taskPercentage copyWithZone:zone];
    copy.taskStatus = [taskStatus copyWithZone:zone];
    
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
    NSArray *retArr = [[NSArray alloc] initWithObjects: @"taskTitle", @"taskDescription", @"completed", @"isPersonal", nil];
    
    return retArr;
}

- (NSArray *)taskIdKey {
    NSArray *retArr = [[NSArray alloc] initWithObjects:@"taskId", nil];
    
    return retArr;
}

- (NSArray *)updateTaskKeys
{
    NSArray *retArr = [[NSArray alloc] initWithObjects: @"taskId", @"taskTitle", @"taskDescription", @"completed", nil];
    
    return retArr;
}

// Retourne la date de fin de projet en String en format yyyy-MM-dd.
- (NSString *)stringEndDate {
    
    return [PTCommon stringJSONFromDate:endDate];
}

// Retourne la date de début de projet en String en format yyyy-MM-dd.
- (NSString *)stringStartDate {
    
    return [PTCommon stringJSONFromDate:startDate];
}

@end
