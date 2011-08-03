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

@end
