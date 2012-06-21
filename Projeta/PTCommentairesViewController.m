//
//  PTCommentairesViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 4/8/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "Bug.h"
#import "MainWindowController.h"
#import "MWConnectionController.h"
#import "Project.h"
#import "PTComment.h"
#import "PTCommentairesViewController.h"
#import "PTcommentHelper.h"
#import "PTCommon.h"
#import "Task.h"

@interface PTCommentairesViewController ()

@end

@implementation PTCommentairesViewController

@synthesize bug;
@synthesize comment;
@synthesize project;
@synthesize task;
@synthesize arrComment;
@synthesize commentWebView;
@synthesize commentTextView;
@synthesize mainWindowController;
@synthesize parentProjectDetailsViewController;
@synthesize parentWindowController;
@synthesize sendCommentButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"PTCommentairesView" bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        arrComment = [[NSMutableArray alloc] init];
        
        // instancier nouveau commentaire.
        comment = [[PTComment alloc] init];
    }
    
    return self;
}

- (void)awakeFromNib {
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];  
    [center addObserver:self                                               
               selector:@selector(textDidChange:)
                   name:NSTextDidChangeNotification
                 object:commentTextView];
}

- (void)viewDidLoad {
    
    // charger commentaires.
    [self loadComments];
    
}

- (void)loadView
{
    [super loadView];
    
    [self viewDidLoad];
}

- (void)loadBackground {
    
}

// charger les commentaires.
- (void)loadComments {
    
    NSString *commentUrlString;
    
    // afficher commentaires pour tâche...
    if (task) {
        if (task.taskId) {
            commentUrlString = [[NSString alloc] initWithString:@"https://luckycode.be:8181/projeta-website/faces/commentsCocoa.xhtml?type=task&id="];
            commentUrlString = [commentUrlString stringByAppendingString:[[task taskId] stringValue]];
        }
    } else if (project) {   // afficher commentaires pour projet.
        if (project.projectId) {
            commentUrlString = [[NSString alloc] initWithString:@"https://luckycode.be:8181/projeta-website/faces/commentsCocoa.xhtml?type=project&id="];
            commentUrlString = [commentUrlString stringByAppendingString:[[project projectId] stringValue]];
        }
    } else if (bug) {   // afficher commentaires pour bogue.
        commentUrlString = [[NSString alloc] initWithString:@"https://luckycode.be:8181/projeta-website/faces/commentsCocoa.xhtml?type=bug&id="];
        commentUrlString = [commentUrlString stringByAppendingString:[[bug bugId] stringValue]];
    }
    
    // convertir en NSURL
    NSURL *commentUrl = [NSURL URLWithString:commentUrlString];
    
    NSMutableURLRequest* commentRequest = [NSMutableURLRequest requestWithURL:commentUrl];
    
    // charger et afficher le site web.
    [[commentWebView mainFrame] loadRequest:commentRequest];
}

// bouton 'Envoyer' cliqué.
- (IBAction)sendCommentButtonClicked:(id)sender {
    
    BOOL commentUpdSuc = NO;
    
    // donner le focus au bouton 'OK'.
    if (parentWindowController)
        [parentWindowController.window makeFirstResponder:sendCommentButton];
    else if (mainWindowController)
        [mainWindowController.window makeFirstResponder:sendCommentButton];    
    
    // utilisateur émetteur.
    comment.userCreated = mainWindowController.loggedInUser;
    
    // envoyer le commentaire et l'enregistrer dans la base de données. 
    if (task) {
        commentUpdSuc = [PTCommentHelper createComment:comment forTask:task successBlock:^(NSMutableData *data) { 
            [self finishedCreatingComment:data];
        } failureBlock:^() {
            
        } mainWindowController:mainWindowController];
    }
    else if (project) {
        commentUpdSuc = [PTCommentHelper createComment:comment forProject:project successBlock:^(NSMutableData *data) { 
            [self finishedCreatingComment:data];
        } failureBlock:^() {
            
        } mainWindowController:mainWindowController];
    }
    else if (bug) {
        commentUpdSuc = [PTCommentHelper createComment:comment forBug:bug successBlock:^(NSMutableData *data) { 
            [self finishedCreatingComment:data];
        } failureBlock:^() {
            
        } mainWindowController:mainWindowController];
    }
}

// exécuté lorsque le commentaire a été envoyé. 
- (void)finishedCreatingComment:(NSMutableData*)data {
    
    NSError *error;
    
    // Créer un dictionnaire à partir des données reçus. 
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    // ajouter commentaire reçu dans un array.
    NSMutableArray *createdCommentArray = [[NSMutableArray alloc] init];
    [createdCommentArray addObjectsFromArray:[PTCommentHelper setAttributesFromJSONDictionary:dict]];
    
    
    if ([createdCommentArray count] == 1) {
        
        for (PTComment *cmt in createdCommentArray) {
            
            // remettre textbox à vide.
            comment.comment = [[NSString alloc] initWithString:@""];
            
            // désactiver bouton pour envoyer commentaire.
            [sendCommentButton setEnabled:NO];
            
            // refresh commentaires.
            [commentWebView reload:self];
        }
    }
    
}

// activer/désactiver le bouton 'Envoyer' selon le contenu de la textbox. 
- (void)textDidChange:(NSNotification *)aNotification
{
    // username NSTextField
    if([aNotification object] == commentTextView)
    {
        if ([[commentTextView string] length] > 0) {
            [sendCommentButton setEnabled:YES];
        } else {
            [sendCommentButton setEnabled:NO];
        }
    }
}

// executé quand le WebView vient de terminer le chargement de la page.
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame{
    
    // aller à la fin pour afficher dernier commentaire.
    [commentWebView scrollToEndOfDocument:self];
}

@end
