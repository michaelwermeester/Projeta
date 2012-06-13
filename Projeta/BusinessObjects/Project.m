//
//  Project.m
//  Projeta
//
//  Created by Michael Wermeester on 25/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "Project.h"
#import "PTCommon.h"
#import "PTProjectHelper.h"
#import "User.h"

@implementation Project

@synthesize dateCreated = dateCreated;
@synthesize endDate = endDate;
@synthesize endDateReal = endDateReal;
@synthesize flagPublic = flagPublic;
@synthesize completed = completed;
@synthesize canceled = canceled;
@synthesize projectDescription = projectDescription;
@synthesize projectId = projectId;
@synthesize parentProjectId = parentProjectId;
@synthesize projectTitle = projectTitle;
@synthesize startDate = startDate;
@synthesize startDateReal = startDateReal;
@synthesize userAssigned = userAssigned;
@synthesize userCreated = userCreated;
@synthesize childProject = childProject;
// état du projet.
@synthesize projectStatus = projectStatus;
@synthesize projectPercentage = projectPercentage;

// pour calendar control.
@synthesize calendarStartDateReal;


+ (Project *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    Project *instance = [[Project alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.dateCreated = [PTCommon dateFromJSONString:[aDictionary objectForKey:@"dateCreated"]];
    self.endDate = [PTCommon dateFromJSONString:[aDictionary objectForKey:@"endDate"]];
    self.startDate = [PTCommon dateFromJSONString:[aDictionary objectForKey:@"startDate"]];
    self.endDateReal = [PTCommon dateFromJSONString:[aDictionary objectForKey:@"endDateReal"]];
    self.startDateReal = [PTCommon dateFromJSONString:[aDictionary objectForKey:@"startDateReal"]];
    
    self.flagPublic = [(NSString *)[aDictionary objectForKey:@"flagPublic"] boolValue];
    self.completed = [(NSString *)[aDictionary objectForKey:@"completed"] boolValue];
    self.canceled = [(NSString *)[aDictionary objectForKey:@"canceled"] boolValue];
    
    self.projectDescription = [aDictionary objectForKey:@"projectDescription"];
    
    self.projectId = [NSDecimalNumber decimalNumberWithString:(NSString *)[aDictionary objectForKey:@"projectId"]];
    self.projectTitle = [aDictionary objectForKey:@"projectTitle"];
    
    self.userAssigned = [User instanceFromDictionary:[aDictionary objectForKey:@"userAssigned"]];
    
    self.userCreated = [User instanceFromDictionary:[aDictionary objectForKey:@"userCreated"]];
    
    if ([[aDictionary objectForKey:@"parentProjectId"] isKindOfClass:[NSArray class]] == NO) {
        self.parentProjectId = [NSDecimalNumber decimalNumberWithString:(NSString *)[aDictionary objectForKey:@"parentProjectId"]];
    }
    
    // état du projet.
    if ([[aDictionary objectForKey:@"projectStatus"] isKindOfClass:[NSNull class]] == NO)
        self.projectStatus = [aDictionary objectForKey:@"projectStatus"];
    // pourcentage.
    if ([[aDictionary objectForKey:@"projectPercentage"] isKindOfClass:[NSNull class]] == NO)
        self.projectPercentage = [NSDecimalNumber decimalNumberWithString:(NSString *)[aDictionary objectForKey:@"projectPercentage"]];
    
    
    // child projects
    if ([[aDictionary objectForKey:@"childProject"] isKindOfClass:[NSArray class]]) {
        
        NSArray *tmpChildProjects = [aDictionary objectForKey:@"childProject"];
        if (tmpChildProjects) {
            
            NSMutableArray *parsedProjects = [NSMutableArray arrayWithCapacity:[tmpChildProjects count]];
            
            for (id item in tmpChildProjects) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedProjects addObject:[Project instanceFromDictionary:item]];
                }
            }
            
            childProject = parsedProjects;
        }
    }
    
}

- (BOOL)isLeaf {
    if ([childProject count] > 0)
        return NO;
    else
        return YES;
}

// Required by NSCopying protocol.
- (id) copyWithZone:(NSZone *)zone {
    
    Project *copy = [[Project alloc] init];
    
    copy.projectTitle = [projectTitle copyWithZone:zone];
    copy.projectId = [projectId copyWithZone:zone];
    copy.projectDescription = [projectDescription copyWithZone:zone];
    copy.endDate = [endDate copyWithZone:zone];
    copy.dateCreated = [dateCreated copyWithZone:zone];
    copy.endDateReal = [endDateReal copyWithZone:zone];
    copy.flagPublic = flagPublic;
    copy.completed = completed;
    copy.canceled = canceled;
    copy.parentProjectId = [parentProjectId copyWithZone:zone];
    copy.startDate = [startDate copyWithZone:zone];
    copy.startDateReal = [startDateReal copyWithZone:zone];
    copy.userAssigned = [userAssigned copyWithZone:zone];
    copy.userCreated = [userCreated copyWithZone:zone];
    copy.childProject = [childProject copyWithZone:zone];
    
    copy.projectPercentage = [projectPercentage copyWithZone:zone];
    copy.projectStatus = [projectStatus copyWithZone:zone];
    
    return copy;
}

- (NSMutableArray *)childObject {
    return childProject;
}

- (NSString *)objectTitle {
    return projectTitle;
}

- (void)setObjectTitle:(NSString *)anObjectTitle {
    [self setProjectTitle:anObjectTitle];
}

- (NSArray *)createProjectKeys
{
    NSArray *retArr = [[NSArray alloc] initWithObjects: @"projectTitle", @"projectDescription", @"flagPublic", @"completed", @"startDate", @"startDateReal", @"endDate", @"endDateReal", nil];
    
    return retArr;
}

- (NSArray *)updateProjectKeys
{
    NSArray *retArr = [[NSArray alloc] initWithObjects: @"projectId", @"projectTitle", @"projectDescription", nil];
    
    return retArr;
}

- (NSArray *)projectIdKey {
    NSArray *retArr = [[NSArray alloc] initWithObjects:@"projectId", nil];
    
    return retArr;
}


// pour calendar control.
- (NSDate *)calendarStartDateReal {
    if (startDateReal != nil)
        return startDateReal;
    else 
        return [NSDate date];
}

- (void)setCalendarStartDateReal:(NSDate *)aCalendarStartDateReal {
    startDateReal = aCalendarStartDateReal;
}

// retourne le pourcentage d'avancement du projet.
- (NSString *)percentageCompleteString {
    
    NSString *retVal = [[NSString alloc] initWithString:@""];
    
    // si le percentage est un numéro.
    if (self.projectPercentage) {
        if ([self.projectPercentage isEqualToNumber:[NSDecimalNumber notANumber]] == NO) {
            // pourcentage.
            retVal = [retVal stringByAppendingString:[self.projectPercentage stringValue]];
            // ajouter le signe de pourcentage.
            retVal = [retVal stringByAppendingString:@" %"];
        } 
    }
    
    return retVal;
}

// Retourne la date de fin de projet en String en format yyyy-MM-dd.
- (NSString *)stringEndDate {
    
    return [PTCommon stringJSONFromDate:endDate];
}

// Retourne la date de début de projet en String en format yyyy-MM-dd.
- (NSString *)stringStartDate {
    
    return [PTCommon stringJSONFromDate:startDate];
}

- (NSString *)projectPercentageStatus {
    
    NSString *retString = [[NSString alloc] initWithString:@""];
    
    if ([self projectPercentage]) {
        if ([self.projectPercentage isEqualToNumber:[NSDecimalNumber notANumber]] == NO) {
            retString = [retString stringByAppendingString:[[self projectPercentage] stringValue]];
            // ajouter signe %.
            retString = [retString stringByAppendingString:@"%"];
        }
    }
    
    if ([self projectPercentage] && [self projectStatus]) {
        if ([self.projectPercentage isEqualToNumber:[NSDecimalNumber notANumber]] == NO) {
            retString = [retString stringByAppendingString:@" - "];
        }
    }
    
    if ([self projectStatus]) {
        retString = [retString stringByAppendingString:[self projectStatus]];
    }
    
    return retString;
}

@end
