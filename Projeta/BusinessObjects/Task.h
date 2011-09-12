//
//  Task.h
//  Projeta
//
//  Created by Michael Wermeester on 11/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"

@interface Task : NSObject {
    NSDate *endDate;
    NSDate *startDate;
    NSString *taskDescription;
    NSNumber *taskId;
    NSString *taskTitle;
    User *userCreated;
    BOOL completed;
    NSMutableArray *childTask;
}

@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, copy) NSString *taskDescription;
@property (nonatomic, copy) NSNumber *taskId;
@property (nonatomic, copy) NSString *taskTitle;
@property (nonatomic, retain) User *userCreated;
@property (nonatomic, assign) BOOL completed;
@property (strong) NSMutableArray *childTask;

+ (Task *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
