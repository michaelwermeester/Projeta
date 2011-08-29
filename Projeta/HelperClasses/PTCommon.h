//
//  PTCommon.h
//  Projeta
//
//  Created by Michael Wermeester on 03/08/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTCommon : NSObject

// loads server URL from preferences file and returns it as NSURL
+ (NSURL*)serverURL;
// loads server URL from preferences file and returns it as NSString
+ (NSString*)serverURLString;

// Convert a date returned by the webservice to NSDate
// Date format returned by the webservice: 2011-08-26T18:25:36+02:00
// Thanks to: http://devbytom.blogspot.com/2011/04/rfc-3339-dates-and-ios-parsing.html
//+ (NSDate *)webserviceStringToDate:(NSString *)aDateString;

@end
