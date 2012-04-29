//
//  Progress.m
//  Projeta
//
//  Created by Michael Wermeester on 4/28/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "Progress.h"

@implementation Progress

@synthesize progressComment;
@synthesize percentageComplete;
@synthesize statusId;
@synthesize status;


- (NSArray *)createProgressKeys
{
    NSArray *retArr = [[NSArray alloc] initWithObjects: @"progressComment", @"percentageComplete", nil];
    
    return retArr;
}

@end
