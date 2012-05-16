//
//  OutlineCollection.m
//  Projeta
//
//  Created by Michael Wermeester on 06/11/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "OutlineCollection.h"

@implementation OutlineCollection

@synthesize childObject;
@synthesize objectTitle;
@synthesize projectTitle;

@synthesize projectDescription;
@synthesize flagPublic;
@synthesize startDateReal;
@synthesize endDateReal;
@synthesize completed;
@synthesize projectStatus;
@synthesize projectPercentage;
@synthesize percentageCompleteString;
@synthesize projectId;
@synthesize childProject;

@synthesize startDate;
@synthesize endDate;

- (BOOL)isLeaf {
    if ([childObject count] > 0)
        return NO;
    else
        return YES;
}

- (id)copyWithZone:(NSZone *)zone {
    
    OutlineCollection *copy = [[OutlineCollection alloc] init];
    
    copy.objectTitle = [objectTitle copyWithZone:zone];
    
    copy.projectTitle = [projectTitle copyWithZone:zone];
    copy.projectId = [projectId copyWithZone:zone];
    copy.projectDescription = [projectDescription copyWithZone:zone];
    copy.endDate = [endDate copyWithZone:zone];
    copy.endDateReal = [endDateReal copyWithZone:zone];
    copy.flagPublic = flagPublic;
    copy.completed = completed;
    copy.startDate = [startDate copyWithZone:zone];
    copy.startDateReal = [startDateReal copyWithZone:zone];
    copy.childProject = [childProject copyWithZone:zone];
    
    copy.projectPercentage = [projectPercentage copyWithZone:zone];
    copy.projectStatus = [projectStatus copyWithZone:zone];
    
    return copy;
}

@end
