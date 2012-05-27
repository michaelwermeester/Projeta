//
//  PTProjectDetailsWindowController.m
//  Projeta
//
//  Created by Michael Wermeester on 01/11/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "MainWindowController.h"
#import "MWCalendarViewController.h"
#import "Project.h"
#import "PTMainWindowViewController.h"
#import "PTProjectDetailsWindowController.h"
#import "PTProjectHelper.h"
#import "PTProjectListViewController.h"
#import "PTUserHelper.h"

Project *projectCopy;

@implementation PTProjectDetailsWindowController

@synthesize project;

@synthesize isNewProject;

@synthesize arrDevelopers;

@synthesize parentProjectListViewController;
@synthesize mainWindowController;
@synthesize okButton;
@synthesize comboDevelopers;


@synthesize prjTreeIndexPath;
@synthesize prjArrCtrlIndex;

@synthesize startDateRealCalendarButton;
@synthesize calendarPopover;
@synthesize endDateRealCalendarButton;
@synthesize startDateCalendarButton;
@synthesize endDateCalendarButton;

- (id)init
{
    self = [super initWithWindowNibName:@"PTProjectDetailsWindow"];
    //self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        arrDevelopers = [[NSMutableArray alloc] init];
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
    
    // charger la liste des développeurs à partir du webservice et les mettre dans la combobox.
    [self fetchDevelopersFromWebservice];
}



- (IBAction)cancelButtonClicked:(id)sender {
    
    if (isNewProject == NO) {
        
        // cancel changes -> replace current project with previously made copy of project.
        //[[parentProjectListViewController mutableArrayValueForKey:@"arrPrj"] replaceObjectAtIndex:[parentProjectListViewController.arrPrj indexOfObject:project] withObject:projectCopy];
        
        // cancel changes -> replace current project with previously made copy of project.
        if (prjTreeIndexPath) {
            
            [parentProjectListViewController.prjTreeController removeObjectAtArrangedObjectIndexPath:prjTreeIndexPath];
        
            [parentProjectListViewController.prjTreeController insertObject:projectCopy atArrangedObjectIndexPath:prjTreeIndexPath];
        }
        else {
            [[parentProjectListViewController mutableArrayValueForKey:@"arrPrj"] replaceObjectAtIndex:[parentProjectListViewController.arrPrj indexOfObject:project] withObject:projectCopy];
            
            // re-sélectionner le projet.
            [parentProjectListViewController.prjArrayCtrl setSelectionIndex:prjArrCtrlIndex];
        }
             
        // TODO: select another item to avoid crash.
        //[parentProjectListViewController.prjTreeController setSelectionIndexPath:prjTreeIndexPath];       
        
    } else {
        // remove the temporary inserted/created user.
        //[[parentProjectListViewController mutableArrayValueForKey:@"arrPrj"] removeObject:project];
        
        [[parentProjectListViewController prjTreeController] remove:self];
        
        //[[parentProjectListViewController mutableArrayValueForKey:@"arrPrj"] removeObjectIdenticalTo:project];
    }
       
    // close this window.
    [self close];
}

- (IBAction)okButtonClicked:(id)sender {
    
    BOOL prjUpdSuc = NO;
    
    // donner le focus au bouton 'OK'.
    [self.window makeFirstResponder:okButton];
    
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
        prjUpdSuc = [PTProjectHelper updateProject:project successBlock:^(NSMutableData *data) {
            [self finishedCreatingProject:data];
        } 
                              mainWindowController:parentProjectListViewController];
    }
}

// lorsque l'utilisateur clique sur le "x rouge" pour fermer la fenêtre. 
- (void)windowShouldClose:(NSNotification *)notification
{
    
    // annuler les changements.
    [self cancelButtonClicked:self];
}

- (void)finishedCreatingProject:(NSMutableData*)data {
    
    
    NSError *error;
    
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSMutableArray *createdProjectArray = [[NSMutableArray alloc] init];
    
    // see Cocoa and Objective-C up and running by Scott Stevenson.
    // page 242
    //[createdUserArray addObjectsFromArray:[PTUserHelper setAttributesFromDictionary2:dict]];
    [createdProjectArray addObjectsFromArray:[PTProjectHelper setAttributesFromJSONDictionary:dict]];
    
    NSLog(@"count: %lu", [createdProjectArray count]);
    
    if ([createdProjectArray count] == 1) {

        for (Project *prj in createdProjectArray) {
   
            
            //[parentProjectListViewController.prjTreeController removeObjectAtArrangedObjectIndexPath:prjTreeIndexPath];
            
            //[parentProjectListViewController.prjTreeController insertObject:prj atArrangedObjectIndexPath:prjTreeIndexPath];

            
            /*if (prj.parentProjectId) {
                [parentProjectListViewController.prjTreeController remove:project];
                
                NSIndexPath *indexPath = [parentProjectListViewController.prjTreeController selectionIndexPath];
                
                [parentProjectListViewController.prjTreeController insertObject:prj atArrangedObjectIndexPath:[indexPath indexPathByAddingIndex:0]];
            
            } else {
                [[parentProjectListViewController mutableArrayValueForKey:@"arrPrj"] replaceObjectAtIndex:[parentProjectListViewController.arrPrj indexOfObject:project] withObject:prj];
            }*/
            
            
            // reassign user with user returned from web-service.
            //self.project = prj;
            //self.project = [prj copy];
            self.project.projectId = [[NSNumber alloc] initWithInt:[prj.projectId intValue]];
            self.project = prj;
            
            //NSLog(@"projectid: %@", self.project.projectId);
            //NSLog(@"projectid: %d", [prj.projectId intValue]);
            
            //NSLog(@"id: %d", [prj.projectId intValue]);
            //NSLog(@"title: %@", prj.projectTitle);
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
        
        
    }
                failureBlock:^(NSError *error) {
                    
                }];
}

// Retourne le titre de la fenêtre.
- (NSString *)windowTitle {
    
    // afficher 'Projet : <nom du projet>'.
    NSString *retVal = [[NSString alloc] initWithString:@"Projet"];
    if (project) {
        if (project.projectTitle) {
            retVal = [retVal stringByAppendingString:@" : "];
            retVal = [retVal stringByAppendingString:project.projectTitle];
        }
    }
    
    // si nouveau projet, afficher 'Nouveau projet'.
    if (isNewProject)
        retVal = [[NSString alloc] initWithString:@"Nouveau projet"];
    
    return retVal;

}


- (IBAction)startDateRealCalendarButtonClicked:(id)sender {
    
    // si bouton clicked...
    if (self.startDateRealCalendarButton.intValue == 1) {
        
        // binder la propriété 'value' du datepicker avec la propriété correspondante de l'objet 'projet'. 
        MWCalendarViewController *calView = (MWCalendarViewController *)calendarPopover.contentViewController;
        [calView.datePicker bind:@"value" toObject:self withKeyPath:@"project.startDateReal" options:nil];
        //[calView.datePicker bind:@"minValue" toObject:self withKeyPath:@"parentProjectStartDate" options:nil];
        //[calView.datePicker bind:@"maxValue" toObject:self withKeyPath:@"parentProjectEndDate" options:nil];
        
        // afficher le popup avec le calendrier.
        [self.calendarPopover showRelativeToRect:[startDateRealCalendarButton bounds]
                                          ofView:startDateRealCalendarButton
                                   preferredEdge:NSMaxYEdge];
    } else {
        [self.calendarPopover close];
    }
    
}

- (IBAction)endDateRealCalendarButtonClicked:(id)sender {
    
    // si bouton clicked...
    if (self.endDateRealCalendarButton.intValue == 1) {
        
        // binder la propriété 'value' du datepicker avec la propriété correspondante de l'objet 'projet'. 
        MWCalendarViewController *calView = (MWCalendarViewController *)calendarPopover.contentViewController;
        [calView.datePicker bind:@"value" toObject:self withKeyPath:@"project.endDateReal" options:nil];
        
        // afficher le popup avec le calendrier.
        [self.calendarPopover showRelativeToRect:[endDateRealCalendarButton bounds]
                                          ofView:endDateRealCalendarButton
                                   preferredEdge:NSMaxYEdge];
    } else {
        [self.calendarPopover close];
    }
}

- (IBAction)startDateCalendarButtonClicked:(id)sender {
    // si bouton clicked...
    if (self.startDateCalendarButton.intValue == 1) {
        
        // binder la propriété 'value' du datepicker avec la propriété correspondante de l'objet 'projet'. 
        MWCalendarViewController *calView = (MWCalendarViewController *)calendarPopover.contentViewController;
        [calView.datePicker bind:@"value" toObject:self withKeyPath:@"project.startDate" options:nil];
        
        // afficher le popup avec le calendrier.
        [self.calendarPopover showRelativeToRect:[startDateCalendarButton bounds]
                                          ofView:startDateCalendarButton
                                   preferredEdge:NSMaxYEdge];
    } else {
        [self.calendarPopover close];
    }
}

- (IBAction)endDateCalendarButtonClicked:(id)sender {
    // si bouton clicked...
    if (self.endDateCalendarButton.intValue == 1) {
        
        // binder la propriété 'value' du datepicker avec la propriété correspondante de l'objet 'projet'. 
        MWCalendarViewController *calView = (MWCalendarViewController *)calendarPopover.contentViewController;
        [calView.datePicker bind:@"value" toObject:self withKeyPath:@"project.endDate" options:nil];
        
        // afficher le popup avec le calendrier.
        [self.calendarPopover showRelativeToRect:[endDateCalendarButton bounds]
                                          ofView:endDateCalendarButton
                                   preferredEdge:NSMaxYEdge];
    } else {
        [self.calendarPopover close];
    }
}

@end
