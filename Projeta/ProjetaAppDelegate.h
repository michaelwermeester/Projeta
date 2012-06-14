//
//  ProjetaAppDelegate.h
//  Projeta
//
//  Created by Michael Wermeester on 10/06/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindow;
@class MainWindowController;
@class PreferencesController;
@class PTUserManagementWindowController;

@interface ProjetaAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *_window;
    NSPersistentStoreCoordinator *__persistentStoreCoordinator;
    NSManagedObjectModel *__managedObjectModel;
    NSManagedObjectContext *__managedObjectContext;
    
    // preferences window
    PreferencesController *preferencesController;
    // users window
    PTUserManagementWindowController *usersWindowController;
}

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// opens a new main window
- (IBAction)newMainWindow:(id)sender;
// preferences window.
- (IBAction)openPreferences:(id)sender;

// removes reference to main window that will be closed
+ (void)removeMainWindow:(MainWindowController*)window;

@end
