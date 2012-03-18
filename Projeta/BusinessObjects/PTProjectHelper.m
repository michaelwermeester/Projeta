//
//  PTProjectHelper.m
//  Projeta
//
//  Created by Michael Wermeester on 26/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "MainWindowController.h"
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

@end