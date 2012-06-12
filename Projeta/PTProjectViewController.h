//
//  PTProjectViewController.h
//  Projeta
//
//  Created by Michael Wermeester on 14/08/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;
@class PTProjectDetailsViewController;
@class PXSourceList;

@interface PTProjectViewController : NSViewController {
    NSMutableArray *sourceListItems;

    NSMutableArray *arrPrj;     // array qui contient les projets. 
    NSTreeController *prjTreeController;    // tree controller pour l'array arrPrj.
    
    NSSplitView *splitView;
    NSView *leftView;           // partie gauche de la splitview.
    NSView *rightView;          // partie droite de la splitview. 
    PXSourceList *sourceList;
    NSOutlineView *altSourceList;
    NSOutlineView *outlineView;
    
    PTProjectDetailsViewController *projectDetailsViewController;
}


@property (strong) NSMutableArray *arrPrj;  // array qui contient les projets. 
@property (strong) IBOutlet NSTreeController *prjTreeController;    // tree controller pour l'array arrPrj.

// référence vers main window controller.
@property (assign) MainWindowController *mainWindowController;
// référence vers project details view controller.
@property (strong) PTProjectDetailsViewController *projectDetailsViewController;
@property (strong) IBOutlet NSSplitView *splitView;
@property (strong) IBOutlet NSView *leftView;       // partie gauche de la splitview.
@property (strong) IBOutlet NSView *rightView;      // partie droite de la splitview. 
@property (strong) IBOutlet NSOutlineView *altOutlineView;

// sélectionner project principal. 
- (void)selectMainProject;

@end
