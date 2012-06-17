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

// charge l'URL serveur à partir du fichier de préférences/configuration
// et le retourne comme NSURL. 
+ (NSURL*)serverURL
{
    // charger les 'user defaults' à partir du fichier de configuration.
    NSString *strURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"ServerURL"];
    
    // retourner l'URL serveur. 
    return [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

// charge l'URL serveur à partir du fichier de préférences/configuration
// et le retourne comme NSString. 
+ (NSString*)serverURLString
{
    // charger les 'user defaults' à partir du fichier de configuration.
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"ServerURL"];
}

#pragma mark Date helper methods

// retourne un NSDate à partir d'un JSON date-string. 
// Format de date retourné par le webservice: 2011-08-26T18:25:36+02:00
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

// retourne un string à partir d'une date.
+ (NSString*)stringFromDate:(NSDate *)aDate {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale;
    enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setLocale:enUSPOSIXLocale];
    [formatter setDateFormat:@"dd'-'MM'-'yyyy"];
    
    NSString *stringFromDate = [formatter stringFromDate:aDate];
    
    return stringFromDate;
}

// pour filtre.
/*+ (NSString*)dateStringForFilterFromDate:(NSDate *)aDate {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale;
    enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setLocale:enUSPOSIXLocale];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd"];
    
    NSString *stringFromDate = [formatter stringFromDate:aDate];
    
    return stringFromDate;
}*/

// retourne un string qui peut être envoyé au webservice à partir d'une date.
+ (NSString*)stringJSONFromDate:(NSDate *)aDate {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale;
    enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setLocale:enUSPOSIXLocale];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd"];
    
    NSString *stringFromDate = [formatter stringFromDate:aDate];
    
    return stringFromDate;
}

#pragma mark Web service methods

// exécute une méthode HTTP spécifié sur une ressource spécifié avec un dictionnaire spécifié.
+ (BOOL)executeHTTPMethodForDictionary:(NSDictionary *)dict resourceString:(NSString *)resourceString httpMethod:(NSString *)httpMethod successBlock:(void(^)(NSMutableData *))successBlock_
{
    return [self executeHTTPMethodForDictionaryWithFailureBlock:dict resourceString:resourceString httpMethod:httpMethod successBlock:successBlock_ failureBlock:^(NSError *error){}];
}

// exécute une méthode HTTP sur une ressource spécifié avec un dictionnaire spécifié avec possibilité de définir des blocks success et failure.
+ (BOOL)executeHTTPMethodForDictionaryWithFailureBlock:(NSDictionary *)dict resourceString:(NSString *)resourceString httpMethod:(NSString *)httpMethod successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)(NSError *))failureBlock_
{
    // créer NSData à partir du dictionnaire. 
    BOOL success;
    NSError* error;
    NSData *requestData = [[NSData alloc] init];
    requestData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    
    // récupérer URL du serveur.
    NSString *urlString = [PTCommon serverURLString];
    // construire l'URL en rajoutant le ressource path. 
    urlString = [urlString stringByAppendingString:resourceString];
    
    // convertir en NSURL. 
    NSURL *url = [NSURL URLWithString:urlString];
    
    // créer nouvau connection controller afin de pouvoir exécuter la requête.
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {
                                                        successBlock_(data);
                                                    }
                                                    failureBlock:^(NSError *error) {
                                                        failureBlock_(error);
                                                    }];
    
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString* requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [requestData length]];
    
    [urlRequest setHTTPMethod:httpMethod]; // PUT, POST, ...
    [urlRequest setHTTPBody:requestData];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:requestDataLengthString forHTTPHeaderField:@"Content-Length"];
    [urlRequest setTimeoutInterval:30.0];
    
    // exécuter la requête.
    success = [connectionController startRequestForURL:url setRequest:urlRequest];
    
    return success;
}

// exécute une méthode HTTP POST sur une ressource spécifié avec un dictionnaire spécifié. 
+ (BOOL)executePOSTforDictionary:(NSDictionary *)dict resourceString:(NSString *)resourceString successBlock:(void(^)(NSMutableData *))successBlock_ {
    
    return [PTCommon executeHTTPMethodForDictionary:dict resourceString:resourceString httpMethod:@"POST" successBlock:successBlock_];
}

// exécute une méthode HTTP POST sur une ressource spécifié avec un dictionnaire spécifié avec failure block en plus. 
+ (BOOL)executePOSTforDictionaryWithBlocks:(NSDictionary *)dict resourceString:(NSString *)resourceString successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)(NSError *))failureBlock_ {
    
    return [PTCommon executeHTTPMethodForDictionaryWithFailureBlock:dict resourceString:resourceString httpMethod:@"POST" successBlock:successBlock_ failureBlock:failureBlock_];
}

// exécute une méthode HTTP PUT sur une ressource spécifié avec un dictionnaire spécifié. 
+ (BOOL)executePUTforDictionary:(NSDictionary *)dict resourceString:(NSString *)resourceString {
    
    return [PTCommon executeHTTPMethodForDictionary:dict resourceString:resourceString httpMethod:@"PUT" successBlock:^(NSMutableData *data){}];
}

// exécute une méthode HTTP PUT sur une ressource spécifié avec un dictionnaire spécifié avec success et failure blocks en plus. 
+ (BOOL)executePUTforDictionaryWithBlocks:(NSDictionary *)dict resourceString:(NSString *)resourceString successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)(NSError *))failureBlock_
{
    
    return [PTCommon executeHTTPMethodForDictionaryWithFailureBlock:dict resourceString:resourceString httpMethod:@"PUT" successBlock:successBlock_ failureBlock:failureBlock_];
}

// exécute une méthode HTTP PUT sur une ressource spécifié avec un dictionnaire spécifié avec failure block en plus. 
+ (BOOL)executePUTforDictionaryWithSuccessBlock:(NSDictionary *)dict resourceString:(NSString *)resourceString successBlock:(void(^)(NSMutableData *))successBlock_ {
    
    return [PTCommon executeHTTPMethodForDictionary:dict resourceString:resourceString httpMethod:@"PUT" successBlock:successBlock_];
}

#pragma mark JSON helper methods. 

// génère un UUID.
+ (NSString *)GenerateUUID
{    
    CFUUIDRef   uuid;
    CFStringRef string;
    
    uuid = CFUUIDCreate( NULL );
    string = CFUUIDCreateString( NULL, uuid );
    
    // source : http://www.mikeash.com/pyblog/friday-qa-2011-09-30-automatic-reference-counting.html
    NSString *uuidString = (__bridge NSString *)string;
    CFRelease(string);
    
    return uuidString;
}

@end
