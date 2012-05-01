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
    /*// get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    
    urlString = [urlString stringByAppendingString:@"resources/comments/task/2"];
    
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
    //[mainWindowController startProgressIndicatorAnimation];
    
    [connectionController startRequestForURL:url setRequest:urlRequest];
    */
    
    // charger commentaires.
    [self loadComments];
    
}

- (void)loadView
{
    [super loadView];
    
    [self viewDidLoad];
}

- (void)loadBackground {
    
    
    
    /*NSString* filePath = [[NSBundle mainBundle] pathForResource:@"background" 
                                                         ofType:@"html"];
    NSURL* fileURL = [NSURL fileURLWithPath:filePath];
    NSURLRequest* request = [NSURLRequest requestWithURL:fileURL];
    [[commentWebView mainFrame] loadRequest:request];*/
}

- (void)loadComments {
    
    // éviter un background blanc.
    [commentWebView setDrawsBackground:NO];
    
    
    NSString *commentUrlString;
    
    // afficher commentaires pour tâche...
    if (task) {
        if (task.taskId) {
            commentUrlString = [[NSString alloc] initWithString:@"https://luckycode.be:8181/projeta-website/faces/commentsCocoa.xhtml?type=task&id="];
            commentUrlString = [commentUrlString stringByAppendingString:[[task taskId] stringValue]];
        }
    } else if (project) {
        if (project.projectId) {
            commentUrlString = [[NSString alloc] initWithString:@"https://luckycode.be:8181/projeta-website/faces/commentsCocoa.xhtml?type=project&id="];
            commentUrlString = [commentUrlString stringByAppendingString:[[project projectId] stringValue]];
        }
    }
    
    
    
    // convert to NSURL
    NSURL *commentUrl = [NSURL URLWithString:commentUrlString];
    
    NSMutableURLRequest* commentRequest = [NSMutableURLRequest requestWithURL:commentUrl];
    
    // charger et afficher le site web.
    [[commentWebView mainFrame] loadRequest:commentRequest];
}

/*
// NSURLConnection
- (void)requestFinished:(NSMutableData*)data
{
    // http://stackoverflow.com/questions/5037545/nsurlconnection-and-grand-central-dispatch
    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    NSError *error;
    
    // Use when fetching text data
    //NSString *responseString = [request responseString];
    //NSLog(@"response: %@", responseString);
    //NSDictionary *dict = [[NSDictionary alloc] init];
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    //NSLog(@"DESC: %@", [dict description]);
    
    // see Cocoa and Objective-C up and running by Scott Stevenson.
    // page 242
    
    //});    
    
    
    //dispatch_async(dispatch_get_main_queue(), ^{
    
    [[self mutableArrayValueForKey:@"arrComment"] addObjectsFromArray:[PTCommentHelper setAttributesFromJSONDictionary:dict]];
    
    //NSLog(@"count: %lu", [arrComment count]);
    
    // stop animating the main window's circular progress indicator.
    //[mainWindowController stopProgressIndicatorAnimation];
    //});
    //});
}

- (void)requestFailed:(NSError*)error
{
    // stop animating the main window's circular progress indicator.
    //[mainWindowController stopProgressIndicatorAnimation];
    
    NSLog(@"Failed %@ with code %ld and with userInfo %@",[error domain],[error code],[error userInfo]);
}*/

- (IBAction)sendCommentButtonClicked:(id)sender {
    
    BOOL commentUpdSuc = NO;
    
    // donner le focus au bouton 'OK'.
    if (parentWindowController)
        [parentWindowController.window makeFirstResponder:sendCommentButton];
    else if (mainWindowController)
        [mainWindowController.window makeFirstResponder:sendCommentButton];
    
    // créer une nouvelle tâche.
    
    
    // user created.
    comment.userCreated = mainWindowController.loggedInUser;
    
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
}

- (void)finishedCreatingComment:(NSMutableData*)data {
    
    
    NSError *error;
    
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSMutableArray *createdCommentArray = [[NSMutableArray alloc] init];
    
    //NSLog(@"dict: %@", dict);
    
    // see Cocoa and Objective-C up and running by Scott Stevenson.
    // page 242
    //[createdUserArray addObjectsFromArray:[PTUserHelper setAttributesFromDictionary2:dict]];
    /*[createdProjectArray addObjectsFromArray:[PTProjectHelper setAttributesFromJSONDictionary:dict]];*/
    [createdCommentArray addObjectsFromArray:[PTCommentHelper setAttributesFromJSONDictionary:dict]];
    
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
    }
    
    // close this window.
    //[self close];
}

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

// executé quand le WebView vient de terminer la page.
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame{
    
    // aller à la fin pour afficher dernier commentaire.
    [commentWebView scrollToEndOfDocument:self];
}

@end
