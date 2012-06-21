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
    
    // create dictionary from Project object
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
    
    if (theProject.userAssigned) {
        // créer dictionnaire 'userassigned'.
        NSDictionary *userAssignedDict = [theProject.userAssigned dictionaryWithValuesForKeys:[theProject.userAssigned userIdKey]];
        // ajouter ce dictionnaire sous la clé 'userReported'.
        [dict setObject:userAssignedDict forKey:@"userAssigned"];
    }
    
    
    // Dates début et fin de projet.
    if ([theProject stringStartDate])
        [dict setObject:[theProject stringStartDate] forKey:@"startDate"];
    if ([theProject stringEndDate])
        [dict setObject:[theProject stringEndDate] forKey:@"endDate"];
    // Dates début et fin réels de projet.
    if ([theProject stringStartDateReal])
        [dict setObject:[theProject stringStartDateReal] forKey:@"startDateReal"];
    if ([theProject stringEndDateReal])
        [dict setObject:[theProject stringEndDateReal] forKey:@"endDateReal"];
    
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
    
    // create dictionary from Project object
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[theProject dictionaryWithValuesForKeys:[theProject updateProjectKeys]]];
    
    //NSLog(@"daat: %@", theProject)
    // Dates début et fin de projet.
    if ([theProject stringStartDate])
        [dict setObject:[theProject stringStartDate] forKey:@"startDate"];
    if ([theProject stringEndDate])
        [dict setObject:[theProject stringEndDate] forKey:@"endDate"];
    // Dates début et fin réels de projet.
    if ([theProject stringStartDateReal])
        [dict setObject:[theProject stringStartDateReal] forKey:@"startDateReal"];
    if ([theProject stringEndDateReal])
        [dict setObject:[theProject stringEndDateReal] forKey:@"endDateReal"];
    
    if (theProject.userAssigned) {
        // créer dictionnaire 'userassigned'.
        NSDictionary *userAssignedDict = [theProject.userAssigned dictionaryWithValuesForKeys:[theProject.userAssigned userIdKey]];
        // ajouter ce dictionnaire sous la clé 'userReported'.
        [dict setObject:userAssignedDict forKey:@"userAssigned"];
    }
    
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

+ (BOOL)updateClientsVisibleForProject:(Project *)aProject clients:(NSMutableDictionary *)clients successBlock:(void(^)(NSMutableData *))successBlock failureBlock:(void(^)(NSError *))failureBlock {
    
    BOOL success;
    
    // build URL by adding resource path
    NSString *resourceString = [[NSString alloc] initWithFormat:@"resources/projects/updateClientsVisibleForProject?projectId="];
    resourceString = [resourceString stringByAppendingString:[aProject.projectId stringValue]];
    
    
    // execute the PUT method on the webservice to update the record in the database.
    [PTCommon executePUTforDictionaryWithBlocks:clients resourceString:resourceString successBlock:successBlock failureBlock:failureBlock];
    
    return success;
}



//// fetch all client names from web service.
//+ (void)filterProjects:(Project *)aProject status:(NSNumber *)statusId successBlock:(void(^)(NSMutableArray *))successBlock failureBlock:(void(^)(NSError *))failureBlock {
//    
//    // get server URL as string
//    NSString *urlString = [PTCommon serverURLString];
//    // build URL by adding resource path
//    urlString = [urlString stringByAppendingString:@"resources/projects/filter"];
//    
//    ///[self serverClientsToArray:urlString successBlock:successBlock failureBlock:failureBlock];
//}
//
//
//// Fetches users for the given resource URL into an NSMutableArray and executes the successBlock upon success.
//+ (void)serverProjectsToArray:(NSString *)urlString successBlock:(void (^)(NSMutableArray*))successBlock failureBlock:(void(^)(NSError *))failureBlock {
//    
//    // convert to NSURL
//    NSURL *url = [NSURL URLWithString:urlString];
//    
//    NSMutableArray *users= [[NSMutableArray alloc] init];
//    
//    // NSURLConnection - MWConnectionController
//    MWConnectionController* connectionController = [[MWConnectionController alloc] 
//                                                    initWithSuccessBlock:^(NSMutableData *data) {
//                                                        NSError *error;
//                                                        
//                                                        NSDictionary *dict = [[NSDictionary alloc] init];
//                                                        dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//                                                        
//                                                        [users addObjectsFromArray:[PTUserHelper setAttributesFromJSONDictionary:dict]];
//                                                        
//                                                        successBlock(users);
//                                                    }
//                                                    failureBlock:^(NSError *error) {
//                                                        //[self rolesForUserRequestFailed:error];
//                                                    }];
//    
//    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
//    
//    [connectionController startRequestForURL:url setRequest:urlRequest];
//}

@end