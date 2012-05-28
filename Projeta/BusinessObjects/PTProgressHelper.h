//
//  PTProgressHelper.h
//  Projeta
//
//  Created by Michael Wermeester on 4/29/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Bug;
@class Progress;
@class Project;
@class Task;

@interface PTProgressHelper : NSObject

// Met à jour l'état d'avancement d'un bogue. 
+ (BOOL)createProgress:(Progress *)theProgress forBug:(Bug *)aProject successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)())failureBlock_ mainWindowController:(id)sender;
// Met à jour l'état d'avancement d'une tâche. 
+ (BOOL)createProgress:(Progress *)theProgress forTask:(Task *)aTask successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)())failureBlock_ mainWindowController:(id)sender;
// Met à jour l'état d'avancement d'un projet. 
+ (BOOL)createProgress:(Progress *)theProgress forProject:(Project *)aProject successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)())failureBlock_ mainWindowController:(id)sender;

@end

