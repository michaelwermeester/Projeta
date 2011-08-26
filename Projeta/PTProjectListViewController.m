//
//  PTProjectListViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 26/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "PTProjectListViewController.h"
#import <Foundation/NSJSONSerialization.h>
#import "MWConnectionController.h"
#import "PTCommon.h"
#import "Project.h"
#import "PTProjectHelper.h"

@implementation PTProjectListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self = [super initWithNibName:@"PTProjectListView" bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
        // get server URL as string
        NSString *urlString = [PTCommon serverURLString];
        // build URL by adding resource path
        urlString = [urlString stringByAppendingString:@"resources/be.luckycode.projetawebservice.project/"];
        
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
        [urlRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        
        [connectionController startRequestForURL:url setRequest:urlRequest];
    }
    
    return self;
}

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
    
    //NSLog(@"DESC: %@", [dict description]);
    
    // see Cocoa and Objective-C up and running by Scott Stevenson.
    // page 242
    [[self mutableArrayValueForKey:@"arrPrj"] addObjectsFromArray:[PTProjectHelper setAttributesFromJSONDictionary:dict]];
    
    /*for (Project *p in arrPrj)
    {
        NSLog(@"project: %@", p.projectTitle);
    }
    
    NSLog(@"%lu", [arrPrj count]);*/
    
    //[arrayCtrl addObjects:[PTUser setAttributesFromDictionary2:dict]];
    
    // add a new user programmatically
    /*
     User *user = [[User alloc] init];
     user.username = @"test";
     [arrayCtrl addObject:user];
     */
}

- (void)requestFailed:(NSError*)error
{
    NSLog(@"Failed %@ with code %ld and with userInfo %@",[error domain],[error code],[error userInfo]);
}

@end
