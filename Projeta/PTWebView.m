//
//  PTWebView.m
//  Projeta
//
//  Created by Michael Wermeester on 5/1/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "PTWebView.h"

@implementation PTWebView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

- (void)viewWillDraw {
    
    // éviter d'avoir un background blanc.
    [self setDrawsBackground:NO];
}

@end
