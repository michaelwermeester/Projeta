//
//  PTBugHelper.m
//  Projeta
//
//  Created by Michael Wermeester on 4/21/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "Bug.h"
#import "MainWindowController.h"
#import "PTBugHelper.h"
#import "PTCommon.h"

@implementation PTBugHelper

@synthesize bug = bug;

+ (PTBugHelper *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    PTBugHelper *instance = [[PTBugHelper alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    
    NSArray *receivedBug = [aDictionary objectForKey:@"bug"];
    if ([receivedBug isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *parsedBug = [NSMutableArray arrayWithCapacity:[receivedBug count]];
        for (NSDictionary *item in receivedBug) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedBug addObject:[Bug instanceFromDictionary:item]];
            }
        }
        
        self.bug = parsedBug;
    }
}

+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary {
    
    if (!aDictionary) {
        return nil;
    }
    
    // if dictionary contains array of dictionaries
    if ([[aDictionary objectForKey:@"bug"] isKindOfClass:[NSArray class]]) {
        
        NSArray *receivedBugs = [aDictionary objectForKey:@"bug"];
        if (receivedBugs) {
            
            NSMutableArray *parsedBugs = [NSMutableArray arrayWithCapacity:[receivedBugs count]];
            
            for (id item in receivedBugs) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedBugs addObject:[Bug instanceFromDictionary:item]];
                }
            }
            
            return parsedBugs;
        }
    }
    // if dictionary contains just a dictionary
    else if ([[aDictionary objectForKey:@"bug"] isKindOfClass:[NSDictionary class]]) {
        
        NSMutableArray *parsedBugs = [NSMutableArray arrayWithCapacity:1];
        
        [parsedBugs addObject:[Bug instanceFromDictionary:[aDictionary objectForKey:@"bug"]]];
        
        return parsedBugs;
    }
    
    return nil;
}


// Crée une nouvelle tâche dans la base de données.
// mainWindowController parameter is used for animating the main window's progress indicator.
+ (BOOL)createBug:(Bug *)theBug successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)())failureBlock_ mainWindowController:(id)sender {
    
    BOOL success = NO;
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // start animating the main window's circular progress indicator.
        [sender startProgressIndicatorAnimation];
    }
    
    // create dictionary from User object
    //NSDictionary *dict = [theUser dictionaryWithValuesForKeys:[theUser allKeys]];
    // update username, first name, last name and email address
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[theBug dictionaryWithValuesForKeys:[theBug createBugKeys]]];
    
    // créer dictionnaire 'user création'.
    NSDictionary *userDict = [theBug.userReported dictionaryWithValuesForKeys:[theBug.userReported userIdKey]];
    // ajouter ce dictionnaire sous la clé 'userCreated'.
    [dict setObject:userDict forKey:@"userReported"];
    
    // s'il s'agit d'un sous-projet...
//    if (theTask.parentTaskId) {
//        // créer dictionnaire 'parentProjectId'.
//        Task *parentTask = [[Task alloc] init];
//        parentTask.taskId = theTask.parentTaskId;
//        
//        NSDictionary *parentTaskDict = [parentTask dictionaryWithValuesForKeys:[parentTask taskIdKey]];
//        // ajouter ce dictionnaire sous la clé 'parentProjectId'.
//        [dict setObject:parentTaskDict forKey:@"parentTaskId"];
//    }
    
    
    // Dates début et fin de projet.
//    if ([theTask stringStartDate])
//        [dict setObject:[theTask stringStartDate] forKey:@"startDate"];
//    if ([theTask stringEndDate])
//        [dict setObject:[theTask stringEndDate] forKey:@"endDate"];
    
    // créer dictionnaire 'user création'.
    NSDictionary *projectDict = [theBug.project dictionaryWithValuesForKeys:[theBug.project projectIdKey]];
    // ajouter ce dictionnaire sous la clé 'userCreated'.
    [dict setObject:projectDict forKey:@"projectId"];
    //[dict setObject:theBug.project.projectIdKey forKey:@"projectId"];
    
    // API resource string.
    NSString *resourceString = [[NSString alloc] initWithFormat:@"resources/bugs/create"];
    
    // execute the PUT method on the webservice to update the record in the database.
    //success = [PTCommon executePOSTforDictionary:dict resourceString:resourceString successBlock:successBlock_];
    [PTCommon executePOSTforDictionaryWithBlocks:dict resourceString:resourceString successBlock:successBlock_ failureBlock:failureBlock_];
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // stop animating the main window's circular progress indicator.
        [sender stopProgressIndicatorAnimation];
    }
    
    return success;
}


+ (BOOL)updateBug:(Bug *)theBug successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)())failureBlock_ mainWindowController:(id)sender {
    
    BOOL success = NO;
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // start animating the main window's circular progress indicator.
        [sender startProgressIndicatorAnimation];
    }
    
    // create dictionary from User object
    //NSDictionary *dict = [theUser dictionaryWithValuesForKeys:[theUser allKeys]];
    // update username, first name, last name and email address
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[theBug dictionaryWithValuesForKeys:[theBug updateBugKeys]]];
    
    
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
    //if ([theTask stringStartDate])
    //    [dict setObject:[theTask stringStartDate] forKey:@"startDate"];
    //if ([theTask stringEndDate])
    //    [dict setObject:[theTask stringEndDate] forKey:@"endDate"];
    
    
    // API resource string.
    NSString *resourceString = [[NSString alloc] initWithFormat:@"resources/bugs/update"];
    
    // execute the PUT method on the webservice to update the record in the database.
    //success = [PTCommon executePUTforDictionaryWithSuccessBlock:dict resourceString:resourceString successBlock:successBlock_];
    success = [PTCommon executePUTforDictionaryWithBlocks:dict resourceString:resourceString successBlock:successBlock_ failureBlock:failureBlock_];
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // stop animating the main window's circular progress indicator.
        [sender stopProgressIndicatorAnimation];
    }
    
    return success;
}

@end
