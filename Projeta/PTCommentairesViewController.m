//
//  PTCommentairesViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 4/8/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "MWConnectionController.h"
#import "PTCommentairesViewController.h"
#import "PTcommentHelper.h"
#import "PTCommon.h"

@interface PTCommentairesViewController ()

@end

@implementation PTCommentairesViewController

@synthesize task;
@synthesize arrComment;
@synthesize commentWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"PTCommentairesView" bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        arrComment = [[NSMutableArray alloc] init];
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
    
    // get server URL as string
    NSString *commentUrlString = [[NSString alloc] initWithString:@"http://www.google.com"];
    // build URL by adding resource path

    
    // convert to NSURL
    NSURL *commentUrl = [NSURL URLWithString:commentUrlString];
    
    NSMutableURLRequest* commentRequest = [NSMutableURLRequest requestWithURL:commentUrl];
    
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

@end
