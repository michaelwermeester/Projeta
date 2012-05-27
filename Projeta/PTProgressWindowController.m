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
    
    [self initStatusArray];
    
    [self loadProgress];
}

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
}

- (IBAction)sendProgressButtonClicked:(id)sender {
    
    int selectedIndex = [statusComboBox indexOfSelectedItem];
    
    if (selectedIndex > -1) {
    
        //PTStatus *tmp_status = [statusComboBox itemObjectValueAtIndex:selectedIndex];
    
        progress.status = [statusComboBox itemObjectValueAtIndex:selectedIndex];
        
        //NSLog(@"item: %d", [tmp_status.statusId intValue]);
    }
    
    //
    
    BOOL progressUpdSuc = NO;
    
    // donner le focus au bouton 'OK'.
    [self.window makeFirstResponder:sendProgressButton];
    
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
    }
}


- (void)finishedCreatingProgress:(NSMutableData*)data {
    
    
    /*NSError *error;
    
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSMutableArray *createdCommentArray = [[NSMutableArray alloc] init];*/
    
    //NSLog(@"dict: %@", dict);
    
    // see Cocoa and Objective-C up and running by Scott Stevenson.
    // page 242
    //[createdUserArray addObjectsFromArray:[PTUserHelper setAttributesFromDictionary2:dict]];
    /*[createdProjectArray addObjectsFromArray:[PTProjectHelper setAttributesFromJSONDictionary:dict]];*/
    
    
    
    /*[createdCommentArray addObjectsFromArray:[PTCommentHelper setAttributesFromJSONDictionary:dict]];
    
    NSLog(@"count: %lu", [createdCommentArray count]);
    
    if ([createdCommentArray count] == 1) {
        
        for (PTComment *cmt in createdCommentArray) {
            
            // remettre textbox à vide.
            comment.comment = [[NSString alloc] initWithString:@""];
            
            // désactiver bouton pour envoyer commentaire.
            [sendCommentButton setEnabled:NO];
            
            // refresh commentaires.
            [commentWebView reload:self];
        }
    }*/
    
    
    // remettre champs à vide.
    progress.progressComment = [[NSString alloc] initWithString:@""];
    progress.percentageComplete = nil;
    progress.status = nil;
    progress.statusId = nil;
    [statusComboBox setStringValue:@""];
    
    // refresh web view.
    [progressWebView reload:self];
    
    // close this window.
    //[self close];
}

- (void)loadProgress {
    
    // éviter un background blanc.
    //[commentWebView setDrawsBackground:NO];
    
    
    NSString *progressUrlString;
    
    // afficher commentaires pour tâche...
    if (task) {
        if (task.taskId) {
            progressUrlString = [[NSString alloc] initWithString:@"https://luckycode.be:8181/projeta-website/faces/progressCocoa.xhtml?type=task&id="];
            progressUrlString = [progressUrlString stringByAppendingString:[[task taskId] stringValue]];
        }
    } else if (project) {
        if (project.projectId) {
            progressUrlString = [[NSString alloc] initWithString:@"https://luckycode.be:8181/projeta-website/faces/progressCocoa.xhtml?type=project&id="];
            progressUrlString = [progressUrlString stringByAppendingString:[[project projectId] stringValue]];
        }
    }
    
    
    
    // convert to NSURL
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
