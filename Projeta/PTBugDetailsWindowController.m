//
//  PTBugDetailsWindowController.m
//  Projeta
//
//  Created by Michael Wermeester on 01/11/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "MainWindowController.h"
#import "Bug.h"
#import "BugCategory.h"
#import "PTMainWindowViewController.h"
#import "PTBugDetailsWindowController.h"
#import "PTBugHelper.h"
#import "PTBugListViewController.h"
#import "PTUserHelper.h"

Bug *bugCopy;

@implementation PTBugDetailsWindowController

@synthesize bug;

@synthesize isNewBug;

@synthesize arrBugCategory;
@synthesize arrDevelopers;

@synthesize mainWindowController;
@synthesize okButton;
@synthesize comboDevelopers;
@synthesize bugCategoryComboBox;


@synthesize tskTreeIndexPath;
@synthesize prjArrCtrlIndex;

@synthesize parentBugListViewController;

- (id)init
{
    self = [super initWithWindowNibName:@"PTBugDetailsWindow"];
    //self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        arrDevelopers = [[NSMutableArray alloc] init];
        
        arrBugCategory = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)awakeFromNib {
    
    // faire une copie du projet en cours.
    bugCopy = [[Bug alloc] init];
    bugCopy = [bug copy];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    [self initBugCategoryArray];
    
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
    
    if (isNewBug == NO) {
        
        // cancel changes -> replace current bug with previously made copy of bug.
        [[parentBugListViewController mutableArrayValueForKey:@"arrBug"] replaceObjectAtIndex:[parentBugListViewController.arrBug indexOfObject:bug] withObject:bugCopy];
    } else {
        // remove the temporary inserted/created bug.
        [[parentBugListViewController mutableArrayValueForKey:@"arrBug"] removeObject:bug];
    }
       
    // close this window.
    [self close];
}

- (IBAction)okButtonClicked:(id)sender {
    
    BOOL bugUpdSuc = NO;
    
    // donner le focus au bouton 'OK'.
    [self.window makeFirstResponder:okButton];
    
    if ([comboDevelopers indexOfSelectedItem] > -1) {
        User *selectedDev = [arrDevelopers objectAtIndex:[comboDevelopers indexOfSelectedItem]];
    
        bug.userAssigned = selectedDev;
    } else {
        bug.userAssigned = nil;
    }
    
    // créer une nouvelle tâche.
    if (isNewBug == YES) {
        
        // bug created.
        bug.userReported = mainWindowController.loggedInUser;
    
        
        bugUpdSuc = [PTBugHelper createBug:bug successBlock:^(NSMutableData *data) { 
                                    [self finishedCreatingBug:data];
                                }
                                 failureBlock:^() {
                                     
                                 } mainWindowController:parentBugListViewController];
         
    }
    // mettre à jour bogue existant.
    else {
        
        bugUpdSuc = [PTBugHelper updateBug:bug successBlock:^(NSMutableData *data) {
            [self finishedCreatingBug:data];
        } failureBlock:^() {
            
        }
                              mainWindowController:parentBugListViewController];
         
    }
}

- (void)finishedCreatingBug:(NSMutableData*)data {
    
    
    NSError *error;
    
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSMutableArray *createdBugArray = [[NSMutableArray alloc] init];

    
    if ([createdBugArray count] == 1) {

        for (Bug *b in createdBugArray) {
            
            // reassign bug with bug returned from web-service. 
            self.bug = b;
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
            
            if ([u.userId intValue] == [bug.userAssigned.userId intValue]) {

                [comboDevelopers selectItemAtIndex:i];
                break;
            }
        }
        
    }
                failureBlock:^(NSError *error) {
                    
                }];
}



- (void)initBugCategoryArray {
    
    [[self mutableArrayValueForKey:@"arrBugCategory"] addObject:[BugCategory initWithId:[[NSNumber alloc] initWithInt:1] name:@"BLOCKER - Empêche l'utilisation et/ou les tests ; paralyse les travaux."]];
    [[self mutableArrayValueForKey:@"arrBugCategory"] addObject:[BugCategory initWithId:[[NSNumber alloc] initWithInt:2] name:@"CRITICAL - Crashs, pertes de données, graves fuites de mémoire."]];
    [[self mutableArrayValueForKey:@"arrBugCategory"] addObject:[BugCategory initWithId:[[NSNumber alloc] initWithInt:3] name:@"MAJOR - Perte de fonctionnalité majeure."]];
    [[self mutableArrayValueForKey:@"arrBugCategory"] addObject:[BugCategory initWithId:[[NSNumber alloc] initWithInt:7] name:@"MINOR - Perte de fonctionnalité mineure, ou autre problème facilement corrigible."]];
    [[self mutableArrayValueForKey:@"arrBugCategory"] addObject:[BugCategory initWithId:[[NSNumber alloc] initWithInt:9] name:@"TRIVIAL - Problème cosmétique comme une faute d'orthographe, ou un problème d'alignement de texte."]];
}

@end
