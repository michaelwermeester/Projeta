//
//  PTDateFormatter.m
//  Projeta
//
//  Created by Michael Wermeester on 4/1/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "MWDateFormatter.h"

@implementation MWDateFormatter

// convertit un string en date. 
- (NSDate *)dateFromString:(NSString *)string {
 
    if ((string == nil) || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualTo:@""]) {
        return nil;
    } else {
        return [super dateFromString:string];
    }
}

- (BOOL)getObjectValue:(out id *)obj forString:(NSString *)string range:(inout NSRange *)rangep error:(out NSError **)error {
    
    if ((string == nil) || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualTo:@""]) {
        
        obj = nil;
        
        return YES;
    } else {
        return [super getObjectValue:obj forString:string range:rangep error:error];
    }
}

@end
