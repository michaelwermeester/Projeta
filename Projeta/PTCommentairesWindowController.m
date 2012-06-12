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

@synthesize bug;
@synthesize commentsView;
@synthesize commentViewController;
@synthesize mainWindowController;
@synthesize project;
@synthesize task;

- (id)init
{
    self = [super initWithWindowNibName:@"PTCommentairesWindow"];
    if (self) {
        
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    commentViewController = [[PTCommentairesViewController alloc] init];
    
    commentViewController.task = task;
    commentViewController.project = project;
    commentViewController.bug = bug;
    // garder références.
    commentViewController.parentWindowController = self;
    commentViewController.mainWindowController = mainWindowController;
    
    // resize the view to fit and fill the right splitview view
    [commentViewController.view setFrameSize:commentsView.frame.size];
    
    [self.commentsView addSubview:commentViewController.view];
    
    // auto resize view.
    [commentViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
}

@end
