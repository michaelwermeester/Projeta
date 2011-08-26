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

// Convert a date returned by the webservice to NSDate
// Date format returned by the webservice: 2011-08-26T18:25:36+02:00
// Thanks to: http://devbytom.blogspot.com/2011/04/rfc-3339-dates-and-ios-parsing.html
+ (NSDate *)webserviceStringToDate:(NSString *)aDateString {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale;
    enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [df setLocale:enUSPOSIXLocale];
    [df setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ'"];
    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    // remove the last ':'
    NSMutableString* dateString = [aDateString mutableCopy];    
    
    NSRange range = [dateString rangeOfString:@":" options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        // remove the last ':'
        [dateString deleteCharactersInRange:range];
    }
    
    return [df dateFromString:dateString];
}

@end
