//
//  PTGroupManagementViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 31/10/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "MainWindowController.h"
#import "MWConnectionController.h"
#import "PTCommon.h"
#import "PTBugCategoryManagementViewController.h"
//#import "PTGroupUserWindowController.h"
#import "PTBugCategoryHelper.h"
//#import "PTUserHelper.h"
#import "BugCategory.h"

@implementation PTBugCategoryManagementViewController

@synthesize arrBugCat;
@synthesize bugCategoryArrayCtrl;
@synthesize bugCategoryTableView;
@synthesize mainWindowController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"PTBugCategoryManagementView" bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
        arrBugCat = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    // bind the main window's search field to the arraycontroller.
    [[mainWindowController searchField] bind:@"predicate" toObject:bugCategoryArrayCtrl withKeyPath:@"filterPredicate" options:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"predicate", NSDisplayNameBindingOption,
                    @"(bugCategoryName contains[cd] $value) OR (description contains[cd] $value)",
                    NSPredicateFormatBindingOption,
                    nil]
     ];
    
    // Fetch user groups from webservice.
    [self fetchBugCategories];
}

- (void)loadView
{
    [super loadView];
    
    [self viewDidLoad];
}

// Fetch user groups from webservice.
- (void)fetchBugCategories {
    
    [mainWindowController startProgressIndicatorAnimation];
    
    // get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    urlString = [urlString stringByAppendingString:@"resources/bugcategories/all"];
    
    // convert to NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    // NSURLConnection - MWConnectionController
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {
                                                        [self fetchRequestFinished:data];
                                                    }
                                                    failureBlock:^(NSError *error) {
                                                        [self fetchRequestFailed:error];
                                                    }];
    
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    [connectionController startRequestForURL:url setRequest:urlRequest];
}

- (void)fetchRequestFinished:(NSMutableData*)data {
    
    NSError *error;
    
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    // à partir du dictionnaire, créer des catégories de bogue et les rajouter dans l'array. 
    [[self mutableArrayValueForKey:@"arrBugCat"] addObjectsFromArray:[PTBugCategoryHelper setAttributesFromJSONDictionary:dict]];
    
    // trier la liste par nom de catégorie.
    [bugCategoryTableView setSortDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"categoryName" ascending:YES selector:@selector(compare:)], nil]];
    
    [mainWindowController stopProgressIndicatorAnimation];
}

- (void)fetchRequestFailed:(NSError*)error {
    [mainWindowController stopProgressIndicatorAnimation];
}

- (IBAction)addBugCategoryButtonClicked:(id)sender {
    
    BugCategory *bugcat = [[BugCategory alloc] init];
    [bugCategoryArrayCtrl insertObject:bugcat atArrangedObjectIndex:([arrBugCat count])];
}

- (void)tableView:(NSTableView *)aTableView
   setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)aTableColumn
              row:(int)rowIndex {
    
    NSArray *selectedObjects = [bugCategoryArrayCtrl selectedObjects];
    
    for (BugCategory *bugcat in selectedObjects)
    {
        // update Usergroup.
        [self updateBugCategory:bugcat];
    }
}

- (void)updateBugCategory:(BugCategory *)theBugCategory {
    // create dictionary from Bug Categories
    NSDictionary *dict = [theBugCategory dictionaryWithValuesForKeys:[theBugCategory allKeys]];
    
    // create NSData from dictionary
    NSError* error;
    NSData *requestData = [[NSData alloc] init];
    requestData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    
    // get server URL as string
    NSString *urlString = [PTCommon serverURLString];
    // build URL by adding resource path
    urlString = [urlString stringByAppendingString:@"resources/bugcategories"];
    
    // convert to NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    MWConnectionController* connectionController = [[MWConnectionController alloc] 
                                                    initWithSuccessBlock:^(NSMutableData *data) {
                                                        
                                                    }
                                                    failureBlock:^(NSError *error) {
                                                        
                                                    }];
    
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString* requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [requestData length]];
    
    [urlRequest setHTTPMethod:@"PUT"]; // update
    [urlRequest setHTTPBody:requestData];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:requestDataLengthString forHTTPHeaderField:@"Content-Length"];
    [urlRequest setTimeoutInterval:30.0];
    
    [connectionController startRequestForURL:url setRequest:urlRequest];
}

@end
