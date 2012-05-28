//
//  PTGanttViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 5/5/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "Project.h"
#import "PTGanttView.h"
#import "PTGanttViewController.h"

@interface PTGanttViewController ()

@end

@implementation PTGanttViewController

@synthesize ganttView;
@synthesize mainWindowController;
@synthesize parentProjectDetailsViewController;
@synthesize project;
@synthesize scrollView;

// Méthode qui permet d'instancier le fichier nib. 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"PTGanttViewController" bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

// initialiser les paramètres du diagramme de Gantt. 
- (void)loadGantt {
    
    // passer le projet à la vue Gantt.
    [ganttView setProject:project];

    // Passer la taille de cette vue à la sous-vue.
    [ganttView setParentViewSize:self.view.frame.size];
    
}


@end
