//
//  PTProgressWindowController.m
//  Projeta
//
//  Created by Michael Wermeester on 4/28/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "Progress.h"
#import "PTProgressHelper.h"
#import "PTProgressWindowController.h"
#import "PTStatus.h"
#import "Project.h"
#import "Task.h"
#import "Bug.h"

@interface PTProgressWindowController ()

@end

@implementation PTProgressWindowController
@synthesize statusComboBox;

@synthesize bug;
@synthesize mainWindowController;
@synthesize progress;
@synthesize progressWebView;
@synthesize sendProgressButton;
@synthesize project;
@synthesize task;

@synthesize arrStatus;

- (id)init
{
    self = [super initWithWindowNibName:@"PTProgressWindow"];
    //self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        
        progress = [[Progress alloc] init];
        arrStatus = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    // populer la dropdownbox avec les différents statuts.
    [self initStatusArray];
    
    // charger les états d'avancement. 
    [self loadProgress];
}

// populer la dropdownbox avec les différents statuts.
- (void)initStatusArray {
    
    if (task) {
        [arrStatus addObject:[PTStatus initWithId:[[NSNumber alloc] initWithInt:9] name:@"Point zéro"]];
        [arrStatus addObject:[PTStatus initWithId:[[NSNumber alloc] initWithInt:10] name:@"En cours"]];
        [arrStatus addObject:[PTStatus initWithId:[[NSNumber alloc] initWithInt:11] name:@"Attente d'infos"]];
        [arrStatus addObject:[PTStatus initWithId:[[NSNumber alloc] initWithInt:12] name:@"Clôturé"]];
    } else if (project) {
        [arrStatus addObject:[PTStatus initWithId:[[NSNumber alloc] initWithInt:1] name:@"Point zéro"]];
        [arrStatus addObject:[PTStatus initWithId:[[NSNumber alloc] initWithInt:2] name:@"En cours"]];
        [arrStatus addObject:[PTStatus initWithId:[[NSNumber alloc] initWithInt:3] name:@"Attente d'infos"]];
        [arrStatus addObject:[PTStatus initWithId:[[NSNumber alloc] initWithInt:4] name:@"Analyse"]];
        [arrStatus addObject:[PTStatus initWithId:[[NSNumber alloc] initWithInt:6] name:@"Demande de mise en production"]];
        [arrStatus addObject:[PTStatus initWithId:[[NSNumber alloc] initWithInt:7] name:@"Mis en production"]];
        [arrStatus addObject:[PTStatus initWithId:[[NSNumber alloc] initWithInt:5] name:@"Clôturé"]];
    }
    else if (bug) {
        [arrStatus addObject:[PTStatus initWithId:[[NSNumber alloc] initWithInt:13] name:@"Rapporté"]];
        [arrStatus addObject:[PTStatus initWithId:[[NSNumber alloc] initWithInt:14] name:@"Corrigé"]];
        [arrStatus addObject:[PTStatus initWithId:[[NSNumber alloc] initWithInt:15] name:@"Attente d'infos"]];
        [arrStatus addObject:[PTStatus initWithId:[[NSNumber alloc] initWithInt:16] name:@"En cours"]];
        [arrStatus addObject:[PTStatus initWithId:[[NSNumber alloc] initWithInt:20] name:@"Won't fix"]];
    }
}

// Clic sur bouton 'Envoyer'. 
- (IBAction)sendProgressButtonClicked:(id)sender {
    
    BOOL progressUpdSuc = NO;
    
    NSInteger selectedIndex = [statusComboBox indexOfSelectedItem];
    
    // statut.
    if (selectedIndex > -1) {
        progress.status = [statusComboBox itemObjectValueAtIndex:selectedIndex];
    }
    
    // donner le focus au bouton 'OK'.
    [self.window makeFirstResponder:sendProgressButton];
    
    // créer l'état d'avanacement dans la base de données. 
    if (task) {
        progressUpdSuc = [PTProgressHelper createProgress:progress forTask:task successBlock:^(NSMutableData *data) { 
            [self finishedCreatingProgress:data];
        } failureBlock:^() {
            
        } mainWindowController:mainWindowController];
    } else if (project) {
        progressUpdSuc = [PTProgressHelper createProgress:progress forProject:project successBlock:^(NSMutableData *data) { 
            [self finishedCreatingProgress:data];
        } failureBlock:^() {
            
        } mainWindowController:mainWindowController];
    } else if (bug) {
    progressUpdSuc = [PTProgressHelper createProgress:progress forBug:bug successBlock:^(NSMutableData *data) { 
        [self finishedCreatingProgress:data];
    } failureBlock:^() {
        
    } mainWindowController:mainWindowController];
}
}

// exécuté lorsque l'état d'avancement a été créé. 
- (void)finishedCreatingProgress:(NSMutableData*)data {    
    
    // remettre champs à vide.
    progress.progressComment = @"";
    progress.percentageComplete = nil;
    progress.status = nil;
    progress.statusId = nil;
    [statusComboBox setStringValue:@""];
    
    // refresh web view.
    [progressWebView reload:self];
}

// charger les états d'avancement. 
- (void)loadProgress {
    
    NSString *progressUrlString;
    
    // afficher commentaires pour tâche...
    if (task) {
        if (task.taskId) {
            progressUrlString = @"https://luckycode.be:8181/projeta-website/faces/progressCocoa.xhtml?type=task&id=";
            progressUrlString = [progressUrlString stringByAppendingString:[[task taskId] stringValue]];
        }
    } else if (project) {   // pour un projet...
        if (project.projectId) {
            progressUrlString = @"https://luckycode.be:8181/projeta-website/faces/progressCocoa.xhtml?type=project&id=";
            progressUrlString = [progressUrlString stringByAppendingString:[[project projectId] stringValue]];
        }
    }
    else if (bug) {   // pour un projet...
        if (bug.bugId) {
            progressUrlString = @"https://luckycode.be:8181/projeta-website/faces/progressCocoa.xhtml?type=bug&id=";
            progressUrlString = [progressUrlString stringByAppendingString:[[bug bugId] stringValue]];
        }
    }
    
    
    // convertir en NSURL
    NSURL *progressUrl = [NSURL URLWithString:progressUrlString];
    
    NSMutableURLRequest* progressRequest = [NSMutableURLRequest requestWithURL:progressUrl];
    
    // charger et afficher le site web.
    [[progressWebView mainFrame] loadRequest:progressRequest];
}

// executé quand le WebView vient de terminer le chargement de la page.
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame{
    
    // aller à la fin pour afficher dernier commentaire.
    [progressWebView scrollToEndOfDocument:self];
}

@end
