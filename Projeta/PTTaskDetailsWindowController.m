//
//  PTProjectDetailsWindowController.m
//  Projeta
//
//  Created by Michael Wermeester on 01/11/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "MainWindowController.h"
#import "Task.h"
#import "PTMainWindowViewController.h"
#import "PTTaskDetailsWindowController.h"
#import "PTTaskHelper.h"
#import "PTTaskListViewController.h"
#import "PTUserHelper.h"

Task *taskCopy;

@implementation PTTaskDetailsWindowController

@synthesize task;

@synthesize isNewTask;

@synthesize arrDevelopers;

@synthesize mainWindowController;
@synthesize okButton;
@synthesize comboDevelopers;


@synthesize tskTreeIndexPath;
@synthesize prjArrCtrlIndex;

@synthesize parentTaskListViewController;

- (id)init
{
    self = [super initWithWindowNibName:@"PTTaskDetailsWindow"];
    //self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        arrDevelopers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)awakeFromNib {
    
    // faire une copie de la tâche en cours.
    taskCopy = [[Task alloc] init];
    taskCopy = [task copy];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    // charger la liste des développeurs à partir du webservice et les mettre dans la combobox.
    [self fetchDevelopersFromWebservice];
}

// lorsque l'utilisateur clique sur le "x rouge" pour fermer la fenêtre. 
- (void)windowShouldClose:(NSNotification *)notification
{
    
    // annuler les changements.
    [self cancelButtonClicked:self];
}

- (IBAction)cancelButtonClicked:(id)sender {
    
    if (isNewTask == NO) {
        
        // cancel changes -> replace current project with previously made copy of project.
        if (tskTreeIndexPath) {
            
            [parentTaskListViewController.taskTreeCtrl removeObjectAtArrangedObjectIndexPath:tskTreeIndexPath];
            
            [parentTaskListViewController.taskTreeCtrl insertObject:taskCopy atArrangedObjectIndexPath:tskTreeIndexPath];
        }
        
    } else {
        // remove the temporary inserted/created user.
        [[parentTaskListViewController taskTreeCtrl] remove:self];
    }
    
    // close this window.
    [self close];
}

- (IBAction)okButtonClicked:(id)sender {
    
    BOOL taskUpdSuc = NO;
    
    // donner le focus au bouton 'OK'.
    [self.window makeFirstResponder:okButton];
    
    if ([comboDevelopers indexOfSelectedItem] > -1) {
        User *selectedDev = [arrDevelopers objectAtIndex:[comboDevelopers indexOfSelectedItem]];
    
        task.userAssigned = selectedDev;
    } else {
        task.userAssigned = nil;
    }
    
    // créer une nouvelle tâche.
    if (isNewTask == YES) {
        
        // user created.
        task.userCreated = mainWindowController.loggedInUser;
        
        
        taskUpdSuc = [PTTaskHelper createTask:task successBlock:^(NSMutableData *data) { 
            [self finishedCreatingTask:data];
        }
                                 failureBlock:^() {
                                     
                                 } mainWindowController:parentTaskListViewController];
    }
    // mettre à jour projet existant.
    else {
        taskUpdSuc = [PTTaskHelper updateTask:task successBlock:^(NSMutableData *data) {
            [self finishedCreatingTask:data];
        } failureBlock:^() {
            
        }
                         mainWindowController:parentTaskListViewController];
    }
}

- (void)finishedCreatingTask:(NSMutableData*)data {
    
    
    NSError *error;
    
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSMutableArray *createdTaskArray = [[NSMutableArray alloc] init];
    
    // à partir du dictionnaire créer des objets Task et les rajouter dans l'array. 
    [createdTaskArray addObjectsFromArray:[PTTaskHelper setAttributesFromJSONDictionary:dict]];
    
    if ([createdTaskArray count] == 1) {
        
        for (Task *tsk in createdTaskArray) {
            
            // reassign user with user returned from web-service. 
            self.task.taskId = [[NSNumber alloc] initWithInt:[tsk.taskId intValue]];
            self.task = tsk;
        }
    }
    
    // close this window.
    [self close];
}

// charger la liste des développeurs à partir du webservice et les mettre dans la combobox.
- (void)fetchDevelopersFromWebservice
{
    // get developers from webservice.
    [PTUserHelper developers:^(NSMutableArray *developers) {
        
        // sort descriptors for array.
        NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fullNameAndUsername"
                                                                        ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
        
        // sort array and affect fetched array to local array.
        [[self mutableArrayValueForKey:@"arrDevelopers"] addObjectsFromArray:[developers sortedArrayUsingDescriptors:sortDescriptors]];
        
        
        // sélectionner développeur attribué (responsable du projet).
        for (NSInteger i = 0; i < [arrDevelopers count]; i++) {
            
            User *u = [arrDevelopers objectAtIndex:i];
            
            if ([u.userId intValue] == [task.userAssigned.userId intValue]) {
                
                [comboDevelopers selectItemAtIndex:i];
                break;
            }
        }
    }
                failureBlock:^(NSError *error) {
                    
                }];
}


// Retourne le titre de la fenêtre.
- (NSString *)windowTitle {
    
    // afficher 'Projet : <nom du projet>'.
    NSString *retVal = @"Tâche";
    if (task) {
        if (task.taskTitle) {
            retVal = [retVal stringByAppendingString:@" : "];
            retVal = [retVal stringByAppendingString:task.taskTitle];
        }
    }
    
    // si nouveau projet, afficher 'Nouveau projet'.
    if (isNewTask)
        retVal = @"Nouvelle tâche";
    
    return retVal;
    
}

@end
