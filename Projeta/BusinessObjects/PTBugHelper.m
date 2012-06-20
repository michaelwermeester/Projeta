//
//  PTBugHelper.m
//  Projeta
//
//  Created by Michael Wermeester on 4/21/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "Bug.h"
#import "BugCategory.h"
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


// Crée un nouveau rapport de bogue dans la base de données.
// mainWindowController parameter is used for animating the main window's progress indicator.
+ (BOOL)createBug:(Bug *)theBug successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)())failureBlock_ mainWindowController:(id)sender {
    
    BOOL success = NO;
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // démarrer l'animation du circular progress indicator sur la fenêtre principale.
        [sender startProgressIndicatorAnimation];
    }

    // créer dictionnaire à partir de l'objet theBug.
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[theBug dictionaryWithValuesForKeys:[theBug createBugKeys]]];
    
    // créer dictionnaire 'user reported'.
    NSDictionary *userDict = [theBug.userReported dictionaryWithValuesForKeys:[theBug.userReported userIdKey]];
    // ajouter ce dictionnaire sous la clé 'userReported'.
    [dict setObject:userDict forKey:@"userReported"];
    
    // créer dictionnaire 'projectId'.
    NSDictionary *projectDict = [theBug.project dictionaryWithValuesForKeys:[theBug.project projectIdKey]];
    // ajouter ce dictionnaire sous la clé 'projectId'.
    [dict setObject:projectDict forKey:@"projectId"];
    
    // créer dictionnaire 'userassigned'.
    if (theBug.userAssigned) {
        NSDictionary *userAssignedDict = [theBug.userAssigned dictionaryWithValuesForKeys:[theBug.userAssigned userIdKey]];
        // ajouter ce dictionnaire sous la clé 'userReported'.
        [dict setObject:userAssignedDict forKey:@"userAssigned"];
    }
    
    // créer dictionnaire 'bugcategoryid'.
    if (theBug.bugCategory) {
        NSDictionary *userAssignedDict = [theBug.bugCategory dictionaryWithValuesForKeys:[theBug.bugCategory bugcategoryIdKey]];
        // ajouter ce dictionnaire sous la clé 'userReported'.
        [dict setObject:userAssignedDict forKey:@"bugcategoryId"];
    }
    
    // API resource string.
    NSString *resourceString = [[NSString alloc] initWithFormat:@"resources/bugs/create"];
    
    // exécuter la méthode POST sur le web-service pour créer l'enregistrement dans la base de données. 
    [PTCommon executePOSTforDictionaryWithBlocks:dict resourceString:resourceString successBlock:successBlock_ failureBlock:failureBlock_];
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // arrêter l'animation du circular progress indicator sur la fenêtre principale.
        [sender stopProgressIndicatorAnimation];
    }
    
    return success;
}

// met à jour un rapport de bogue existant. 
+ (BOOL)updateBug:(Bug *)theBug successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)())failureBlock_ mainWindowController:(id)sender {
    
    BOOL success = NO;
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // démarrer l'animation du circular progress indicator sur la fenêtre principale.
        [sender startProgressIndicatorAnimation];
    }
    
    // créer dictionnaire à partir de l'objet theBug.
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[theBug dictionaryWithValuesForKeys:[theBug updateBugKeys]]];
    
    // créer dictionnaire 'userassigned'.
    if (theBug.userAssigned) {
        NSDictionary *userAssignedDict = [theBug.userAssigned dictionaryWithValuesForKeys:[theBug.userAssigned userIdKey]];
        // ajouter ce dictionnaire sous la clé 'userReported'.
        [dict setObject:userAssignedDict forKey:@"userAssigned"];
    }
    
    // créer dictionnaire 'bugcategoryid'.
    if (theBug.bugCategory) {
        NSDictionary *userAssignedDict = [theBug.bugCategory dictionaryWithValuesForKeys:[theBug.bugCategory bugcategoryIdKey]];
        // ajouter ce dictionnaire sous la clé 'userReported'.
        [dict setObject:userAssignedDict forKey:@"bugcategoryId"];
    }
    
    // API resource string.
    NSString *resourceString = [[NSString alloc] initWithFormat:@"resources/bugs/update"];
    
    // exécuter la méthode PUT sur le web-service pour mettre à jour l'enregistrement dans la base de données. 
    success = [PTCommon executePUTforDictionaryWithBlocks:dict resourceString:resourceString successBlock:successBlock_ failureBlock:failureBlock_];
    
    if ([sender isKindOfClass:[MainWindowController class]]) {
        // arrêter l'animation du circular progress indicator sur la fenêtre principale.
        [sender stopProgressIndicatorAnimation];
    }
    
    return success;
}

@end
