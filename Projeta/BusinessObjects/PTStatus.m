//
//  PTStatus.m
//  Projeta
//
//  Created by Michael Wermeester on 4/29/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "PTStatus.h"

@implementation PTStatus

@synthesize statusName;
@synthesize statusId;

+ (PTStatus *)initWithId:(NSNumber *)anId name:(NSString *)aName {

    PTStatus *status = [[PTStatus alloc] init];
    
    if (status) {
    
        status.statusId = anId;
        status.statusName = aName;
    }
    
    return status;
}

- (NSString *)description {
    return statusName;
}

// Required by NSCopying protocol.
- (id) copyWithZone:(NSZone *)zone {
    
    PTStatus *copy = [[PTStatus alloc] init];
    
    copy.statusName = [statusName copyWithZone:zone];
    copy.statusId = [statusId copyWithZone:zone];
    
    return copy;
}

- (NSArray *)statusIdKey
{
    NSArray *retArr = [[NSArray alloc] initWithObjects: @"statusId", nil];
    
    return retArr;
}

@end
