//
//  PTGanttViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 5/5/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "PTGanttView.h"
#import "PTGanttViewController.h"

@interface PTGanttViewController ()

@end

@implementation PTGanttViewController

@synthesize mainWindowController;
@synthesize parentProjectDetailsViewController;

@synthesize project;
@synthesize ganttView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"PTGanttViewController" bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
    }
    
    return self;
}

- (void)loadGantt {
    
    [ganttView setProject:project];
}

@end
