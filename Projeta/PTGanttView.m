//
//  PTGanttView.m
//  Projeta
//
//  Created by Michael Wermeester on 5/5/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "PTGanttView.h"

#import "Project.h"

@implementation PTGanttView

@synthesize project;

NSBezierPath *aPath ;

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
    NSRect f = self.frame;
    f.size.width = 1280;
    f.size.height = 8000;
    self.frame = f;
    
    [[NSColor redColor] set ] ;
    
    // drawing a rectangle using a class method of NSBezierPath
    [NSBezierPath strokeRect: NSMakeRect( 50,50,8,8 ) ] ;
    
    // drawing a rectangle using an instance method of NSBezierPath
    // this usefull if you want to do additional drawing in that path
    [[NSColor greenColor] set ] ;
    aPath = [NSBezierPath bezierPathWithRect: NSMakeRect( 110, 110, 8, 8) ] ;
    [aPath stroke] ;
    
    [[NSColor blueColor] set ];
    aPath = [NSBezierPath bezierPathWithRect: NSMakeRect( 110, -110, 8, 8) ] ;
    [aPath stroke] ;
    
    //NSLog(@"test: %@", project.projectTitle);
    
    for (Project *p in project.childProject) {
        
    }
}



@end
