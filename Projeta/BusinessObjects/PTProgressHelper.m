//
//  PTProgressHelper.m
//  Projeta
//
//  Created by Michael Wermeester on 4/29/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "Bug.h"
#import "Progress.h"
#import "PTCommon.h"
#import "PTProgressHelper.h"
#import "PTStatus.h"
#import "Project.h"
#import "Task.h"

@implementation PTProgressHelper

// Met à jour l'état d'avancement d'un bogue. 
+ (BOOL)createProgress:(Progress *)theProgress forBug:(Bug *)aBug successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)())failureBlock_ mainWindowController:(id)sender {
    
    BOOL success = NO;
    
    // create dictionary from Bug object
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[theProgress dictionaryWithValuesForKeys:[theProgress createProgressKeys]]];
    
    // créer dictionnaire 'bugId'.
    NSDictionary *bugIdDict = [aBug dictionaryWithValuesForKeys:[aBug bugIdKey]];
    // ajouter ce dictionnaire sous la clé 'bugId'.
    [dict setObject:bugIdDict forKey:@"bugId"];
    
    if (theProgress.status) {
        // créer dictionnaire 'statusId'.
        NSDictionary *statusIdDict = [theProgress.status dictionaryWithValuesForKeys:[theProgress.status statusIdKey]];
        // ajouter ce dictionnaire sous la clé 'statusId'.
        [dict setObject:statusIdDict forKey:@"statusId"];
    }
    
    // API resource string.
    NSString *resourceString = [[NSString alloc] initWithFormat:@"resources/progress/create"];
    
    // execute the PUT method on the webservice to update the record in the database.
    [PTCommon executePOSTforDictionaryWithBlocks:dict resourceString:resourceString successBlock:successBlock_ failureBlock:failureBlock_];
    
    return success;
}

// Met à jour l'état d'avancement d'une tâche. 
+ (BOOL)createProgress:(Progress *)theProgress forTask:(Task *)aTask successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)())failureBlock_ mainWindowController:(id)sender {
    
    BOOL success = NO;
    
    // create dictionary from Task object
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[theProgress dictionaryWithValuesForKeys:[theProgress createProgressKeys]]];
    
    // créer dictionnaire 'task_id'.
    NSDictionary *taskIdDict = [aTask dictionaryWithValuesForKeys:[aTask taskIdKey]];
    // ajouter ce dictionnaire sous la clé 'userCreated'.
    [dict setObject:taskIdDict forKey:@"taskId"];
    
    if (theProgress.status) {
        // créer dictionnaire 'task_id'.
        NSDictionary *statusIdDict = [theProgress.status dictionaryWithValuesForKeys:[theProgress.status statusIdKey]];
        // ajouter ce dictionnaire sous la clé 'userCreated'.
        [dict setObject:statusIdDict forKey:@"statusId"];
    }
    
    // API resource string.
    NSString *resourceString = [[NSString alloc] initWithFormat:@"resources/progress/create"];
    
    // execute the PUT method on the webservice to update the record in the database.
    [PTCommon executePOSTforDictionaryWithBlocks:dict resourceString:resourceString successBlock:successBlock_ failureBlock:failureBlock_];
    
    return success;
}


// Met à jour l'état d'avancement d'un projet. 
+ (BOOL)createProgress:(Progress *)theProgress forProject:(Project *)aProject successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)())failureBlock_ mainWindowController:(id)sender {
    
    BOOL success = NO;
    
    // create dictionary from Project object
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[theProgress dictionaryWithValuesForKeys:[theProgress createProgressKeys]]];
    
    // créer dictionnaire 'projectId'.
    NSDictionary *projectIdDict = [aProject dictionaryWithValuesForKeys:[aProject projectIdKey]];
    // ajouter ce dictionnaire sous la clé 'projectId'.
    [dict setObject:projectIdDict forKey:@"projectId"];
    
    if (theProgress.status) {
        // créer dictionnaire 'statusId'.
        NSDictionary *statusIdDict = [theProgress.status dictionaryWithValuesForKeys:[theProgress.status statusIdKey]];
        // ajouter ce dictionnaire sous la clé 'statusId'.
        [dict setObject:statusIdDict forKey:@"statusId"];
    }
    
    // API resource string.
    NSString *resourceString = [[NSString alloc] initWithFormat:@"resources/progress/create"];
    
    // execute the PUT method on the webservice to update the record in the database.
    [PTCommon executePOSTforDictionaryWithBlocks:dict resourceString:resourceString successBlock:successBlock_ failureBlock:failureBlock_];
    
    return success;
}

@end
