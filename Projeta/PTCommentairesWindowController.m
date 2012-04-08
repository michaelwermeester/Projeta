//
//  PTCommentairesWindowController.m
//  Projeta
//
//  Created by Michael Wermeester on 4/9/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "PTCommentairesViewController.h"
#import "PTCommentairesWindowController.h"

@interface PTCommentairesWindowController ()

@end

@implementation PTCommentairesWindowController

@synthesize commentsView;
@synthesize commentViewController;
@synthesize task;

- (id)init
{
    self = [super initWithWindowNibName:@"PTCommentairesWindow"];
    //self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    commentViewController = [[PTCommentairesViewController alloc] init];
    
    commentViewController.task = task;
    
    [self.commentsView addSubview:commentViewController.view];
}

@end
