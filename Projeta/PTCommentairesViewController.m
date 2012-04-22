//
//  PTCommentairesViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 4/8/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "MainWindowController.h"
#import "MWConnectionController.h"
#import "PTComment.h"
#import "PTCommentairesViewController.h"
#import "PTcommentHelper.h"
#import "PTCommon.h"
#import "Task.h"

@interface PTCommentairesViewController ()

@end

@implementation PTCommentairesViewController

@synthesize comment;
@synthesize task;
@synthesize arrComment;
@synthesize commentWebView;
@synthesize commentTextView;
@synthesize mainWindowController;
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
    
    NSString *commentUrlString;
    
    // afficher commentaires pour tâche...
    if (task) {
        if (task.taskId) {
            commentUrlString = [[NSString alloc] initWithString:@"http://luckycode.be:8080/projeta-website/faces/commentsCocoa.xhtml?type=task&id="];
            commentUrlString = [commentUrlString stringByAppendingString:[[task taskId] stringValue]];
        }
    }

    
    // convert to NSURL
    NSURL *commentUrl = [NSURL URLWithString:commentUrlString];
    
    NSMutableURLRequest* commentRequest = [NSMutableURLRequest requestWithURL:commentUrl];
    
    // charger et afficher le site web.
    [[commentWebView mainFrame] loadRequest:commentRequest];
}

- (void)loadView
{
    [super loadView];
    
    [self viewDidLoad];
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
    [parentWindowController.window makeFirstResponder:sendCommentButton];
    
    // créer une nouvelle tâche.

    
    // user created.
    comment.userCreated = mainWindowController.loggedInUser;
        
    commentUpdSuc = [PTCommentHelper createComment:comment forTask:task successBlock:^(NSMutableData *data) { 
            [self finishedCreatingComment:data];
        } failureBlock:^() {
                                     
        } mainWindowController:mainWindowController];
}

- (void)finishedCreatingComment:(NSMutableData*)data {
    
    
    NSError *error;
    
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSMutableArray *createdCommentArray = [[NSMutableArray alloc] init];
    
    // see Cocoa and Objective-C up and running by Scott Stevenson.
    // page 242
    //[createdUserArray addObjectsFromArray:[PTUserHelper setAttributesFromDictionary2:dict]];
    /*[createdProjectArray addObjectsFromArray:[PTProjectHelper setAttributesFromJSONDictionary:dict]];*/
    
    NSLog(@"count: %lu", [createdCommentArray count]);
    
    if ([createdCommentArray count] == 1) {
        
        for (PTComment *cmt in createdCommentArray) {
            
            
            
            // reassign user with user returned from web-service. 
            //self.task = tsk;
            
            //NSLog(@"id: %d", [prj.projectId intValue]);
            //NSLog(@"title: %@", prj.projectTitle);
        }
    }
    
    // close this window.
    //[self close];
}

@end
