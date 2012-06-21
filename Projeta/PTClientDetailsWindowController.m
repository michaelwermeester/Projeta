//
//  PTClientDetailsWindowController.m
//  Projeta
//
//  Created by Michael Wermeester on 2/1/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "PTClientDetailsWindowController.h"

#import "Client.h"

@implementation PTClientDetailsWindowController

@synthesize client;

- (id)init
{
    self = [super initWithWindowNibName:@"PTClientDetailsWindow"];
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
}

// Retourne le titre de la fenêtre.
- (NSString *)windowTitle {
    
    // afficher 'Projet : <nom du projet>'.
    NSString *retVal = [[NSString alloc] initWithString:@"Client"];
    if (client) {
        if (client.clientName) {
            retVal = [retVal stringByAppendingString:@" : "];
            retVal = [retVal stringByAppendingString:client.clientName];
        }
    }
    
    // si nouveau projet, afficher 'Nouveau projet'.
    //if (isNewTask)
     //   retVal = [[NSString alloc] initWithString:@"Nouveau client"];
    
    return retVal;
    
}

@end
