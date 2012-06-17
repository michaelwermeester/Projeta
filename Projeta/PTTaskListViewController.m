//
//  PTTaskListViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 06/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "PTTaskListViewController.h"
#import <Foundation/NSJSONSerialization.h>
#import "MainWindowController.h"
#import "MWConnectionController.h"
#import "PTCommentairesWindowController.h"
#import "PTProgressWindowController.h"
#import "PTProjectDetailsViewController.h"
#import "PTCommon.h"
#import "PTTaskDetailsWindowController.h"
#import "PTTaskHelper.h"
#import "Task.h"

@implementation PTTaskListViewController

@synthesize outlineViewProjetColumn;    // colonne 'Projet' de l'outline view.
@synthesize projectButton;              // bouton 'Projet'.
@synthesize checkBoxShowTasksFromSubProjects;   // checkbox 'inclure tâches des sous-projets'.
@synthesize searchField;                // champ de recherche. 

@synthesize arrTask;                    // array qui contient les tâches.
@synthesize taskArrayCtrl;              // array controller pour arrTask. 
@synthesize taskTreeCtrl;               // tree controller pour arrTask.
@synthesize taskOutlineView;            // outline view qui contient les tâches.
@synthesize mainWindowController;       // référence vers le MainWindowController (parent).
@synthesize parentProjectDetailsViewController; // référence vers le PTProjectDetailsViewController (parent).
@synthesize removeTaskButton;
@synthesize addTaskButton;
@synthesize filterButton;

@synthesize minDateFilterDate;
@synthesize maxDateFilterDate;
@synthesize comboStatusFilter;
@synthesize minDateFilter;
@synthesize maxDateFilter;

@synthesize isPersonalTask;             // flag. YES s'il s'agit d'une tâches personnelle.

@synthesize taskURL;                    // optionel. Contient l'URL à utiliser. 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"PTTaskListView" bundle:nibBundleOrNil];
    if (self) {
        
        // Initialiser l'array qui contiendra les tâches.  
        arrTask = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    // get URL du serveur. 
    NSString *urlString = [PTCommon serverURLString];
    // construire l'URL en rajoutant le ressource path. 
    if (isPersonalTask == YES)
        urlString = [urlString stringByAppendingString:@"resources/tasks/personal"];
    else if (taskURL) 
        urlString = [urlString stringByAppendingString:taskURL];
    else
        urlString = [urlString stringByAppendingString:@"resources/tasks/"];
    
    // convertir en NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    // préparer NSURLConnection - MWConnectionController.
    // créer nouvau connection controller afin de pouvoir exécuter la requête.
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {
                                                        [self requestFinished:data];
                                                    }
                                                    failureBlock:^(NSError *error) {
                                                        [self requestFailed:error];
                                                    }];
    
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    // démarrer l'animation du circular progress indicator sur la fenêtre principale. 
    [mainWindowController startProgressIndicatorAnimation];
    
    // exécuter la requête HTTP. 
    [connectionController startRequestForURL:url setRequest:urlRequest];
    
    // désactiver le bouton 'vue projet'.
    [[mainWindowController detailViewToolbarItem] setEnabled:NO];
}

- (void)loadView
{
    [super loadView];
    
    [self viewDidLoad];
}

// MWConnectionController/NSURLConnection - exécuté lorsque l'exécution de la requête HTTP a réussi.
- (void)requestFinished:(NSMutableData*)data
{
    [[self mutableArrayValueForKey:@"arrTask"] removeAllObjects];
    
    NSError *error;
    
    // créer un NSDictionary à partir des données reçus. 
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
    // créer des objets 'Task' à partir du dictionnaire et ajouter ces tâches dans l'array prévu. 
    [[self mutableArrayValueForKey:@"arrTask"] addObjectsFromArray:[PTTaskHelper setAttributesFromJSONDictionary:dict]];
        
    // arrêter l'animation du circular progress indicator sur la fenêtre principale. 
    [mainWindowController stopProgressIndicatorAnimation];
}

// MWConnectionController/NSURLConnection - exécuté lorsque l'exécution de la requête HTTP a échoué. 
- (void)requestFailed:(NSError*)error
{
    // arrêter l'animation du circular progress indicator sur la fenêtre principale. 
    [mainWindowController stopProgressIndicatorAnimation];
}

// insère une nouvelle tâche dans l'array. 
-(void)insertObject:(Task *)p inArrTaskAtIndex:(NSUInteger)index {
    [arrTask insertObject:p atIndex:index];
}

// supprime une tâche de l'array. 
-(void)removeObjectFromArrTaskAtIndex:(NSUInteger)index {
    [arrTask removeObjectAtIndex:index];
}

// nécessaire pour rendre disponible le tri de l'outline view. 
- (void)outlineView:(NSTableView *)outlineView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
    [[self mutableArrayValueForKey:@"arrTask"] sortUsingDescriptors:[outlineView sortDescriptors]];
}

// mettre à jour une tâches existante. 
- (void)updateTask:(Task *)aTask {
    
    BOOL taskUpdSuc = NO;
    
    taskUpdSuc = [PTTaskHelper updateTask:aTask successBlock:^(NSMutableData *data) {
        
    } failureBlock:^() {
        
    }
                     mainWindowController:self];
}

// bouton 'Nouvelle tâche' cliqué.
// ajoute une nouvelle tâche dans l'outline view et ouvre la fenêtre pour encoder les détails. 
- (IBAction)addNewTaskButtonClicked:(id)sender {
    
    NSNumber *parentID; // id de la tâche parente. 
    
    NSArray *selectedObjects = [taskTreeCtrl selectedObjects];
    
    // si un projet est sélectionné...
    if ([selectedObjects count] == 1) {
        
        // instancier une nouvelle tâche.
        Task *tsk = [[Task alloc] init];
        // mettre les dates actuelle.
        tsk.startDate = [NSDate date];
        tsk.endDate = [NSDate date];
        
        tsk.isPersonal = isPersonalTask;
        
        // get parent node.
        NSTreeNode *parent = [[[[taskTreeCtrl selectedNodes] objectAtIndex:0] parentNode] parentNode];
        NSMutableArray *parentTasks = [[parent representedObject] mutableArrayValueForKeyPath:
                                          [taskTreeCtrl childrenKeyPathForNode:parent]];
        
        // get taskId du projet parent. 
        for (Task *p in parentTasks) {
            if ([p.childTask containsObject:[selectedObjects objectAtIndex:0]]) {
                parentID = p.taskId;
                // sortir de la boucle. 
                break;
            }
        }
        
        // s'il y a une tâche parente, mémoriser l'id de celle-ci.
        if (parentID != nil){
            tsk.parentTaskId = parentID;
        }
        
        // id du projet s'il s'agit d'une tâche pour un projet. 
        if (parentProjectDetailsViewController)
            tsk.projectId = parentProjectDetailsViewController.project.projectId;
        
        // indexpath de la tâche sélectionnée.
        NSIndexPath *indexPath = [taskTreeCtrl selectionIndexPath];
        
        // ajouter la tâche dans l'outlineview en passant par le tree controller. 
        if ([indexPath length] > 1) {
            [taskTreeCtrl insertObject:tsk atArrangedObjectIndexPath:indexPath];
        } else {
            // construire nouveau NSIndexPath avec comme valeur 0 -> l'élément sera inséré à la première position.
            // https://discussions.apple.com/thread/1585148?start=0&tstart=0
            NSUInteger indexes[1]={0};
            indexPath=[NSIndexPath indexPathWithIndexes:indexes length:1];
            
            [taskTreeCtrl insertObject:tsk atArrangedObjectIndexPath:indexPath];
        }
    }
    
    // ouvrir fenêtre qui permet à l'utilisateur d'encoder les détails. 
    [self openTaskDetailsWindow:YES isSubTask:NO];
}

// bouton 'Nouvelle sous-tâche' cliqué.
// ajoute une nouvelle sous-tâche dans l'outline view et ouvre la fenêtre pour encoder les détails. 
- (IBAction)addNewSubTaskButtonClicked:(id)sender {
    
    NSNumber *parentID; // id de la tâche parente. 
    
    NSArray *selectedObjects = [taskTreeCtrl selectedObjects];
    
    // si un projet est sélectionné...
    if ([selectedObjects count] == 1) {
        // id de la tâche parente.
        parentID = [[selectedObjects objectAtIndex:0] taskId];
        
        // instancier une nouvelle tâche.
        Task *tsk = [[Task alloc] init];
        // date actuelle.
        tsk.startDate = [NSDate date];
        tsk.endDate = [NSDate date];
        
        tsk.parentTaskId = parentID;
        tsk.isPersonal = isPersonalTask;
        
        // id du projet s'il s'agit d'une tâche pour un projet. 
        if (parentProjectDetailsViewController)
            tsk.projectId = parentProjectDetailsViewController.project.projectId;
        
        // ajouter la tâche dans le tree controller (et dans l'outline view) comme sous-tâche. 
        Task *tmpTask = [selectedObjects objectAtIndex:0]; // tâche sélectionné. 
        
        // si la tâche ne contient pas encore des sous-tâches.
        if ([tmpTask childTask] == nil) {
            
            NSIndexPath *indexPath = [taskTreeCtrl selectionIndexPath];
            
            tmpTask.childTask = [[NSMutableArray alloc] init];
            [taskTreeCtrl insertObject:tsk atArrangedObjectIndexPath:[indexPath indexPathByAddingIndex:0]];
        } else {    // si la tâche contient déjà des sous-tâches.
            NSIndexPath *indexPath = [taskTreeCtrl selectionIndexPath];
            
            [taskTreeCtrl insertObject:tsk atArrangedObjectIndexPath:[indexPath indexPathByAddingIndex:0]];
        } 
    }
    
    // ouvrir fenêtre qui permet à l'utilisateur d'encoder les détails. 
    [self openTaskDetailsWindow:YES isSubTask:YES];
}

// bouton 'Nouvelle sous-tâche' cliqué.
// ouvre une fenêtre avec les détails de la tâche sélectionnée. 
- (IBAction)detailsButtonClicked:(id)sender {
    [self openTaskDetailsWindow:NO isSubTask:NO];
}

// bouton 'Supprimer tâche' cliqué.
// Supprime une tâche de la base de données. 
- (IBAction)removeTaskButtonClicked:(id)sender {
    
    // la tâche sélectionée.
    NSArray *selectedObjects = [taskTreeCtrl selectedObjects];
    
    // supprimer en DB.
    [PTTaskHelper deleteTask:[selectedObjects objectAtIndex:0] successBlock:^(NSMutableData *data){
        // si la tâche a été supprimée en DB, la supprimer aussi visuellement de l'outline view et de l'array lié. 
        [taskTreeCtrl remove:self];
    } failureBlock:^(){ } mainWindowController:mainWindowController];
}

// bouton 'Commentaires' cliqué. 
// Ouvre une fenêtre avec les commentaires. 
- (IBAction)commentButtonClicked:(id)sender {
    
    // instancier nouvelle fenêtre. 
    commentWindowController = [[PTCommentairesWindowController alloc] init];

    // la tâche sélectionnée. 
    NSArray *selectedObjects;
    selectedObjects = [taskTreeCtrl selectedObjects];
    commentWindowController.task = [selectedObjects objectAtIndex:0];
    
    // référence vers mainWindowController. 
    commentWindowController.mainWindowController = mainWindowController;
    
    // ouvrir fenêtre avec commentaires. 
    [commentWindowController showWindow:self];
}

// bouton 'Avancement' cliqué. 
- (IBAction)progressButtonClicked:(id)sender {
    
    // instancier nouvelle fenêtre.
    progressWindowController = [[PTProgressWindowController alloc] init];
    
    // la tâche sélectionnée. 
    NSArray *selectedObjects;
    selectedObjects = [taskTreeCtrl selectedObjects];
    progressWindowController.task = [selectedObjects objectAtIndex:0];
    
    // référence vers mainWindowController. 
    progressWindowController.mainWindowController = mainWindowController;
    
    // initialiser statuts.
    [progressWindowController initStatusArray];
    
    // ouvrir fenêtre. 
    [progressWindowController showWindow:self];
}

// ouvre la fenêtre de détail.
- (void)openTaskDetailsWindow:(BOOL)isNewTask isSubTask:(BOOL)isSubTask {

    NSArray *selectedObjects;
    NSIndexPath *tskTreeIndexPath;

    selectedObjects = [taskTreeCtrl selectedObjects];   // la tâche sélectionnée. 
    tskTreeIndexPath = [taskTreeCtrl selectionIndexPath];   // indexpath de la tâche sélectionnée. 
    
    // si une tâche a été sélectionné, ouvrir la fenêtre avec les détails. 
    if ([selectedObjects count] == 1) {
        
        // instancier fenêtre. 
        taskDetailsWindowController = [[PTTaskDetailsWindowController alloc] init];
        taskDetailsWindowController.parentTaskListViewController = self;
        taskDetailsWindowController.mainWindowController = mainWindowController;
        taskDetailsWindowController.isNewTask = isNewTask;
        taskDetailsWindowController.task = [selectedObjects objectAtIndex:0];
        
        // passer l'indexpath s'il ne s'agit pas d'une nouvelle tâche. 
        if (isNewTask == NO) {
            taskDetailsWindowController.tskTreeIndexPath = tskTreeIndexPath;
        }
        
        // afficher la fenêtre. 
        [taskDetailsWindowController showWindow:self];
    }
}

- (IBAction)filterButtonClicked:(id)sender {
    // donner le focus au bouton 'OK'.
    [self.mainWindowController.window makeFirstResponder:filterButton];
    
    //get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    //urlString = [urlString stringByAppendingString:@"resources/projects/filter"];
    if (isPersonalTask == YES)
        urlString = [urlString stringByAppendingString:@"resources/tasks/personal"];
    else if (taskURL) {
        urlString = [urlString stringByAppendingString:taskURL];
    } else {
        urlString = [urlString stringByAppendingString:@"resources/tasks"];
    }
    
    
    //int selectedFilterStatus = [comboStatusFilter indexOfSelectedItem];
    
    urlString = [urlString stringByAppendingString:@"/?"];
    
    if ([[[comboStatusFilter selectedItem] title] isEqualToString:@"Tous"] == NO) {
        
        NSString *status = @"";
        
        if ([[[comboStatusFilter selectedItem] title] isEqualToString:@"En cours"]) {
            status = [NSString stringWithFormat:@"10"];
        }
        else if ([[[comboStatusFilter selectedItem] title] isEqualToString:@"Attente d'infos"]) {
            status = [NSString stringWithFormat:@"11"];
        }
        else if ([[[comboStatusFilter selectedItem] title] isEqualToString:@"Clôturé"]) {
            status = [NSString stringWithFormat:@"12"];
        }
        else if ([[[comboStatusFilter selectedItem] title] isEqualToString:@"Point zéro"]) {
            status = [NSString stringWithFormat:@"9"];
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
@end
