//
//  NSDate+MWExtensions.m
//  Projeta
//
//  Created by Michael Wermeester on 5/16/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "NSDate+MWExtensions.h"

@implementation NSDate (MWExtensions)

- (NSInteger)numberOfDaysUntil:(NSDate *)aDate {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit fromDate:self toDate:aDate options:0];
    
    return [components day];
}

@end
