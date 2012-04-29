//
//  PTProgressHelper.m
//  Projeta
//
//  Created by Michael Wermeester on 4/29/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "Progress.h"
#import "PTCommon.h"
#import "PTProgressHelper.h"
#import "PTStatus.h"
#import "Task.h"

@implementation PTProgressHelper



// Crée une nouvelle tâche dans la base de données.
// mainWindowController parameter is used for animating the main window's progress indicator.
+ (BOOL)createProgress:(Progress *)theProgress forTask:(Task *)aTask successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)())failureBlock_ mainWindowController:(id)sender {
    
    BOOL success = NO;
    
    /*if ([sender isKindOfClass:[MainWindowController class]]) {
     // start animating the main window's circular progress indicator.
     [sender startProgressIndicatorAnimation];
     }*/
    
    // create dictionary from User object
    //NSDictionary *dict = [theUser dictionaryWithValuesForKeys:[theUser allKeys]];
    // update username, first name, last name and email address
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
    //success = [PTCommon executePOSTforDictionary:dict resourceString:resourceString successBlock:successBlock_];
    [PTCommon executePOSTforDictionaryWithBlocks:dict resourceString:resourceString successBlock:successBlock_ failureBlock:failureBlock_];
    
    /*if ([sender isKindOfClass:[MainWindowController class]]) {
     // stop animating the main window's circular progress indicator.
     [sender stopProgressIndicatorAnimation];
     }*/
    
    return success;
}


@end
