//
//  PTProjectListViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 26/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "PTProjectListViewController.h"
#import <Foundation/NSJSONSerialization.h>
#import "MainWindowController.h"
#import "MWConnectionController.h"
#import "PTCommon.h"
#import "Project.h"
#import "PTProgressWindowController.h"
#import "PTProjectHelper.h"
#import "PTProjectDetailsWindowController.h"
#import "PTCommentairesWindowController.h"
#import "PTUserHelper.h"

PTCommentairesWindowController *commentWindowController;

@implementation PTProjectListViewController

// array qui contient les projets.
@synthesize arrPrj; 
// array qui contient les développeurs/responsables. 
@synthesize arrDevelopers;
@synthesize mainWindowController;
@synthesize prjTabView;
@synthesize prjOutlineView;
@synthesize addSubProjectButton;
@synthesize clientComboBox;
@synthesize prjTreeController;
@synthesize prjArrayCtrl;
@synthesize prjCollectionView;

// nom de la nib file. 
@synthesize nibFileName;

// URL à utiliser.
@synthesize projectURL;
@synthesize comboStatusFilter;
@synthesize minDateFilter;
@synthesize maxDateFilter;
@synthesize filterButton;

@synthesize minDateFilterDate;
@synthesize maxDateFilterDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // mémoriser le nom de la nib file. 
    nibFileName = nibNameOrNil;
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Initialise l'array qui contient les projets. 
        arrPrj = [[NSMutableArray alloc] init];
        
        // Initialise l'array qui contient les développeurs/responsables. 
        arrDevelopers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    // get URL du serveur. 
    NSString *urlString = [PTCommon serverURLString];
    // construire l'URL en rajoutant le ressource path.
    if (projectURL) {
        urlString = [urlString stringByAppendingString:projectURL];
    } else {
        urlString = [urlString stringByAppendingString:@"resources/projects/"];
    }
    
    // charger la liste des développeurs/responsables si nécessaire. 
    if ([nibFileName isEqualToString:@"PTProjectListViewDeveloper"]) {
        [self fetchDevelopersFromWebservice];
    }
    
    
    if ([nibFileName isEqualToString:@"PTProjectListViewAssigned"] || [nibFileName isEqualToString:@"PTProjectListViewDeveloper"]) {
        // Hide tree view tab. 
        NSTabViewItem *activityTab = [prjTabView tabViewItemAtIndex:1];
        [prjTabView removeTabViewItem:activityTab];
    }

    // convertir en NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
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
    
    // démarrer l'animation du circular progress indicator sur la fenêtre principale. 
    [mainWindowController startProgressIndicatorAnimation];
    
    // lancer la requête. 
    [connectionController startRequestForURL:url setRequest:urlRequest];
    
    // set label of 'detail view' toolbar item to 'Project view'.
    [[mainWindowController detailViewToolbarItem] setLabel:NSLocalizedString(@"Vue projet", nil)];
    
    // désactiver le bouton 'vue projet'.
    [[mainWindowController detailViewToolbarItem] setEnabled:YES];
    
    // binder le champ de recherche de la fenêtre principale à l'arraycontroller.
    [[mainWindowController searchField] bind:@"predicate" toObject:prjArrayCtrl withKeyPath:@"filterPredicate" options:
     [NSDictionary dictionaryWithObjectsAndKeys:
      @"predicate", NSDisplayNameBindingOption,
      @"projectTitle contains[cd] $value",
      NSPredicateFormatBindingOption,
      nil]];
    
    // désactiver le point de menu pour créer un sous-projet si le premier onglet est l'onglet actif.
    [self tabView:prjTabView didSelectTabViewItem:[prjTabView tabViewItemAtIndex:0]];
}

- (void)loadView
{
    [super loadView];
    
    [self viewDidLoad];
}

// NSURLConnection
- (void)requestFinished:(NSMutableData*)data
{
    [[self mutableArrayValueForKey:@"arrPrj"] removeAllObjects];
    
    NSError *error;
    
    // Lire les données JSON reçues dans un nouveau dictionnaire. 
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    // Créer un array d'objets Projet à partir du dictionnaire et les assigner au array arrPrj.
    [[self mutableArrayValueForKey:@"arrPrj"] addObjectsFromArray:[PTProjectHelper setAttributesFromJSONDictionary:dict]];
    
    // arrêter l'animation du circular progress indicator sur la fenêtre principale.
    [mainWindowController stopProgressIndicatorAnimation];
}

- (void)requestFailed:(NSError*)error
{
    // arrêter l'animation du circular progress indicator sur la fenêtre principale. 
    [mainWindowController stopProgressIndicatorAnimation];
}

// Bouton 'ajouter un projet' cliqué...
- (IBAction)addNewProjectButtonClicked:(id)sender {
    
    // id du projet parent. 
    NSNumber *parentID;
    
    // le projet sélectionné
    NSArray *selectedObjects = [prjTreeController selectedObjects];
    
    // si un projet a été sélectionné...
    if ([selectedObjects count] == 1) {
        // instancier nouveau projet. 
        Project *prj = [[Project alloc] init];
        // date actuelle. 
        prj.startDate = [NSDate date];
        prj.endDate = [NSDate date];
        
        // get parent node.
        NSTreeNode *parent = [[[[prjTreeController selectedNodes] objectAtIndex:0] parentNode] parentNode];
        NSMutableArray *parentProjects = [[parent representedObject] mutableArrayValueForKeyPath:
                                   [prjTreeController childrenKeyPathForNode:parent]];
        
        // get projectid du projet parent. 
        for (Project *p in parentProjects)
        {
            if ([p.childProject containsObject:[selectedObjects objectAtIndex:0]])
            {
                parentID = p.projectId;
                break;
            }
        }

        // s'il y a un projet parent, mémoriser son id.
        if (parentID != nil){
            prj.parentProjectId = parentID;
        }
        
        // indexpath du projet sélectionnée.
        NSIndexPath *indexPath = [prjTreeController selectionIndexPath];
        
        // ajouter le projet dans l'outlineview en passant par le tree controller.
        if ([indexPath length] > 1) {
            [prjTreeController insertObject:prj atArrangedObjectIndexPath:indexPath];
        } else {
            // construire nouveau NSIndexPath avec comme valeur 0 -> l'élément sera inséré à la première position.
            // https://discussions.apple.com/thread/1585148?start=0&tstart=0
            NSUInteger indexes[1]={0};
            indexPath=[NSIndexPath indexPathWithIndexes:indexes length:1];
            
            [prjTreeController insertObject:prj atArrangedObjectIndexPath:indexPath];
        }
    }

    // ouvrir fenêtre qui permet à l'utilisateur d'encoder les détails.
    [self openProjectDetailsWindow:YES isSubProject:NO];
}

// bouton 'Nouveau sous-projet' cliqué.
// ajoute un nouveau sous-projet dans l'outline view et ouvre la fenêtre pour encoder les détails. 
- (IBAction)addNewSubProjectButtonClicked:(id)sender {
    
    // id du projet parent. 
    NSNumber *parentID;
    
    // le projet sélectionné
    NSArray *selectedObjects = [prjTreeController selectedObjects];
    
    // si un projet a été sélectionné...
    if ([selectedObjects count] == 1) {
        // id du projet parent. 
        parentID = [[selectedObjects objectAtIndex:0] projectId];
        
        // instancier nouveau projet.
        Project *prj = [[Project alloc] init];
        // date actuelle.
        prj.startDate = [NSDate date];
        prj.endDate = [NSDate date];
        
        prj.parentProjectId = parentID;
        
        // ajouter le projet dans le tree controller (et dans l'outline view) comme sous-projet. 
        Project *tmpPrj = [selectedObjects objectAtIndex:0];  // projet sélectionné
        
        // si le projet ne contient pas encore des sous-projets.
        if ([tmpPrj childProject] == nil) {
            
            NSIndexPath *indexPath = [prjTreeController selectionIndexPath];
            
            tmpPrj.childProject = [[NSMutableArray alloc] init];
            [prjTreeController insertObject:prj atArrangedObjectIndexPath:[indexPath indexPathByAddingIndex:0]];
        } else {
            //else if ([[tmpPrj childProject] count] > 0) {
            
            NSIndexPath *indexPath = [prjTreeController selectionIndexPath];
            
            [prjTreeController insertObject:prj atArrangedObjectIndexPath:[indexPath indexPathByAddingIndex:0]];
        } 
    }
    
    // ouvrir fenêtre qui permet à l'utilisateur d'encoder les détails.
    [self openProjectDetailsWindow:YES isSubProject:YES];
}

// bouton 'Nouveau sous-projet' cliqué.
// ouvre une fenêtre avec les détails du projet sélectionnée. 
- (IBAction)detailsButtonClicked:(id)sender {
    
    [self openProjectDetailsWindow:NO isSubProject:NO];
}

// bouton 'Supprimer projet' cliqué.
// Supprime un projet de la base de données. 
- (IBAction)removeProjectButtonClicked:(id)sender {
    
    // index du tab actuel.
    int selectedTabIndex = [prjTabView indexOfTabViewItem:[prjTabView selectedTabViewItem]];
    
    NSArray *selectedObjects;
    
    if (selectedTabIndex == 1) {
        selectedObjects = [prjTreeController selectedObjects];
    } else if (selectedTabIndex == 0) {
        selectedObjects = [prjArrayCtrl selectedObjects];
    }
    
    // supprimer en DB.
    [PTProjectHelper deleteProject:[selectedObjects objectAtIndex:0] successBlock:^(NSMutableData *data){
        
        // si la tâche a été supprimée en DB, la supprimer aussi visuellement de l'outline view et de l'array lié. 
        if (selectedTabIndex == 1) {
            [prjTreeController remove:self];
        } else if (selectedTabIndex == 0) {
            [prjArrayCtrl remove:self];
        }
    } failureBlock:^(){
        
    } mainWindowController:mainWindowController];
}

// passer en 'vue projet'.
- (IBAction)switchToProjectViewButtonClicked:(id)sender {
    [mainWindowController switchToProjectView:sender];
}

// bouton 'Avancement' cliqué. 
- (IBAction)progressButtonClicked:(id)sender {
    // instancier nouvelle fenêtre.
    progressWindowController = [[PTProgressWindowController alloc] init];
    
    // le projet sélectionnée. 
    NSArray *selectedObjects;
    selectedObjects = [prjTreeController selectedObjects];
    progressWindowController.project = [selectedObjects objectAtIndex:0];
    
    // référence vers mainWindowController. 
    progressWindowController.mainWindowController = mainWindowController;
    
    // initialiser statuts.
    [progressWindowController initStatusArray];
    
    // ouvrir fenêtre.
    [progressWindowController showWindow:self];
}

// bouton 'Commentaires' cliqué. 
// Ouvre une fenêtre avec les commentaires.
- (IBAction)commentButtonClicked:(id)sender {
    // instancier nouvelle fenêtre. 
    commentWindowController = [[PTCommentairesWindowController alloc] init];
    
    // le projet sélectionnée.
    NSArray *selectedObjects;
    selectedObjects = [prjTreeController selectedObjects];
    commentWindowController.project = [selectedObjects objectAtIndex:0];
    
    // référence vers mainWindowController. 
    commentWindowController.mainWindowController = mainWindowController;
    
    // ouvrir fenêtre avec commentaires.
    [commentWindowController showWindow:self];
}

- (IBAction)filterButtonClicked:(id)sender {
    
    // donner le focus au bouton 'OK'.
    [self.mainWindowController.window makeFirstResponder:filterButton];
    
    //get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    //urlString = [urlString stringByAppendingString:@"resources/projects/filter"];
    if (projectURL) {
        urlString = [urlString stringByAppendingString:projectURL];
    } else {
        urlString = [urlString stringByAppendingString:@"resources/projects/filter"];
    }
    
    
    //int selectedFilterStatus = [comboStatusFilter indexOfSelectedItem];
    
    urlString = [urlString stringByAppendingString:@"/?"];
    
    if ([[[comboStatusFilter selectedItem] title] isEqualToString:@"Tous"] == NO) {
        
        NSString *status = @"";
        
        if ([[[comboStatusFilter selectedItem] title] isEqualToString:@"En cours"]) {
            status = [NSString stringWithFormat:@"2"];
        }
        else if ([[[comboStatusFilter selectedItem] title] isEqualToString:@"Mis en production"]) {
            status = [NSString stringWithFormat:@"7"];
        }
        else if ([[[comboStatusFilter selectedItem] title] isEqualToString:@"Clôturé"]) {
            status = [NSString stringWithFormat:@"5"];
        }
        else if ([[[comboStatusFilter selectedItem] title] isEqualToString:@"Point zéro"]) {
            status = [NSString stringWithFormat:@"1"];
        }
        else if ([[[comboStatusFilter selectedItem] title] isEqualToString:@"Attente d'infos"]) {
            status = [NSString stringWithFormat:@"3"];
        }
        else if ([[[comboStatusFilter selectedItem] title] isEqualToString:@"Analyse"]) {
            status = [NSString stringWithFormat:@"4"];
        }
        else if ([[[comboStatusFilter selectedItem] title] isEqualToString:@"Demande de mise en production"]) {
            status = [NSString stringWithFormat:@"6"];
        }
        
        urlString = [urlString stringByAppendingString:@"status="];
        urlString = [urlString stringByAppendingString:status];
        urlString = [urlString stringByAppendingString:@"&"];
    }
    
    // min date filter.
    if ([[minDateFilter stringValue] length] > 0) {
        urlString = [urlString stringByAppendingString:@"minDate='"];
        urlString = [urlString stringByAppendingString:[PTCommon stringJSONFromDate:minDateFilterDate]];
        urlString = [urlString stringByAppendingString:@"'&"];
        //NSLog(@"date: %@", [PTCommon stringJSONFromDate:minDateFilterDate]);
    }
    
    // max date filter.
    if ([[maxDateFilter stringValue] length] > 0) {
        urlString = [urlString stringByAppendingString:@"maxDate='"];
        urlString = [urlString stringByAppendingString:[PTCommon stringJSONFromDate:maxDateFilterDate]];
        urlString = [urlString stringByAppendingString:@"'&"];
        //NSLog(@"date: %@", [PTCommon stringJSONFromDate:maxDateFilterDate]);
    }
    
    // convertir en NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    //NSLog(@"urlstring: %@" ,urlString);
    
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

// insère un nouveau projet dans l'array. 
-(void)insertObject:(Project *)p inArrPrjAtIndex:(NSUInteger)index {
    [arrPrj insertObject:p atIndex:index];
}

// supprime un projet de l'array. 
-(void)removeObjectFromArrPrjAtIndex:(NSUInteger)index {
    [arrPrj removeObjectAtIndex:index];
}

-(void)setArrPrj:(NSMutableArray *)a {
    arrPrj = a;
}

-(NSArray *)arrPrj {
    return arrPrj;
}

// ouvre la fenêtre de détail.
- (void)openProjectDetailsWindow:(BOOL)isNewProject isSubProject:(BOOL)isSubProject {    
    
    // l'onglet en cours. 
    int selectedTabIndex = [prjTabView indexOfTabViewItem:[prjTabView selectedTabViewItem]];
    
    NSArray *selectedObjects;
    NSIndexPath *prjTreeIndexPath;
    NSUInteger prjArrCtrlIndex;
    
    // le projet sélectionné et son indexpath.
    if (selectedTabIndex == 1) {
        selectedObjects = [prjTreeController selectedObjects];
        
        prjTreeIndexPath = [prjTreeController selectionIndexPath];
    } else {
        selectedObjects = [prjArrayCtrl selectedObjects];
        
        prjArrCtrlIndex = [prjArrayCtrl selectionIndex];
    }
    
    // si un projet a été sélectionné, ouvrir la fenêtre avec les détails. 
    if ([selectedObjects count] == 1) {
        
        // instancier fenêtre.
        projectDetailsWindowController = [[PTProjectDetailsWindowController alloc] init];
        projectDetailsWindowController.parentProjectListViewController = self;
        projectDetailsWindowController.mainWindowController = mainWindowController;
        projectDetailsWindowController.isNewProject = isNewProject;
        projectDetailsWindowController.project = [selectedObjects objectAtIndex:0];
        
        // passer l'indexpath s'il ne s'agit pas d'un nouveau projet.
        if (isNewProject == NO) {
            projectDetailsWindowController.prjTreeIndexPath = prjTreeIndexPath;
            projectDetailsWindowController.prjArrCtrlIndex = prjArrCtrlIndex;
        } 
        
        // afficher la fenêtre. 
        [projectDetailsWindowController showWindow:self];
    }
}

-(void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
    
    // désactiver la menu pour rajouter un sous-projet si le premier onglet est l'onglet actif.
    int selectedTabIndex = [tabView indexOfTabViewItem:tabViewItem];
    
    if (selectedTabIndex == 0) {
        [addSubProjectButton setEnabled:NO];
    } else {
        [addSubProjectButton setEnabled:YES];
    }
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


@end
