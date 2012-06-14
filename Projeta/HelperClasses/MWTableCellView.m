//
//  MWTableCellView.m
//  Projeta
//
//  Created by Michael Wermeester on 06/11/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "MWTableCellView.h"

#import "Project.h"

@implementation MWTableCellView

@synthesize badgeButton;
@synthesize staticText;

        /*Project *prj = [[super value] representedObject];
        NSLog(@"test");
        [badgeButton setTitle:prj.projectTitle];*/

- (void)drawRect:(NSRect)dirtyRect {
    

}

- (void)setBadgeCount:(NSString *)badgeCount {

    
    [badgeButton setHidden:YES];
    
    [self setNeedsDisplay:YES];
}

@end
