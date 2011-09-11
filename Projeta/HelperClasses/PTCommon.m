//
//  PTCommon.m
//  Projeta
//
//  Created by Michael Wermeester on 03/08/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import "PTCommon.h"

@implementation PTCommon

// loads server URL from preferences file and returns it as NSURL
+ (NSURL*)serverURL
{
    // load user defaults from preferences file
    NSString *strURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"ServerURL"];
    
    // return URL
    return [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

// loads server URL from preferences file and returns it as NSString
+ (NSString*)serverURLString
{
    // load user defaults from preferences file
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"ServerURL"];
}

// returns NSDate from a given JSON date-string. 
// Date format returned by the webservice: 2011-08-26T18:25:36+02:00
+ (NSDate*)dateFromJSONString:(NSString*)aDate {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale;
    enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [df setLocale:enUSPOSIXLocale];
    [df setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ'"];
    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    if (aDate && ![aDate isKindOfClass:[NSNull class]]) {
        return [df dateFromString:aDate];
    }
    
    return nil;
}

@end
