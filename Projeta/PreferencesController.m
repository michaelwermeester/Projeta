//
//  PreferencesController.m
//  Projeta
//
//  Created by Michael Wermeester on 18/06/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import "PreferencesController.h"
#import "ASIHTTPRequest.h"

static PreferencesController *_sharedPrefsWindowController = nil;

static NSString *nibName = @"Preferences";

@implementation PreferencesController
@synthesize usernameTextField;
@synthesize passwordTextField;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
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

+ (PreferencesController *)sharedPrefsWindowController
 {
 if (!_sharedPrefsWindowController) {
 _sharedPrefsWindowController = [[self alloc] initWithWindowNibName:nibName];
 }
 
 return _sharedPrefsWindowController;
}

-(void)awakeFromNib{
	[self.window setContentSize:[generalPreferenceView frame].size];
	[[self.window contentView] addSubview:generalPreferenceView];
	[bar setSelectedItemIdentifier:@"General"];
	[self.window center];
}

-(NSView *)viewForTag:(NSInteger)tag {
    NSView *view = nil;
    
	switch(tag) {
		case 0: default: view = generalPreferenceView; break;
		case 1: view = accountPreferenceView; break;
	}
    
    return view;
}
-(NSRect)newFrameForNewContentView:(NSView *)view {
	
    NSRect newFrameRect = [self.window frameRectForContentRect:[view frame]];
    NSRect oldFrameRect = [self.window frame];
    NSSize newSize = newFrameRect.size;
    NSSize oldSize = oldFrameRect.size;    
    NSRect frame = [self.window frame];
    frame.size = newSize;
    frame.origin.y -= (newSize.height - oldSize.height);
    
    return frame;
}

-(IBAction)switchView:(id)sender {
	
	NSInteger tag = (int)[sender tag];
	
	NSView *view = [self viewForTag:tag];
	NSView *previousView = [self viewForTag: currentViewTag];
	currentViewTag = tag;
	NSRect newFrame = [self newFrameForNewContentView:view];

    
    NSView *emptyView = [[NSView alloc] init];
    
    [[self.window contentView] replaceSubview:previousView with:emptyView];
    
    //NSRect frame = [self.window frame];
    //frame.origin = newFrame.origin;
    
    //NSRect newFrameRect = [self.window frameRectForContentRect:[view frame]];
    //NSSize newSize = newFrameRect.size;
    //NSSize newSize = newFrame.size;
    
    //frame.size = newSize;
    
    //[self.window setFrame:frame display:YES animate:YES];
    [self.window setFrame:newFrame display:YES animate:YES];
    
   
    [[self.window contentView] replaceSubview:emptyView with:view]; 
}


#pragma mark Credentials - Keychain

- (NSString*)username
{
    // get credential from keychain
    //NSURLCredential *tmpCredential = [ASIHTTPRequest savedCredentialsForHost:[[self URL] host] port:[[[self URL] port] intValue] protocol:[[self URL] scheme] realm:nil];
    
    // get credential from keychain and return username
    return [[self getCredentialFromKeyChain] user];
}

- (void)setUsername:(NSString *)newUsername
{
    // remove old credentials (not necessary but let's do it to do some clean-up)
    [self removeCredentialsFromKeychain];
    
    // save credentials to keychain
    [self saveCredentialsToKeychain];
}

- (NSString*)password
{
    return [[self getCredentialFromKeyChain] password];
}

- (void)setPassword:(NSString *)newPassword
{
    // remove old credentials (not necessary but let's do it to do some clean-up)
    [self removeCredentialsFromKeychain];
    
    // save credentials to keychain
    [self saveCredentialsToKeychain];
}

- (NSURL*)serverURL
{
    // load user defaults from preferences file
    NSString *strURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"ServerURL"];
    
    // return URL
    return [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (void)setServerURL:(NSString *)theURL
{
    // remove old credentials (not necessary but let's do it to do some clean-up)
    [self removeCredentialsFromKeychain];
    
    // save user defaults to preferences file
    [[NSUserDefaults standardUserDefaults] setObject:theURL forKey:@"ServerURL"];
    
    // save credentials to keychain (call ASIHTTPRequest method)
    [self saveCredentialsToKeychain];
}

// get saved credential from keychain
- (NSURLCredential*)getCredentialFromKeyChain
{
    // return credential from keychain
    return [ASIHTTPRequest savedCredentialsForHost:[[self serverURL] host] port:[[[self serverURL] port] intValue] protocol:[[self serverURL] scheme] realm:@"ProjetaRealm"];
}

// remove credentials from keychain
- (void)removeCredentialsFromKeychain
{
    [ASIHTTPRequest removeCredentialsForHost:[[self serverURL] host] port:[[[self serverURL] port] intValue] protocol:[[self serverURL] scheme] realm:@"ProjetaRealm"];
}

// save credentials to keychain
- (void)saveCredentialsToKeychain
{
    if ([self hasValidUrl] && [[usernameTextField stringValue] length] > 0)
    {
        //NSURL *url = [NSURL URLWithString:[[self URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLCredential* credential;
        /*credential = [NSURLCredential credentialWithUser:[self username]
											password:[self password]
										 persistence:NSURLCredentialPersistencePermanent];*/
        credential = [NSURLCredential credentialWithUser:[usernameTextField stringValue]
											password:[passwordTextField stringValue]
										 persistence:NSURLCredentialPersistencePermanent];

        // save credentials to keychain
        [ASIHTTPRequest saveCredentials:credential forHost:[[self serverURL] host] port:[[[self serverURL] port] intValue] protocol:[[self serverURL] scheme] realm:@"ProjetaRealm"];
    }
}

// check for valid URL (this avoids saving null URL entries to keychain)
- (bool)hasValidUrl
{
    // http://stackoverflow.com/questions/1471201/how-to-validate-an-url-on-the-iphone
    
    // WARNING > "test" is an URL according to RFCs, being just a path
    // so you still should check scheme and all other NSURL attributes you need
    if ([self serverURL] && [[self serverURL] scheme] && [[self serverURL] host] && [[self serverURL] port]) {
        // candidate is a well-formed url with:
        //  - a scheme (like http://)
        //  - a host (like stackoverflow.com)
        
        return true;
    }
    
    return false;
}

// save preferences when closing window (needed when user closes window 
// while still being in edit mode)
- (void)windowWillClose:(NSNotification *)notification
{
    [self saveCredentialsToKeychain];
}
 

@end
