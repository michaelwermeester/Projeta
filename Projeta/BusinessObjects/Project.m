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
    
    Project *instance = [[Project alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    // dates
    //self.dateCreated = [PTCommon webserviceStringToDate:[aDictionary objectForKey:@"dateCreated"]];
    //self.endDate = [PTCommon webserviceStringToDate:[aDictionary objectForKey:@"endDate"]];
    //self.startDate = [PTCommon webserviceStringToDate:[aDictionary objectForKey:@"startDate"]];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale;
    enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [df setLocale:enUSPOSIXLocale];
    [df setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ'"];
    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSString *dateCreatedString = [aDictionary objectForKey:@"dateCreated"];
    if (dateCreatedString && ![dateCreatedString isKindOfClass:[NSNull class]]) {
        self.dateCreated = [df dateFromString:dateCreatedString];
    }
    
    NSString *endDateString = [aDictionary objectForKey:@"endDate"];
    if (endDateString && ![endDateString isKindOfClass:[NSNull class]]) {
        self.startDate = [df dateFromString:endDateString];
    }
    
    NSString *startDateString = [aDictionary objectForKey:@"startDate"];
    if (startDateString && ![startDateString isKindOfClass:[NSNull class]]) {
        self.startDate = [df dateFromString:startDateString];
    }
    
    self.flagPublic = [(NSString *)[aDictionary objectForKey:@"flagPublic"] boolValue];
    
    self.projectDescription = [aDictionary objectForKey:@"projectDescription"];
    
    self.projectId = [NSDecimalNumber decimalNumberWithString:(NSString *)[aDictionary objectForKey:@"projectId"]];
    self.projectTitle = [aDictionary objectForKey:@"projectTitle"];
    
    self.userCreated = [User instanceFromDictionary:[aDictionary objectForKey:@"userCreated"]];
    
}

@end
