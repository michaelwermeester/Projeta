//
//  PTSetPasswordWindowController.m
//  Projeta
//
//  Created by Michael Wermeester on 1/20/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "PTSetPasswordWindowController.h"
#import "PTUserHelper.h"

@implementation PTSetPasswordWindowController
@synthesize password1InvalidImageView;
@synthesize password2InvalidImageView;
@synthesize password1TextField;
@synthesize password2TextField;
@synthesize updatePasswordProgressIndicator;
@synthesize userId;

- (id)init
{
    self = [super initWithWindowNibName:@"PTSetPasswordWindow"];
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

- (void)windowWillClose:(NSNotification *)notification
{
    //[NSApp stopModal];
    
    [self endSheet];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self close];
}

- (IBAction)okButtonClicked:(id)sender {

    // check if a password has been entered and if both passwords are the same.
    if ([[password1TextField stringValue] length] > 0 && [self arePasswordsEqual] == YES)
    {
        [updatePasswordProgressIndicator startAnimation:self];
        
        [PTUserHelper updateUserPassword:userId password:[password1TextField stringValue] successBlock:^(NSMutableData *data) {[self updateFinished:data];} failureBlock:^(NSError *error) {[self updateFailed:error];}];
    }
}
         
- (void)updateFailed:(NSError *)failure {
    NSLog(@"failed updating password.");
    
    [updatePasswordProgressIndicator stopAnimation:self];
        
}
         
- (void)updateFinished:(NSMutableData *)data {
    
    [updatePasswordProgressIndicator stopAnimation:self];
    
    // close this window.
    [self close];
}

- (void)endSheet
{
    // Return to normal event handling
    [NSApp endSheet:[self window]];
    // Hide the sheet
    [[self window] orderOut:self];
}

- (void)controlTextDidChange:(NSNotification *)aNotification
{
    // first password NSTextField
    if([aNotification object] == password1TextField)
    {
        // check if a password has been entered.
        if ([[password1TextField stringValue] length] > 0)
        {
            // make invalid image invisible.
            [password1InvalidImageView setHidden:YES];
        }
        else 
        {
            // make invalid image visible.
            [password1InvalidImageView setHidden:NO];
        }
        
        if ([[password2TextField stringValue] length] > 0)
        {
            // check if both passwords are the same.
            [self arePasswordsEqual];
        }
    }
    else if ([aNotification object] == password2TextField)
    {
        // check if both passwords are the same.
        [self arePasswordsEqual];
    }
}

// checks if both passwords are the same.
- (Boolean)arePasswordsEqual
{
    // if passwords are different...
    if ([[password1TextField stringValue] isEqualToString:[password2TextField stringValue]])
    {
        // make invalid image visible.
        [password2InvalidImageView setHidden:YES];
        // they are the same.
        return YES;
    }
    else 
    {
        // make invalid image visible.
        [password2InvalidImageView setHidden:NO];
        // they are different.
        return NO;
    }
}

@end
