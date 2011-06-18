//
//  PreferencesController.m
//  Projeta
//
//  Created by Michael Wermeester on 18/06/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import "PreferencesController.h"

static PreferencesController *_sharedPrefsWindowController = nil;

static NSString *nibName = @"Preferences";

@implementation PreferencesController

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
    
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0.1];
	
	if ([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask)
	    [[NSAnimationContext currentContext] setDuration:1.0];
	
	[[[self.window contentView] animator] replaceSubview:previousView with:view];
	[[self.window animator] setFrame:newFrame display:YES];
    
	[NSAnimationContext endGrouping];
	
}

@end
