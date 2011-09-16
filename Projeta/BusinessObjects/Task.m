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
    //self.completed = [(NSString *)[aDictionary objectForKey:@"completed"] boolValue];
    self.completed = YES;
    self.userCreated = [User instanceFromDictionary:[aDictionary objectForKey:@"userCreated"]];
    
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

@end
