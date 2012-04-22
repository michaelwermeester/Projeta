//
//  PTCommentHelper.m
//  Projeta
//
//  Created by Michael Wermeester on 4/9/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "MainWindowController.h"
#import "PTComment.h"
#import "PTCommentHelper.h"
#import "PTCommon.h"
#import "Task.h"

@implementation PTCommentHelper

@synthesize comment = comment;

+ (PTCommentHelper *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    PTCommentHelper *instance = [[PTCommentHelper alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    
    NSArray *receivedComment= [aDictionary objectForKey:@"comment"];
    if ([receivedComment isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *parsedComment = [NSMutableArray arrayWithCapacity:[receivedComment count]];
        for (NSDictionary *item in receivedComment) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedComment addObject:[PTComment instanceFromDictionary:item]];
            }
        }
        
        self.comment = parsedComment;
    }
}

+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary {
    
    if (!aDictionary) {
        return nil;
    }
    
    // if dictionary contains array of dictionaries
    if ([[aDictionary objectForKey:@"comment"] isKindOfClass:[NSArray class]]) {
        
        NSArray *receivedComments = [aDictionary objectForKey:@"comment"];
        if (receivedComments) {
            
            NSMutableArray *parsedComments = [NSMutableArray arrayWithCapacity:[receivedComments count]];
            
            for (id item in receivedComments) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedComments addObject:[PTComment instanceFromDictionary:item]];
                }
            }
            
            return parsedComments;
        }
    }
    // if dictionary contains just a dictionary
    else if ([[aDictionary objectForKey:@"comment"] isKindOfClass:[NSDictionary class]]) {
        
        NSMutableArray *parsedComments = [NSMutableArray arrayWithCapacity:1];
        
        [parsedComments addObject:[PTComment instanceFromDictionary:[aDictionary objectForKey:@"comment"]]];
        
        return parsedComments;
    }
    
    return nil;
}





// Crée une nouvelle tâche dans la base de données.
// mainWindowController parameter is used for animating the main window's progress indicator.
+ (BOOL)createComment:(PTComment *)theComment forTask:(Task *)aTask successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)())failureBlock_ mainWindowController:(id)sender {
    
    BOOL success = NO;
    
    /*if ([sender isKindOfClass:[MainWindowController class]]) {
        // start animating the main window's circular progress indicator.
        [sender startProgressIndicatorAnimation];
    }*/
    
    // create dictionary from User object
    //NSDictionary *dict = [theUser dictionaryWithValuesForKeys:[theUser allKeys]];
    // update username, first name, last name and email address
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[theComment dictionaryWithValuesForKeys:[theComment createCommentKeys]]];
    
    // créer dictionnaire 'user création'.
    NSDictionary *userDict = [theComment.userCreated dictionaryWithValuesForKeys:[theComment.userCreated userIdKey]];
    // ajouter ce dictionnaire sous la clé 'userCreated'.
    [dict setObject:userDict forKey:@"userCreated"];
    
    
    // créer dictionnaire 'task_id'.
    NSDictionary *taskIdDict = [aTask dictionaryWithValuesForKeys:[aTask taskIdKey]];
    // ajouter ce dictionnaire sous la clé 'userCreated'.
    [dict setObject:taskIdDict forKey:@"taskId"];
    
    
    // API resource string.
    NSString *resourceString = [[NSString alloc] initWithFormat:@"resources/comments/create"];
    
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
