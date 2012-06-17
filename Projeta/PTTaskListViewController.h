//
//  PTTaskListViewController.h
//  Projeta
//
//  Created by Michael Wermeester on 06/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;
@class PTCommentairesWindowController;
@class PTProgressWindowController;
@class PTProjectDetailsViewController;
@class PTTaskDetailsWindowController;

@interface PTTaskListViewController : NSViewController {
    NSMutableArray *arrTask;            // array qui contient les tâches. 
    NSArrayController *taskArrayCtrl;   // array controller pour arrTask. 
    NSTreeController *taskTreeCtrl;     // tree controller pour arrTask. 
    NSOutlineView *taskOutlineView;     // outline view qui contient les tâches. 
    __weak NSTableColumn *outlineViewProjetColumn;  // colonne 'Projet' de l'outline view. 
    __weak NSButton *projectButton;     // bouton 'Projet'.
    __weak NSButton *checkBoxShowTasksFromSubProjects;  // checkbox 'inclure tâches des sous-projets'.
    __weak NSSearchField *searchField;  // champ de recherche. 
    
    BOOL isPersonalTask;                // flag. YES s'il s'agit d'une tâches personnelle. 
    
    // fenêtre commentaires.
    PTCommentairesWindowController *commentWindowController;
    // fenêtre avec détails de la tâche. 
    PTTaskDetailsWindowController *taskDetailsWindowController;
    // fenêtre avancement.
    PTProgressWindowController *progressWindowController;
    __weak NSButton *removeTaskButton;
    __weak NSPopUpButton *addTaskButton;
    __weak NSButton *filterButton;
}

// propriétés. 
@property (strong) NSMutableArray *arrTask;     // array qui contient les tâches. 
@property (strong) IBOutlet NSArrayController *taskArrayCtrl;   // array controller pour arrTask. 
@property (strong) IBOutlet NSTreeController *taskTreeCtrl;     // tree controller pour arrTask. 
@property (strong) IBOutlet NSOutlineView *taskOutlineView;     // outline view qui contient les tâches.
@property (weak) IBOutlet NSTableColumn *outlineViewProjetColumn;   // colonne 'Projet' de l'outline view. 
@property (weak) IBOutlet NSButton *projectButton;              // bouton 'Projet'.
@property (weak) IBOutlet NSButton *checkBoxShowTasksFromSubProjects;   // checkbox 'inclure tâches des sous-projets'.
@property (weak) IBOutlet NSSearchField *searchField;           // champ de recherche.

@property (assign) BOOL isPersonalTask;         // flag. YES s'il s'agit d'une tâches personnelle.

@property (strong) NSString *taskURL;           // optionel. Contient l'URL à utiliser. 

// référence vers le MainWindowController (parent).
@property (assign) MainWindowController *mainWindowController;

// référence vers le PTProjectDetailsViewController (parent).
@property (assign) PTProjectDetailsViewController *parentProjectDetailsViewController;
@property (weak) IBOutlet NSButton *removeTaskButton;
@property (weak) IBOutlet NSPopUpButton *addTaskButton;
@property (weak) IBOutlet NSButton *filterButton;

@property (weak) IBOutlet NSPopUpButton *comboStatusFilter;
@property (weak) IBOutlet NSTextField *minDateFilter;
@property (weak) IBOutlet NSTextField *maxDateFilter;
@property (nonatomic, retain) NSDate *minDateFilterDate;
@property (nonatomic, retain) NSDate *maxDateFilterDate;

// array qui contient les développeurs/responsables. 
@property (strong) NSMutableArray *arrDevelopers;
// array qui contient les développeurs/responsables. 
@property (strong) NSMutableArray *arrClients;

// nom de la nib file. 
@property (strong) NSString *nibFileName;

// actions.
- (IBAction)commentButtonClicked:(id)sender;    // bouton 'Commentaires' cliqué.
- (IBAction)detailsButtonClicked:(id)sender;    // bouton 'Détails' cliqué.
- (IBAction)addNewSubTaskButtonClicked:(id)sender;  // bouton 'Nouvelle sous-tâche' cliqué.
- (IBAction)addNewTaskButtonClicked:(id)sender; // bouton 'Nouvelle tâche' cliqué.
- (IBAction)progressButtonClicked:(id)sender;   // bouton 'Avancement' cliqué.
- (IBAction)removeTaskButtonClicked:(id)sender; // bouton 'Supprimer tâche' cliqué.
- (IBAction)filterButtonClicked:(id)sender;

// Méthodes qui sont exécutés lors du succès ou échec de connexion (exécution de la requête HTTP). 
- (void)requestFinished:(NSMutableData*)data;
- (void)requestFailed:(NSError*)error;

// ouvre la fenêtre qui permet de :
// - afficher avec les détails d'une tâche. (isNewTask = NO)
// - créer une nouvelle tâche. (isNewTask = YES)
- (void)openTaskDetailsWindow:(BOOL)isNewTask isSubTask:(BOOL)isSubTask;

- (void)viewDidLoad;

- (void)loadTasks;

@end
