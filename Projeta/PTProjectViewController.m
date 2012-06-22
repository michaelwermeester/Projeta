//
//  PTProjectViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 14/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "MainWindowController.h"
#import "MWTableCellView.h"
#import "PTProjectDetailsViewController.h"
#import "PTProjectViewController.h"
#import "SourceListItem.h"
#import "Project.h"

@implementation PTProjectViewController
@synthesize altOutlineView;

@synthesize arrPrj;
@synthesize prjTreeController;

@synthesize mainWindowController;
@synthesize projectDetailsViewController;
@synthesize splitView;
@synthesize leftView;
@synthesize rightView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"PTProjectView" bundle:nibBundleOrNil];
    if (self) {

        // ne pas déplacer les éléments de l'outline view. 
        [outlineView setFloatsGroupRows:NO];
    }
    
    return self;
}

-(void)awakeFromNib {
    
    // expand item ( http://stackoverflow.com/questions/519751/nsoutlineview-auto-expand-all-nodes )
    [altOutlineView expandItem:nil expandChildren:YES];
}

// sélectionner project principal. 
// Ne pas mettre cet appel de méthode dans awakeFromNib -> problème lors de création d'un nouveau projet.
- (void)selectMainProject {
    // sélectionner le premier élément de l'outlineview.
    [altOutlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];
}

- (void)loadView
{
    [super loadView];
    
    // instancier.
    projectDetailsViewController = [[PTProjectDetailsViewController alloc] init];
    
    // garder une référence...
    projectDetailsViewController.projectViewController = self;
    projectDetailsViewController.mainWindowController = self.mainWindowController;
    
    // redimensionner la vue à la taille du panneau droite (right splitview view). 
    [projectDetailsViewController.view setFrameSize:rightView.frame.size];
    
    // ajouter la vue dans la panneau à droite. 
    [self.rightView addSubview:projectDetailsViewController.view];
    
    // auto resize de la vue.
    [projectDetailsViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    // sélectionner le premier élément de l'outlineview.
    [altOutlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];
    
    projectDetailsViewController.project = [[prjTreeController selectedObjects] objectAtIndex:0];
    
    // charger les utilisateurs, groupes et clients liés au projet.
    //[projectDetailsViewController loadProjectDetails];
    // charger les tâches liés au projet.
    
    [projectDetailsViewController loadTasks];
    // charger les bogues liés au projet.
    [projectDetailsViewController loadBugs];
    // charger les commentaires liés au projet.
    [projectDetailsViewController loadComments];
    // charger le diagramme de Gantt lié au projet.
    [projectDetailsViewController loadGantt];
}

#pragma mark -
#pragma mark View resizing

// redimensionner proprement la splitview (seulement redimensionner la partie droite, ne pas toucher à la partie gauche)
- (void)splitView:(NSSplitView *)sender resizeSubviewsWithOldSize:(NSSize)oldSize
{
    // largeur de la vue. 
    NSSize splitViewSize = [sender frame].size;
    
    // garder la même taille pour la partie gauche. 
    NSSize leftSize = [leftView frame].size;
    leftSize.height = splitViewSize.height;
    
    // redimensionner la partie droite. 
    NSSize rightSize;
    rightSize.height = splitViewSize.height;
    rightSize.width = splitViewSize.width - [sender dividerThickness] - leftSize.width;
    
    [leftView setFrameSize:leftSize];
    [rightView setFrameSize:rightSize];
}

#pragma mark -
#pragma mark outline view

// retourne YES s'il s'agit d'un group item.
- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
    if ([altOutlineView parentForItem:item]) {
        // If not nil; then the item has a parent.
        return NO;
    }
    return YES;
}

// nécessaire pour que l'outline view puisse afficher tu texte. 
- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    
    // s'il s'agit d'un projet...
    if ([[item representedObject] isKindOfClass:[Project class]]) {
        
        Project *tmpPrj = [item representedObject];
        
        if (tmpPrj.parentProjectId == nil) {
            return [altOutlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
        } else {
            // set badge count
            MWTableCellView *tmpView = [altOutlineView makeViewWithIdentifier:@"DataCell" owner:self];
            
            NSArray *supectConstraints = [tmpView.badgeButton constraintsAffectingLayoutForOrientation:NSLayoutConstraintOrientationHorizontal];
            
            [rightView addSubview:tmpView];
            [mainWindowController.window visualizeConstraints:supectConstraints];
            
            return tmpView;
        }
    }
    
    // s'il s'agit d'une en-tête...
    if ([[item representedObject] isKindOfClass:[OutlineCollection class]]) {
        return [altOutlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
    }   
    
    
    return nil;
}

// lorsque la sélection de projet change...
- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    
    // si l'élément sélectionné est un projet, afficher le détail.
    if ([[[prjTreeController selectedObjects] objectAtIndex:0] isKindOfClass:[Project class]]) {
    
        projectDetailsViewController.project = [[prjTreeController selectedObjects] objectAtIndex:0];
        
        
        [projectDetailsViewController setIsNewProject:NO];
        
        // mémoriser date début et date fin du projet parent.
        
        // get parent node.
        NSTreeNode *parent = [[[[prjTreeController selectedNodes] objectAtIndex:0] parentNode] parentNode];
        NSMutableArray *parentProjects = [[parent representedObject] mutableArrayValueForKeyPath:
                                          [prjTreeController childrenKeyPathForNode:parent]];
        // get projectid du projet parent. 
        for (Project *p in parentProjects)
        {
            
            if ([p.childObject containsObject:[[prjTreeController selectedObjects] objectAtIndex:0]])
            {
                if (p.startDate) {
                    projectDetailsViewController.parentProjectStartDate = p.startDate;
                }
                if (p.endDate)
                    projectDetailsViewController.parentProjectEndDate = p.endDate;

                break;
            }
        }
        
        
        NSLog(@"PROID: %@", projectDetailsViewController.project.projectTitle);
        NSLog(@"PROID: %@", projectDetailsViewController.project.projectId);
        
        [projectDetailsViewController loadProjectDetails];

    } 
    else {
        projectDetailsViewController.project = nil;
    }
    
}

// Si l'élément sélectionné dans la source list est un project, sélectionner ce projet.
// S'il ne s'agit pas d'un projet, ne pas sélectionner l'élément.
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item {
    
    if ([[item representedObject] isKindOfClass:[Project class]]) {
        return YES;
    } else {
        return NO;
    }
}

@end
