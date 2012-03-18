//
//  PTProjectDetailsWindowController.m
//  Projeta
//
//  Created by Michael Wermeester on 01/11/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "MainWindowController.h"
#import "Project.h"
#import "PTMainWindowViewController.h"
#import "PTProjectDetailsWindowController.h"
#import "PTProjectHelper.h"
#import "PTProjectListViewController.h"

Project *projectCopy;

@implementation PTProjectDetailsWindowController

@synthesize project;

@synthesize isNewProject;

@synthesize parentProjectListViewController;
@synthesize mainWindowController;


- (id)init
{
    self = [super initWithWindowNibName:@"PTProjectDetailsWindow"];
    //self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib {
    
    // faire une copie du projet en cours.
    projectCopy = [[Project alloc] init];
    projectCopy = [project copy];
    
    // debug
    /*for (Project *p in project.childProject) {
        
        NSLog(@"title: %@", [p projectTitle] );
        
        for (Project *p1 in p.childProject) {
            NSLog(@"titlesub: %@", [p1 projectTitle] );
        }
        
    }
    
    for (Project *p in projectCopy.childProject) {
        
        NSLog(@"title: %@", [p projectTitle] );
        
        for (Project *p1 in p.childProject) {
            NSLog(@"titlesub: %@", [p1 projectTitle] );
        }
        
    }*/
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}



- (IBAction)cancelButtonClicked:(id)sender {
    
    if (isNewProject == NO) {
        // cancel changes -> replace current project with previously made copy of project.
        [[parentProjectListViewController mutableArrayValueForKey:@"arrPrj"] replaceObjectAtIndex:[parentProjectListViewController.arrPrj indexOfObject:project] withObject:projectCopy];
        
        // TODO: select another item to avoid crash.
        
        
        
    } else {
        // remove the temporary inserted/created user.
        //[[parentProjectListViewController mutableArrayValueForKey:@"arrPrj"] removeObject:project];
        
        [[parentProjectListViewController prjTreeController] remove:self];
    }
       
    // close this window.
    [self close];
}

- (IBAction)okButtonClicked:(id)sender {
    
    BOOL prjUpdSuc = NO;
    
    // créer un nouveau projet.
    if (isNewProject == YES) {
        
        // user created.
        project.userCreated = mainWindowController.loggedInUser;
        
        
        prjUpdSuc = [PTProjectHelper createProject:project successBlock:^(NSMutableData *data) {
            [self finishedCreatingProject:data];
        } 
                        mainWindowController:parentProjectListViewController];
    }
    // mettre à jour projet existant.
    else {
        
    }
}

// lorsque l'utilisateur clique sur le "x rouge" pour fermer la fenêtre. 
- (void)windowShouldClose:(NSNotification *)notification
{
    
    // annuler les changements.
    [self cancelButtonClicked:self];
}

- (void)finishedCreatingProject:(NSMutableData*)data {
    
}

@end
