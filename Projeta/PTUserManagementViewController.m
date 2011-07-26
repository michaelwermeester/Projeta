//
//  PTUsersView.m
//  Projeta
//
//  Created by Michael Wermeester on 04/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import "PTUserManagementViewController.h"
#import "PTUser.h"
#import "User.h"
#import <Foundation/NSJSONSerialization.h>
#import "ConnectionController.h"

@implementation PTUserManagementViewController
@synthesize deleteButton;

@synthesize arrayCtrl;
@synthesize usersTableView;

@synthesize arrUsr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self = [super initWithNibName:@"PTUserManagementView" bundle:nibBundleOrNil];
    
    if (self) {
        // Initialization code here.
        
        arrUsr = [[NSMutableArray alloc] init];
        
        // load user defaults from preferences file
        NSString *urlString = [[NSUserDefaults standardUserDefaults] objectForKey:@"ServerURL"];
        urlString = [urlString stringByAppendingString:@"resources/be.luckycode.projetawebservice.users/"];
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        
        // NSURLConnection - ConnectionController
        id delegate = self;
        ConnectionController* connectionController = [[ConnectionController alloc] initWithDelegate:delegate
                                                                                            selSucceeded:@selector(requestFinished:)
                                                                                               selFailed:@selector(requestFailed:)];
        
        NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
        [urlRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        
        [connectionController startRequestForURL:url setRequest:urlRequest];
        
        
        
        /* When using ASIHTTPRequest - WORKS!!!
        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        
        [request setUseKeychainPersistence:YES];
        [request setAllowCompressedResponse:YES];
        
        __weak ASIHTTPRequest *weakRequest = request;
        //[request setDelegate:self];
        [request setCompletionBlock:^{
            ASIHTTPRequest *strongRequest = weakRequest;
            
            [self requestFinished:strongRequest];
        }];
        [request setFailedBlock:^{
            ASIHTTPRequest *strongRequest = weakRequest;
            
            [self requestFailed:strongRequest];
        }];
        
        [request startAsynchronous];*/
                
        // get users
        //NSURL *url = [NSURL URLWithString:@"https://luckycode.be:8181/projeta-webservice/resources/be.luckycode.projetawebservice.users/"];
        // get user
        //NSURL *url = [NSURL URLWithString:@"https://test:test@luckycode.be:8181/projeta-webservice/resources/be.luckycode.projetawebservice.users/2?"];
        
    }
    
    return self;
}

// ASIHTTPRequest
/*- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error;
    
    // Use when fetching text data
    //NSString *responseString = [request responseString];
    //NSLog(@"response: %@", responseString);
    //NSDictionary *dict = [[NSDictionary alloc] init];
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:&error];
    
    // see Cocoa and Objective-C up and running by Scott Stevenson.
    // page 242
    [[self mutableArrayValueForKey:@"arrUsr"] addObjectsFromArray:[PTUser setAttributesFromDictionary2:dict]];
    
    //[arrayCtrl addObjects:[PTUser setAttributesFromDictionary2:dict]];
    
    // add a new user programmatically
    
    // User *user = [[User alloc] init];
    //user.username = @"teeeeeeeeest";
    //[arrayCtrl addObject:user];
     
}*/

/*- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Failed %@ with code %ld and with userInfo %@",[error domain],[error code],[error userInfo]);
}*/

// NSURLConnection
- (void)requestFinished:(NSMutableData*)data
{
    NSError *error;
    
    // Use when fetching text data
    //NSString *responseString = [request responseString];
    //NSLog(@"response: %@", responseString);
    //NSDictionary *dict = [[NSDictionary alloc] init];
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    // see Cocoa and Objective-C up and running by Scott Stevenson.
    // page 242
    [[self mutableArrayValueForKey:@"arrUsr"] addObjectsFromArray:[PTUser setAttributesFromDictionary2:dict]];
    
    //[arrayCtrl addObjects:[PTUser setAttributesFromDictionary2:dict]];
    
    // add a new user programmatically
    /*
     User *user = [[User alloc] init];
     user.username = @"teeeeeeeeest";
     [arrayCtrl addObject:user];
     */
}

- (void)requestFailed:(NSError*)error
{
    NSLog(@"Failed %@ with code %ld and with userInfo %@",[error domain],[error code],[error userInfo]);
}

- (IBAction)deleteButtonClicked:(NSButton*)sender {
    
    for (User* usr in arrUsr)
    {
        NSLog(@"t: %@", [usr username]);
    }
}
@end
