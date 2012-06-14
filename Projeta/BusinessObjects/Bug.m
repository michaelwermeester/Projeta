//
//  Bug.m
//  Projeta
//
//  Created by Michael Wermeester on 4/21/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "Bug.h"
#import "BugCategory.h"
#import "Project.h"
#import "PTCommon.h"
#import "User.h"

@implementation Bug

@synthesize bugCategory;
@synthesize bugId;
@synthesize canceled;
@synthesize deleted;
@synthesize dateReported;
@synthesize details;
@synthesize fixed;
@synthesize priority;
@synthesize project;
@synthesize title;
@synthesize userAssigned;
@synthesize userReported;


@synthesize projectTitle;

// état du bug.
@synthesize bugStatus = bugStatus;
@synthesize bugPercentage = bugPercentage;

// Permet de créer un objet Bug à partir d'un dictionnaire. 
+ (Bug *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    Bug *instance = [[Bug alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

// initialise les propriétés à partir du dictionnaire. 
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.dateReported = [PTCommon dateFromJSONString:[aDictionary objectForKey:@"dateReported"]];
    
    self.canceled = [(NSString *)[aDictionary objectForKey:@"canceled"] boolValue];
    self.deleted = [(NSString *)[aDictionary objectForKey:@"deleted"] boolValue];
    self.fixed = [(NSString *)[aDictionary objectForKey:@"fixed"] boolValue];
    
    self.details = [aDictionary objectForKey:@"details"];
    
    self.bugId = [NSDecimalNumber decimalNumberWithString:(NSString *)[aDictionary objectForKey:@"bugId"]];
    self.title = [aDictionary objectForKey:@"title"];
    
    self.userAssigned = [User instanceFromDictionary:[aDictionary objectForKey:@"userAssigned"]];
    
    self.userReported = [User instanceFromDictionary:[aDictionary objectForKey:@"userReported"]];
    
    
    // état du bogue.
    if ([[aDictionary objectForKey:@"bugStatus"] isKindOfClass:[NSNull class]] == NO)
        self.bugStatus = [aDictionary objectForKey:@"bugStatus"];
    // pourcentage.
    if ([[aDictionary objectForKey:@"bugPercentage"] isKindOfClass:[NSNull class]] == NO)
        self.bugPercentage = [NSDecimalNumber decimalNumberWithString:(NSString *)[aDictionary objectForKey:@"bugPercentage"]];
    
    // titre du projet.
    self.projectTitle = [aDictionary objectForKey:@"projectTitle"];
    
    if ([[aDictionary objectForKey:@"bugCategory"] isKindOfClass:[NSNull class]] == NO)
        self.bugCategory = [BugCategory instanceFromDictionary:[aDictionary objectForKey:@"bugCategory"]];
    
}


- (id) copyWithZone:(NSZone *)zone {
    
    Bug *copy = [[Bug alloc] init];
    
    
    copy.bugId = [bugId copyWithZone:zone];
    copy.bugCategory = [bugCategory copyWithZone:zone];
    copy.canceled = canceled;
    copy.deleted = deleted;
    copy.dateReported = [dateReported copyWithZone:zone];
    copy.details = [details copyWithZone:zone];
    copy.fixed = fixed;
    copy.priority = [priority copyWithZone:zone];
    copy.project = [project copyWithZone:zone];
    copy.title = [title copyWithZone:zone];
    copy.userAssigned = [userAssigned copyWithZone:zone];
    copy.userReported = [userReported copyWithZone:zone];
    
    return copy;
}

- (NSArray *)bugIdKey {
    NSArray *retArr = [[NSArray alloc] initWithObjects:@"bugId", nil];
    
    return retArr;
}

- (NSArray *)createBugKeys
{
    NSArray *retArr = [[NSArray alloc] initWithObjects: @"title", @"details", @"fixed", nil];
    
    return retArr;
}

- (NSArray *)updateBugKeys
{
    NSArray *retArr = [[NSArray alloc] initWithObjects: @"bugId", @"title", @"details", @"fixed", nil];
    
    return retArr;
}

- (NSString *)bugPercentageStatus {
    
    NSString *retString = [[NSString alloc] initWithString:@""];
    
    if ([self bugPercentage]) {
        if ([self.bugPercentage isEqualToNumber:[NSDecimalNumber notANumber]] == NO) {
            retString = [retString stringByAppendingString:[[self bugPercentage] stringValue]];
            // ajouter signe %.
            retString = [retString stringByAppendingString:@"%"];
        }
    }
    
    if ([self bugPercentage] && [self bugStatus]) {
        if ([self.bugPercentage isEqualToNumber:[NSDecimalNumber notANumber]] == NO) {
            retString = [retString stringByAppendingString:@" - "];
        }
    }
    
    if ([self bugStatus]) {
        retString = [retString stringByAppendingString:[self bugStatus]];
    }
    
    return retString;
}

@end
