//
//  PTCommon.m
//  Projeta
//
//  Created by Michael Wermeester on 03/08/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import "PTCommon.h"
#import "MWConnectionController.h"

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


#pragma mark Web service methods

// executes a given HTTP method on a given resource with a given dictionary.
+ (BOOL)executeHTTPMethodForDictionary:(NSDictionary *)dict resourceString:(NSString *)resourceString httpMethod:(NSString *)httpMethod successBlock:(void(^)(NSMutableData *))successBlock_
{
    // create NSData from dictionary
    BOOL success;
    NSError* error;
    NSData *requestData = [[NSData alloc] init];
    requestData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    
    //debug.
    NSLog(@"res: %@", [[NSString alloc] initWithData:requestData encoding:NSASCIIStringEncoding]);
    
    // get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    //urlString = [urlString stringByAppendingString:@"resources/users"];
    urlString = [urlString stringByAppendingString:resourceString];
    
    // convert to NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {
                                                        successBlock_(data);
                                                    }
                                                    failureBlock:^(NSError *error) {
                                                        
                                                    }];
    
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString* requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [requestData length]];
    
    //[urlRequest setHTTPMethod:@"POST"]; // create
    //[urlRequest setHTTPMethod:@"PUT"]; // update
    [urlRequest setHTTPMethod:httpMethod];
    [urlRequest setHTTPBody:requestData];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:requestDataLengthString forHTTPHeaderField:@"Content-Length"];
    [urlRequest setTimeoutInterval:30.0];
    
    success = [connectionController startRequestForURL:url setRequest:urlRequest];
    
    return success;
}

// executes the HTTP POST method on a given resource with a given dictionary.
+ (BOOL)executePOSTforDictionary:(NSDictionary *)dict resourceString:(NSString *)resourceString successBlock:(void(^)(NSMutableData *))successBlock_ {
    
    return [PTCommon executeHTTPMethodForDictionary:dict resourceString:resourceString httpMethod:@"POST" successBlock:successBlock_];
}

// executes the HTTP PUT method on a given resource with a given dictionary.
+ (BOOL)executePUTforDictionary:(NSDictionary *)dict resourceString:(NSString *)resourceString {
    
    return [PTCommon executeHTTPMethodForDictionary:dict resourceString:resourceString httpMethod:@"PUT" successBlock:^(NSMutableData *data){}];
}

// 22-01-2012
// executes the HTTP PUT method on a given resource with a given dictionary.
+ (BOOL)executePUTforDictionaryWithBlocks:(NSDictionary *)dict resourceString:(NSString *)resourceString successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)(NSError *))failureBlock_
{
    
    return [PTCommon executeHTTPMethodForDictionaryWithFailureBlock:dict resourceString:resourceString httpMethod:@"PUT" successBlock:successBlock_ failureBlock:failureBlock_];
}

// 22-01-2012
// executes a given HTTP method on a given resource with a given dictionary.
+ (BOOL)executeHTTPMethodForDictionaryWithFailureBlock:(NSDictionary *)dict resourceString:(NSString *)resourceString httpMethod:(NSString *)httpMethod successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)(NSError *))failureBlock_
{
    // create NSData from dictionary
    BOOL success;
    NSError* error;
    NSData *requestData = [[NSData alloc] init];
    requestData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    
    // debug.
    //NSLog(@"res: %@", [[NSString alloc] initWithData:requestData encoding:NSASCIIStringEncoding]);
    
    // get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    //urlString = [urlString stringByAppendingString:@"resources/users"];
    urlString = [urlString stringByAppendingString:resourceString];
    
    // convert to NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {
                                                        successBlock_(data);
                                                    }
                                                    failureBlock:^(NSError *error) {
                                                        failureBlock_(error);
                                                    }];
    
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString* requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [requestData length]];
    
    //[urlRequest setHTTPMethod:@"POST"]; // create
    //[urlRequest setHTTPMethod:@"PUT"]; // update
    [urlRequest setHTTPMethod:httpMethod];
    [urlRequest setHTTPBody:requestData];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:requestDataLengthString forHTTPHeaderField:@"Content-Length"];
    [urlRequest setTimeoutInterval:30.0];
    
    success = [connectionController startRequestForURL:url setRequest:urlRequest];
    
    return success;
}

#pragma mark JSON

// generates a UUID.
+ (NSString *)GenerateUUID
{    
    CFUUIDRef   uuid;
    CFStringRef string;
    
    uuid = CFUUIDCreate( NULL );
    string = CFUUIDCreateString( NULL, uuid );
    
    // http://www.mikeash.com/pyblog/friday-qa-2011-09-30-automatic-reference-counting.html
    NSString *uuidString = (__bridge NSString *)string;
    CFRelease(string);
    
    return uuidString;
}

@end
