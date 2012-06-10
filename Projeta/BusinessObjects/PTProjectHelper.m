//
//  PTProjectHelper.m
//  Projeta
//
//  Created by Michael Wermeester on 26/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "MainWindowController.h"
#import "MWConnectionController.h"
#import "PTCommon.h"
#import "PTProjectHelper.h"
#import "Project.h"

@implementation PTProjectHelper

@synthesize projects = projects;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (PTProjectHelper *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    PTProjectHelper *instance = [[PTProjectHelper alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (!aDictionary) {
        return;
    }
    
    
    NSArray *receivedProjects = [aDictionary objectForKey:@"project"];
    if (receivedProjects) {
        
        NSMutableArray *parsedProjects = [NSMutableArray arrayWithCapacity:[receivedProjects count]];
        for (id item in receivedProjects) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedProjects addObject:[Project instanceFromDictionary:item]];
            }
        }
        
        self.projects = parsedProjects;
        
    }
    
}

+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary {
    
    if (!aDictionary) {
        return nil;
    }
    
    // if dictionary contains array of dictionaries
    if ([[aDictionary objectForKey:@"project"] isKindOfClass:[NSArray class]]) {
        
        NSArray *receivedProjects = [aDictionary objectForKey:@"project"];
        if (receivedProjects) {
            
            NSMutableArray *parsedProjects = [NSMutableArray arrayWithCapacity:[receivedProjects count]];
            
            for (id item in receivedProjects) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedProjects addObject:[Project instanceFromDictionary:item]];
                }
            }
            
            return parsedProjects;
        }
    }
    // if dictionary contains just a dictionary
    else if ([[aDictionary objectForKey:@"project"] isKindOfClass:[NSDictionary class]]) {
        
        NSMutableArray *parsedProjects = [NSMutableArray arrayWithCapacity:1];
        
        [parsedProjects addObject:[Project instanceFromDictionary:[aDictionary objectForKey:@"project"]]];
        
        return parsedProjects;
    }
    
    return nil;
}


// Crée un nouveau projet dans la base de données.
// mainWindowController parameter is used for animating the main window's progress indicator.
+ (BOOL)createProject:(Project *)theProject successBlock:(void(^)(NSMutableData *))successBlock_ mainWindowController:(id)sender {
    
    BOOL success = NO;
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // start animating the main window's circular progress indicator.
        [sender startProgressIndicatorAnimation];
    }
    
    // create dictionary from User object
    //NSDictionary *dict = [theUser dictionaryWithValuesForKeys:[theUser allKeys]];
    // update username, first name, last name and email address
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[theProject dictionaryWithValuesForKeys:[theProject createProjectKeys]]];
    
    
    // créer dictionnaire 'user création'.
    NSDictionary *userDict = [theProject.userCreated dictionaryWithValuesForKeys:[theProject.userCreated userIdKey]];
    // ajouter ce dictionnaire sous la clé 'userCreated'.
    [dict setObject:userDict forKey:@"userCreated"];
    
    // s'il s'agit d'un sous-projet...
    if (theProject.parentProjectId) {
        // créer dictionnaire 'parentProjectId'.
        Project *parentProject = [[Project alloc] init];
        parentProject.projectId = theProject.parentProjectId;
        
        NSDictionary *parentProjectDict = [parentProject dictionaryWithValuesForKeys:[parentProject projectIdKey]];
        // ajouter ce dictionnaire sous la clé 'parentProjectId'.
        [dict setObject:parentProjectDict forKey:@"parentProjectId"];
    }
    
    
    // Dates début et fin de projet.
    if ([theProject stringStartDate])
        [dict setObject:[theProject stringStartDate] forKey:@"startDate"];
    if ([theProject stringEndDate])
        [dict setObject:[theProject stringEndDate] forKey:@"endDate"];
    
    // API resource string.
    NSString *resourceString = [[NSString alloc] initWithFormat:@"resources/projects/create"];
    
    // execute the PUT method on the webservice to update the record in the database.
    success = [PTCommon executePOSTforDictionary:dict resourceString:resourceString successBlock:successBlock_];
    
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // stop animating the main window's circular progress indicator.
        [sender stopProgressIndicatorAnimation];
    }
    
    return success;
}

+ (BOOL)deleteProject:(Project *)theProject successBlock:(void(^)(NSMutableData *))successBlock failureBlock:(void(^)())failureBlock mainWindowController:(id)sender {
    
    BOOL success = NO;
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // start animating the main window's circular progress indicator.
        [sender startProgressIndicatorAnimation];
    }
    
    // create dictionary from Project object.
    NSDictionary *dict = [theProject dictionaryWithValuesForKeys:[theProject projectIdKey]];
    
    // API resource string.
    NSString *resourceString = [[NSString alloc] initWithFormat:@"resources/projects/delete"];
    
    // execute the PUT method on the webservice to update the record in the database.
    success = [PTCommon executePOSTforDictionaryWithBlocks:dict resourceString:resourceString successBlock:successBlock failureBlock:failureBlock];
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // stop animating the main window's circular progress indicator.
        [sender stopProgressIndicatorAnimation];
    }
    
    return success;
}

// Crée un nouveau projet dans la base de données.
// mainWindowController parameter is used for animating the main window's progress indicator.
+ (BOOL)updateProject:(Project *)theProject successBlock:(void(^)(NSMutableData *))successBlock_ mainWindowController:(id)sender {
    
    BOOL success = NO;
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // start animating the main window's circular progress indicator.
        [sender startProgressIndicatorAnimation];
    }
    
    // create dictionary from User object
    //NSDictionary *dict = [theUser dictionaryWithValuesForKeys:[theUser allKeys]];
    // update username, first name, last name and email address
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[theProject dictionaryWithValuesForKeys:[theProject updateProjectKeys]]];
    
        
    // s'il s'agit d'un sous-projet...
    /*if (theProject.parentProjectId) {
        // créer dictionnaire 'parentProjectId'.
        Project *parentProject = [[Project alloc] init];
        parentProject.projectId = theProject.parentProjectId;
        
        NSDictionary *parentProjectDict = [parentProject dictionaryWithValuesForKeys:[parentProject projectIdKey]];
        // ajouter ce dictionnaire sous la clé 'parentProjectId'.
        [dict setObject:parentProjectDict forKey:@"parentProjectId"];
    }*/
    
    
    // Dates début et fin de projet.
    if ([theProject stringStartDate])
        [dict setObject:[theProject stringStartDate] forKey:@"startDate"];
    if ([theProject stringEndDate])
        [dict setObject:[theProject stringEndDate] forKey:@"endDate"];
    
    // API resource string.
    NSString *resourceString = [[NSString alloc] initWithFormat:@"resources/projects/update"];
    
    // execute the PUT method on the webservice to update the record in the database.
    success = [PTCommon executePUTforDictionaryWithSuccessBlock:dict resourceString:resourceString successBlock:successBlock_];
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // stop animating the main window's circular progress indicator.
        [sender stopProgressIndicatorAnimation];
    }
    
    return success;
}

/*+ (BOOL)deleteProject:(Project *)theProject successBlock:(void(^)(BOOL))successBlock failureBlock:(void(^)())failureBlock mainWindowController:(id)sender {
    
    BOOL success = NO;
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // start animating the main window's circular progress indicator.
        [sender startProgressIndicatorAnimation];
    }
    
    // get server URL as string
    NSString *resourceString = [PTCommon serverURLString];
    // API resource string.
    resourceString = [resourceString stringByAppendingString:@"resources/projects/delete/"];
    // rajouter l'id du projet à la fin.
    resourceString = [resourceString stringByAppendingString:[theProject.projectId stringValue]];
    
    // execute the PUT method on the webservice to update the record in the database.
    //success = [PTCommon executePOSTforDictionary:dict resourceString:resourceString successBlock:successBlock_];
    
    // convert to NSURL
    NSURL *url = [NSURL URLWithString:resourceString];
    
    
    // NSURLConnection - MWConnectionController
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {
                                                        
                                                        //NSString* resStr = [[NSString alloc] initWithData:data
                                                        //                                         encoding:NSUTF8StringEncoding];
                                                        
                                                        //if ([resStr isEqual:@"1"]) {
                                                            // utilisateur supprimé.
                                                        //    successBlock(YES);
                                                        //} else {
                                                        //    successBlock(NO);
                                                        //}
                                                        
                                                        successBlock(YES);
                                                    }
                                                    failureBlock:^(NSError *error) {
                                                        
                                                        failureBlock();
                                                    }];
    
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    [connectionController startRequestForURL:url setRequest:urlRequest];
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // stop animating the main window's circular progress indicator.
        [sender stopProgressIndicatorAnimation];
    }
    
    return success;
}*/


+ (BOOL)updateUsersVisibleForProject:(Project *)aProject users:(NSMutableDictionary *)users successBlock:(void(^)(NSMutableData *))successBlock failureBlock:(void(^)(NSError *))failureBlock {
    
    BOOL success;
    
    // build URL by adding resource path
    NSString *resourceString = [[NSString alloc] initWithFormat:@"resources/projects/updateUsersVisibleForProject?projectId="];
    resourceString = [resourceString stringByAppendingString:[aProject.projectId stringValue]];
    
    
    // execute the PUT method on the webservice to update the record in the database.
    [PTCommon executePUTforDictionaryWithBlocks:users resourceString:resourceString successBlock:successBlock failureBlock:failureBlock];
    
    return success;
}

+ (BOOL)updateUsergroupsVisibleForProject:(Project *)aProject usergroups:(NSMutableDictionary *)usergroups successBlock:(void(^)(NSMutableData *))successBlock failureBlock:(void(^)(NSError *))failureBlock {
    
    BOOL success;
    
    // build URL by adding resource path
    NSString *resourceString = [[NSString alloc] initWithFormat:@"resources/projects/updateUsergroupsVisibleForProject?projectId="];
    resourceString = [resourceString stringByAppendingString:[aProject.projectId stringValue]];
    
    
    // execute the PUT method on the webservice to update the record in the database.
    [PTCommon executePUTforDictionaryWithBlocks:usergroups resourceString:resourceString successBlock:successBlock failureBlock:failureBlock];
    
    return success;
}

@end