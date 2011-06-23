//
//  PreferencesController.h
//  Projeta
//
//  Created by Michael Wermeester on 18/06/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesController : NSWindowController /*<NSWindowDelegate> */ {
    IBOutlet NSToolbar *bar;
	IBOutlet NSView *generalPreferenceView;
	IBOutlet NSView *accountPreferenceView;
	NSInteger currentViewTag;
    
    NSString *username;
    NSString *password;
    NSString *URL;
    NSTextField *usernameTextField;
    NSSecureTextField *passwordTextField;
}

+ (PreferencesController *)sharedPrefsWindowController;
- (NSView *)viewForTag:(NSInteger)tag;
- (IBAction)switchView:(id)sender;
- (NSRect)newFrameForNewContentView:(NSView *)view;

// username/password/URL - account info
@property (retain) NSString *username;
@property (retain) NSString *password;
@property (retain) NSURL *URL;

- (NSURLCredential*)getCredentialFromKeyChain;
- (void)removeCredentialsFromKeychain;
- (void)saveCredentialsToKeychain;

- (bool)hasValidUrl;

@property (strong) IBOutlet NSTextField *usernameTextField;
@property (strong) IBOutlet NSSecureTextField *passwordTextField;

@end
