//
//  PTTaskListViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 06/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "PTBugListViewController.h"
#import <Foundation/NSJSONSerialization.h>
#import "Bug.h"
#import "MainWindowController.h"
#import "MWConnectionController.h"
#import "PTBugDetailsWindowController.h"
#import "PTBugHelper.h"
#import "PTCommon.h"
#import "PTProjectDetailsViewController.h"
#import "PTUserHelper.h"
#import "PTClientHelper.h"
#import "PTProgressWindowController.h"
#import "PTCommentairesWindowController.h"

@implementation PTBugListViewController
@synthesize addBugButton;
@synthesize outlineViewProjetColumn;
@synthesize projectButton;
@synthesize removeBugButton;
@synthesize filterButton;

@synthesize arrBug;
@synthesize bugArrayCtrl;
@synthesize bugTreeCtrl;
@synthesize bugOutlineView;
@synthesize mainWindowController;

@synthesize comboStatusFilter;
@synthesize combCategoryFilter;

@synthesize clientComboBox;
@synthesize developerComboBox;

@synthesize bugURL;

// nom de la nib file. 
@synthesize nibFileName;


@synthesize arrClients;
@synthesize arrDevelopers;

@synthesize parentProjectDetailsViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // mémoriser le nom de la nib file. 
    nibFileName = nibNameOrNil;
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
        // Initialize the array which holds the list of task 
        arrBug = [[NSMutableArray alloc] init];
        
        // Initialise l'array qui contient les développeurs/responsables. 
        arrDevelopers = [[NSMutableArray alloc] init];
        
        arrClients = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    // get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    if (bugURL)
        urlString = [urlString stringByAppendingString:bugURL];
    else
        urlString = [urlString stringByAppendingString:@"resources/bugs/"];
    
    // convert to NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    // NSURLConnection - MWConnectionController
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {
                                                        [self requestFinished:data];
                                                    }
                                                    failureBlock:^(NSError *error) {
                                                        [self requestFailed:error];
                                                    }];
    
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    // start animating the main window's circular progress indicator.
    [mainWindowController startProgressIndicatorAnimation];
    
    [connectionController startRequestForURL:url setRequest:urlRequest];
    
    // désactiver le bouton 'vue projet'.
    [[mainWindowController detailViewToolbarItem] setEnabled:NO];
    
    // charger la liste des développeurs si nécessaire. 
    if ([nibFileName isEqualToString:@"PTBugListViewDeveloper"]) {
        [self fetchDevelopersFromWebservice];
    }
    // charger la liste des clients si nécessaire. 
    if ([nibFileName isEqualToString:@"PTBugListViewClient"]) {
        [self fetchClientsFromWebservice];
    }
}

- (void)loadView
{
    [super loadView];
    
    [self viewDidLoad];
}

// NSURLConnection
- (IBAction)addNewBugButtonClicked:(id)sender {
    //NSNumber *parentID;
    
    NSArray *selectedObjects = [bugArrayCtrl selectedObjects];
    
    // if a project is selected, open the window to show its details.
    if ([selectedObjects count] == 1) {
        
        Bug *bug = [[Bug alloc] init];
        
        [bugArrayCtrl insertObject:bug atArrangedObjectIndex:[bugArrayCtrl selectionIndex]];
    } else {
        Bug *bug = [[Bug alloc] init];
        
        [bugArrayCtrl insertObject:bug atArrangedObjectIndex:0];
    }
    
    [self openBugDetailsWindow:YES];
}

- (IBAction)filterButtonClicked:(id)sender {
    // donner le focus au bouton 'OK'.
    [self.mainWindowController.window makeFirstResponder:filterButton];
    
    //get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    //urlString = [urlString stringByAppendingString:@"resources/projects/filter"];
    if (bugURL) {
        urlString = [urlString stringByAppendingString:bugURL];
    } else {
        urlString = [urlString stringByAppendingString:@"resources/bugs"];
    }
    
    
    //int selectedFilterStatus = [comboStatusFilter indexOfSelectedItem];
    if (parentProjectDetailsViewController)
        urlString = [urlString stringByAppendingString:@"&"];
    else
        urlString = [urlString stringByAppendingString:@"/?"];
    
    if ([[[comboStatusFilter selectedItem] title] isEqualToString:@"Tous"] == NO) {
        
        NSString *status = @"";
        
        if ([[[comboStatusFilter selectedItem] title] isEqualToString:@"En cours"]) {
            status = [NSString stringWithFormat:@"16"];
        }
        else if ([[[comboStatusFilter selectedItem] title] isEqualToString:@"Attente d'infos"]) {
            status = [NSString stringWithFormat:@"15"];
        }
        else if ([[[comboStatusFilter selectedItem] title] isEqualToString:@"Won't fix"]) {
            status = [NSString stringWithFormat:@"20"];
        }
        else if ([[[comboStatusFilter selectedItem] title] isEqualToString:@"Corrigé"]) {
            status = [NSString stringWithFormat:@"14"];
        }
        else if ([[[comboStatusFilter selectedItem] title] isEqualToString:@"Rapporté"]) {
            status = [NSString stringWithFormat:@"13"];
        }
        
        urlString = [urlString stringByAppendingString:@"status="];
        urlString = [urlString stringByAppendingString:status];
        urlString = [urlString stringByAppendingString:@"&"];
    }
    
    if ([[[combCategoryFilter selectedItem] title] isEqualToString:@"Tous"] == NO) {
        
        NSString *category = @"";
        
        if ([[[combCategoryFilter selectedItem] title] isEqualToString:@"BLOCKER - Empêche l'utilisation et/ou les tests ; paralyse les travaux."]) {
            category = [NSString stringWithFormat:@"1"];
        }
        else if ([[[combCategoryFilter selectedItem] title] isEqualToString:@"CRITICAL - Crashs, pertes de données, graves fuites de mémoire."]) {
            category = [NSString stringWithFormat:@"2"];
        }
        else if ([[[combCategoryFilter selectedItem] title] isEqualToString:@"MAJOR - Perte de fonctionnalité majeure."]) {
            category = [NSString stringWithFormat:@"3"];
        }
        else if ([[[combCategoryFilter selectedItem] title] isEqualToString:@"MINOR - Perte de fonctionnalité mineure, ou autre problème facilement corrigible."]) {
            category = [NSString stringWithFormat:@"7"];
        }
        else if ([[[combCategoryFilter selectedItem] title] isEqualToString:@"TRIVIAL - Problème cosmétique comme une faute d'orthographe, ou un problème d'alignement de texte."]) {
            category = [NSString stringWithFormat:@"9"];
        }
        
        urlString = [urlString stringByAppendingString:@"category="];
        urlString = [urlString stringByAppendingString:category];
        urlString = [urlString stringByAppendingString:@"&"];
    }
    
    if (clientComboBox) {
        
        if ([clientComboBox indexOfSelectedItem] > -1) {
            Client *selectedClient = [arrClients objectAtIndex:[clientComboBox indexOfSelectedItem]];
            
            NSString *clientId = [[selectedClient clientId] stringValue];
            
            urlString = [urlString stringByAppendingString:@"clientId='"];
            urlString = [urlString stringByAppendingString:clientId];
            urlString = [urlString stringByAppendingString:@"'&"];
        }
    }
    
    if (developerComboBox) {
        
        if ([developerComboBox indexOfSelectedItem] > -1) {
            User *selectedDev = [arrDevelopers objectAtIndex:[developerComboBox indexOfSelectedItem]];
            
            NSString *devId = [[selectedDev userId] stringValue];
            
            urlString = [urlString stringByAppendingString:@"devId='"];
            urlString = [urlString stringByAppendingString:devId];
            urlString = [urlString stringByAppendingString:@"'&"];
        }
    }
    
    // convertir en NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSLog(@"urlstring: %@" ,urlString);
    
    // NSURLConnection - MWConnectionController
    // instantier et passer les blocks avec les méthodes à exécuter. 
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {
                                                        [self requestFinished:data];
                                                    }
                                                    failureBlock:^(NSError *error) {
                                                        [self requestFailed:error];
                                                    }];
    
    // créer l'URLRequest à partir de l'URL. 
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    // lancer la requête. 
    [connectionController startRequestForURL:url setRequest:urlRequest];
}

- (void)requestFinished:(NSMutableData*)data
{
    [[self mutableArrayValueForKey:@"arrBug"] removeAllObjects];
    
    NSError *error;

    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
    NSLog(@"fuckdict: %@", dict);
    
    [[self mutableArrayValueForKey:@"arrBug"] addObjectsFromArray:[PTBugHelper setAttributesFromJSONDictionary:dict]];
        
    // stop animating the main window's circular progress indicator.
    [mainWindowController stopProgressIndicatorAnimation];
}

- (void)requestFailed:(NSError*)error
{
    // stop animating the main window's circular progress indicator.
    [mainWindowController stopProgressIndicatorAnimation];
}

-(void)insertObject:(Project *)p inArrBugAtIndex:(NSUInteger)index {
    [arrBug insertObject:p atIndex:index];
}

-(void)removeObjectFromArrBugAtIndex:(NSUInteger)index {
    [arrBug removeObjectAtIndex:index];
}

- (void)outlineView:(NSTableView *)outlineView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
    [[self mutableArrayValueForKey:@"arrBug"] sortUsingDescriptors:[outlineView sortDescriptors]];
}

- (IBAction)detailsButtonClicked:(id)sender {
    [self openBugDetailsWindow:NO];
}

// update user when finished editing cell in table view
- (void)editingDidEnd:(NSNotification *)notification
{
    // continue and update the user only if the object is the usersTableView
    if ([notification object] == bugOutlineView) {
        
        //NSArray *selectedObjects = [bugArrayCtrl selectedObjects];
    }
}

- (void)openBugDetailsWindow:(BOOL)isNewBug {
    // get selected bugs.
    NSArray *selectedObjects;
    selectedObjects = [bugArrayCtrl selectedObjects];
    
    // si un bogue a été sélectionné. 
    if ([selectedObjects count] == 1) {
        bugDetailsWindowController = [[PTBugDetailsWindowController alloc] init];
        bugDetailsWindowController.parentBugListViewController = self;
        bugDetailsWindowController.mainWindowController = mainWindowController;
        bugDetailsWindowController.isNewBug = isNewBug;
        bugDetailsWindowController.bug = [selectedObjects objectAtIndex:0];
        bugDetailsWindowController.bug.project = [parentProjectDetailsViewController project];
        
        [bugDetailsWindowController showWindow:self];
    }
}

// charger la liste des développeurs à partir du webservice et les mettre dans la combobox.
- (void)fetchClientsFromWebservice
{
    // get developers from webservice.
    [PTClientHelper getClientNames:^(NSMutableArray *clients) {
        
        //[[self mutableArrayValueForKey:@"arrClients"] addObjectsFromArray:clients];
        
        // descripteurs de tri pour l'array.
        NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"clientName"
                                                                        ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
        
        // trier l'array et affecter les responsables/développeurs à l'array.
        [[self mutableArrayValueForKey:@"arrClients"] addObjectsFromArray:[clients sortedArrayUsingDescriptors:sortDescriptors]];
        
    }
                      failureBlock:^(NSError *error) {
                          
                      }];
}

// charger la liste des développeurs à partir du webservice et les mettre dans la combobox.
- (void)fetchDevelopersFromWebservice
{
    // get developers from webservice.
    [PTUserHelper developers:^(NSMutableArray *developers) {
        
        // descripteurs de tri pour l'array.
        NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fullNameAndUsername"
                                                                        ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
        
        // trier l'array et affecter les responsables/développeurs à l'array.
        [[self mutableArrayValueForKey:@"arrDevelopers"] addObjectsFromArray:[developers sortedArrayUsingDescriptors:sortDescriptors]];
        
    }
                failureBlock:^(NSError *error) {
                    
                }];
}


- (void)loadBugs {
    // get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    if (bugURL)
        urlString = [urlString stringByAppendingString:bugURL];
    else
        urlString = [urlString stringByAppendingString:@"resources/bugs/"];
    
    // convert to NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    // NSURLConnection - MWConnectionController
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {
                                                        [self requestFinished:data];
                                                    }
                                                    failureBlock:^(NSError *error) {
                                                        [self requestFailed:error];
                                                    }];
    
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    // start animating the main window's circular progress indicator.
    [mainWindowController startProgressIndicatorAnimation];
    
    [connectionController startRequestForURL:url setRequest:urlRequest];
    
}

- (IBAction)progressButtonClicked:(id)sender {
    // instancier nouvelle fenêtre.
    progressWindowController = [[PTProgressWindowController alloc] init];
    
    // la tâche sélectionnée. 
    NSArray *selectedObjects;
    selectedObjects = [bugArrayCtrl selectedObjects];
    progressWindowController.bug = [selectedObjects objectAtIndex:0];
    
    // référence vers mainWindowController. 
    progressWindowController.mainWindowController = mainWindowController;
    
    // initialiser statuts.
    [progressWindowController initStatusArray];
    
    // ouvrir fenêtre. 
    [progressWindowController showWindow:self];
}

- (IBAction)commentButtonClicked:(id)sender {
    // instancier nouvelle fenêtre. 
    commentWindowController = [[PTCommentairesWindowController alloc] init];
    
    // la tâche sélectionnée. 
    NSArray *selectedObjects;
    selectedObjects = [bugArrayCtrl selectedObjects];
    commentWindowController.bug = [selectedObjects objectAtIndex:0];
    
    // référence vers mainWindowController. 
    commentWindowController.mainWindowController = mainWindowController;
    
    // ouvrir fenêtre avec commentaires. 
    [commentWindowController showWindow:self];
}
@end
