//
//  PTUsersView.m
//  Projeta
//
//  Created by Michael Wermeester on 04/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import "PTUserManagementViewController.h"
#import "ASIHTTPRequest.h"
#import "PTUser.h"
#import "User.h"
#import <Foundation/NSJSONSerialization.h>

@implementation PTUserManagementViewController

@synthesize arrUsr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self = [super initWithNibName:@"PTUserManagementView" bundle:nibBundleOrNil];
    /*if (self) {
        // Initialization code here.
        
        // get users
        //NSURL *url = [NSURL URLWithString:@"https://test:test@luckycode.be:8181/projeta-webservice/resources/be.luckycode.projetawebservice.users/"];
        // get user
        NSURL *url = [NSURL URLWithString:@"https://test:test@luckycode.be:8181/projeta-webservice/resources/be.luckycode.projetawebservice.users/2?"];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request startSynchronous];
        NSError *error = [request error];
        NSError *err;
        if (!error) {
            NSString *response = [request responseString];
            //User *usr = [[User alloc] init];
            NSDictionary *dict = [[NSDictionary alloc] init];
            dict = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:&err];
            NSLog(@"response: %@", response);
            
            //NSLog(@"test: %@", usr.username);
            NSLog(@"test: %@", [dict valueForKey:@"username"]);
            
            //NSLog(@"error: %@", err);
        }
    }*/
    
    if (self) {
        // Initialization code here.
        
        // load user defaults from preferences file
        NSString *srvURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"ServerURL"];
        srvURL = [srvURL stringByAppendingString:@"resources/be.luckycode.projetawebservice.users/"];
        NSURL *url = [NSURL URLWithString:srvURL];
        
        // get users
        //NSURL *url = [NSURL URLWithString:@"https://luckycode.be:8181/projeta-webservice/resources/be.luckycode.projetawebservice.users/"];
        // get user
        //NSURL *url = [NSURL URLWithString:@"https://test:test@luckycode.be:8181/projeta-webservice/resources/be.luckycode.projetawebservice.users/2?"];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setUseKeychainPersistence:YES];
        
        [request startSynchronous];
        NSError *error = [request error];
        NSError *err;
        if (!error) {
            NSString *response = [request responseString];
            //User *usr = [[User alloc] init];
            NSDictionary *dict = [[NSDictionary alloc] init];
            dict = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:&err];
            NSLog(@"response: %@", response);
            
            //NSLog(@"test: %@", usr.username);
            //NSLog(@"test: %@", [dict valueForKey:@"username"]);
            //PTUser *ptusr;
            
            
            //// works also
            //PTUser *ptusers = [PTUser instanceFromDictionary:dict];
            //
            //for (User* usr in [ptusers users])
            //{
            //    NSLog(@"t: %@", [usr username]);
            //}
            //
            //arrUsr = [ptusers users];
            
            
            arrUsr = [PTUser setAttributesFromDictionary2:dict]; 
            
            //NSLog(@"error: %@", err);
        }
        else
        {
            NSLog(@"Failed %@ with code %ld and with userInfo %@",[error domain],[error code],[error userInfo]);  
        }
    }
    
    return self;
}

@end
