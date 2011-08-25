//
//  Project.m
//  Projeta
//
//  Created by Michael Wermeester on 25/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "Project.h"
#import "User.h"

@implementation Project

@synthesize dateCreated = dateCreated;
@synthesize endDate = endDate;
@synthesize flagPublic = flagPublic;
@synthesize projectDescription = projectDescription;
@synthesize projectId = projectId;
@synthesize projectTitle = projectTitle;
@synthesize startDate = startDate;
@synthesize userCreated = userCreated;

+ (Project *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    Project *instance = [[Project alloc] init];     // autorelease?
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    
    NSString *dateCreatedString = [aDictionary objectForKey:@"dateCreated"];
    if (dateCreatedString && ![dateCreatedString isKindOfClass:[NSNull class]]) {
        self.dateCreated = [NSDate dateWithString:dateCreatedString];
    }
    
    
    NSString *endDateString = [aDictionary objectForKey:@"endDate"];
    if (endDateString && ![endDateString isKindOfClass:[NSNull class]]) {
        self.endDate = [NSDate dateWithString:endDateString];
    }
    
    self.flagPublic = [(NSString *)[aDictionary objectForKey:@"flagPublic"] boolValue];
    
    NSString *projectDescriptionString = [aDictionary objectForKey:@"projectDescription"];
    if (projectDescriptionString && ![projectDescriptionString isKindOfClass:[NSNull class]]) {
        self.projectDescription = [NSDate dateWithString:projectDescriptionString];
    }
    
    self.projectId = [NSDecimalNumber decimalNumberWithString:(NSString *)[aDictionary objectForKey:@"projectId"]];
    self.projectTitle = [aDictionary objectForKey:@"projectTitle"];
    
    NSString *startDateString = [aDictionary objectForKey:@"startDate"];
    if (startDateString && ![startDateString isKindOfClass:[NSNull class]]) {
        self.startDate = [NSDate dateWithString:startDateString];
    }
    
    self.userCreated = [User instanceFromDictionary:[aDictionary objectForKey:@"userCreated"]];
    
}

@end
