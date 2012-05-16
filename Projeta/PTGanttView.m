//
//  PTGanttView.m
//  Projeta
//
//  Created by Michael Wermeester on 5/5/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "PTGanttView.h"

#import "Project.h"

#import "NSDate+MWExtensions.h"

int counter;
int totalProjects;
NSInteger days;

@implementation PTGanttView

@synthesize project;

@synthesize minDate;
@synthesize maxDate;

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
    totalProjects = [self countTotalProjects:project];
    
    // Drawing code here.
    NSRect f = self.frame;
    f.size.width = 1280;
    //f.size.height = 8000;
    f.size.height = totalProjects * 20;
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
    
    
    minDate = project.startDate;
    maxDate = project.endDate;
    // 
    days = [self daysBetweenDates:minDate maxDate:maxDate];
    
    
    
    counter = 1;
    
    [self drawDays];
    [self drawDates];
    [self drawProjectBar:project];
}

- (void)drawProjectBar:(OutlineCollection *)aProject {
    
    [[NSColor greenColor] set ] ;

    for (OutlineCollection *p in aProject.childObject) {
        
        //aPath = [NSBezierPath bezierPathWithRect: NSMakeRect( 110, counter * 5, 10, 10) ] ;
        ///[aPath stroke] ;
        
        [NSBezierPath strokeRect: NSMakeRect( 50,counter * 10,5,8 ) ] ;
        
        counter++;
        
        [self drawProjectBar:p];
    }
}

- (void)drawDays {
    
    [[NSColor darkGrayColor] set ] ;
    //[[NSColor blackColor] set];
    
    for (int i = 0; i < days; i++) {
        
        [NSBezierPath strokeRect: NSMakeRect( 20 * i, 10, 0.3, 50) ] ;
        
    }
    
    NSLog(@"days: %ld", days);
}

- (void)drawDates {
    
    [[NSColor blackColor] set];

    
    NSMutableDictionary *drawStringAttributes = [[NSMutableDictionary alloc] init];
	[drawStringAttributes setValue:[NSColor blackColor] forKey:NSForegroundColorAttributeName];
	[drawStringAttributes setValue:[NSFont fontWithName:@"American Typewriter" size:11] forKey:NSFontAttributeName];
    
    NSString *budgetString = [NSString stringWithFormat:@"TEST"];
    NSSize stringSize = [budgetString sizeWithAttributes:drawStringAttributes];
	NSPoint centerPoint;
	centerPoint.x = (self.frame.size.width / 2) - (stringSize.width / 2);
	centerPoint.y = self.frame.size.height / 2 - (stringSize.height / 2);
	[budgetString drawAtPoint:centerPoint withAttributes:drawStringAttributes];
}

// retourne le nombre de projets (projet et ses sous-projets).
- (int)countTotalProjects:(OutlineCollection *)aProject {
    
    int totalProjects = 0;
    
    for (OutlineCollection *p in aProject.childObject) {
     
        totalProjects++;
        
        totalProjects += [self countTotalProjects:p];
    }
    
    return totalProjects;
}

- (NSInteger)daysBetweenDates:(NSDate *)dt1 maxDate:(NSDate *)dt2 {
    
    //NSInteger numDays;
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
//    NSDateComponents *components = [gregorian components:unitFlags fromDate:dt1 toDate:dt2 options:0];
//    numDays = [components day];
    
    
     return [dt1 numberOfDaysUntil:dt2];
    
    //return numDays;
}


@end
