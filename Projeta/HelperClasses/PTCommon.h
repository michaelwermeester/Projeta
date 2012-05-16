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

// retourne un NSDate à partir d'un JSON date-string. 
// Format de date retourné par le webservice: 2011-08-26T18:25:36+02:00
+ (NSDate*)dateFromJSONString:(NSString*)aDate;
// retourne un string pour envoyé au webservice à partir d'une date.
+ (NSString*)stringJSONFromDate:(NSDate *)aDate;

#pragma mark Web service methods
// executes a given HTTP method on a given resource with a given dictionary.
+ (BOOL)executeHTTPMethodForDictionary:(NSDictionary *)dict resourceString:(NSString *)resourceString httpMethod:(NSString *)httpMethod successBlock:(void(^)(NSMutableData *))successBlock_;

// executes the HTTP POST method on a given resource with a given dictionary.
+ (BOOL)executePOSTforDictionary:(NSDictionary *)dict resourceString:(NSString *)resourceString successBlock:(void(^)(NSMutableData *))successBlock_;
+ (BOOL)executePOSTforDictionaryWithBlocks:(NSDictionary *)dict resourceString:(NSString *)resourceString successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)(NSError *))failureBlock_;

// executes the HTTP PUT method on a given resource with a given dictionary.
+ (BOOL)executePUTforDictionary:(NSDictionary *)dict resourceString:(NSString *)resourceString;

// 22-01-2012
+ (BOOL)executePUTforDictionaryWithBlocks:(NSDictionary *)dict resourceString:(NSString *)resourceString successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)(NSError *))failureBlock_;
// 22-01-2012
+ (BOOL)executeHTTPMethodForDictionaryWithFailureBlock:(NSDictionary *)dict resourceString:(NSString *)resourceString httpMethod:(NSString *)httpMethod successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)(NSError *))failureBlock_;
// 25-03-2012
+ (BOOL)executePUTforDictionaryWithSuccessBlock:(NSDictionary *)dict resourceString:(NSString *)resourceString successBlock:(void(^)(NSMutableData *))successBlock_;

#pragma mark JSON

// generates a UUID.
+ (NSString *)GenerateUUID;

@end
