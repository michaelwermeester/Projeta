//
//  PTCommon.h
//  Projeta
//
//  Created by Michael Wermeester on 03/08/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTCommon : NSObject

// charge l'URL serveur à partir du fichier de préférences/configuration
// et le retourne comme NSURL. 
+ (NSURL*)serverURL;
// charge l'URL serveur à partir du fichier de préférences/configuration
// et le retourne comme NSString. 
+ (NSString*)serverURLString;

// retourne un NSDate à partir d'un JSON date-string. 
// Format de date retourné par le webservice: 2011-08-26T18:25:36+02:00
+ (NSDate*)dateFromJSONString:(NSString*)aDate;
// retourne un string qui peut être envoyé au webservice à partir d'une date.
+ (NSString*)stringJSONFromDate:(NSDate *)aDate;
// retourne un string à partir d'une date.
+ (NSString*)stringFromDate:(NSDate *)aDate;

#pragma mark Web service methods
// executes a given HTTP method on a given resource with a given dictionary.
+ (BOOL)executeHTTPMethodForDictionary:(NSDictionary *)dict resourceString:(NSString *)resourceString httpMethod:(NSString *)httpMethod successBlock:(void(^)(NSMutableData *))successBlock_;

// exécute une méthode HTTP POST sur une ressource spécifié avec un dictionnaire spécifié. 
+ (BOOL)executePOSTforDictionary:(NSDictionary *)dict resourceString:(NSString *)resourceString successBlock:(void(^)(NSMutableData *))successBlock_;
+ (BOOL)executePOSTforDictionaryWithBlocks:(NSDictionary *)dict resourceString:(NSString *)resourceString successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)(NSError *))failureBlock_;

// executes the HTTP PUT method on a given resource with a given dictionary.
+ (BOOL)executePUTforDictionary:(NSDictionary *)dict resourceString:(NSString *)resourceString;

// exécute une méthode HTTP POST sur une ressource spécifié avec un dictionnaire spécifié avec failure block en plus. 
+ (BOOL)executePUTforDictionaryWithBlocks:(NSDictionary *)dict resourceString:(NSString *)resourceString successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)(NSError *))failureBlock_;
// exécute une méthode HTTP sur une ressource spécifié avec un dictionnaire spécifié avec possibilité de définir des blocks success et failure.
+ (BOOL)executeHTTPMethodForDictionaryWithFailureBlock:(NSDictionary *)dict resourceString:(NSString *)resourceString httpMethod:(NSString *)httpMethod successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)(NSError *))failureBlock_;
// exécute une méthode HTTP PUT sur une ressource spécifié avec un dictionnaire spécifié. 
+ (BOOL)executePUTforDictionaryWithSuccessBlock:(NSDictionary *)dict resourceString:(NSString *)resourceString successBlock:(void(^)(NSMutableData *))successBlock_;

#pragma mark JSON

// generates a UUID.
+ (NSString *)GenerateUUID;

@end
