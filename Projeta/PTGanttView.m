//
//  PTGanttView.m
//  Projeta
//
//  Created by Michael Wermeester on 5/5/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//


#import "PTGanttView.h"

#import "NSDate+MWExtensions.h"
#import "Project.h"
#import "PTCommon.h"

int counter;
int totalProjects;
NSInteger days;

CGFloat headerHeight = 70.0f; 

@implementation PTGanttView

@synthesize project;

@synthesize minDate;
@synthesize maxDate;

@synthesize parentViewSize;

NSBezierPath *aPath ;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
        //headerHeight = 70.0f;
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    
    Project *dummyProject = [[Project alloc] init];
    dummyProject.childProject = [[NSMutableArray alloc] init];
    [dummyProject.childProject addObject:project];
    
    //totalProjects = [self countTotalProjects:project];
    totalProjects = [self countTotalProjects:dummyProject];
    
    minDate = project.startDate;
    maxDate = project.endDate;
    // 
    days = [self daysBetweenDates:minDate maxDate:maxDate];
    
    
    // Drawing code here.
    NSRect f = self.frame;
    f.size.width = days * 20;
    // height of header (dates): 39
    f.size.height = totalProjects * 20 + headerHeight;
    
    if (f.size.height < parentViewSize.height) {
        f.size.height = parentViewSize.height - 60;
    }
    
    self.frame = f;
    
    /*[[NSColor redColor] set ] ;
    
    // drawing a rectangle using a class method of NSBezierPath
    [NSBezierPath strokeRect: NSMakeRect( 50,50,8,8 ) ] ;
    
    // drawing a rectangle using an instance method of NSBezierPath
    // this usefull if you want to do additional drawing in that path
    [[NSColor greenColor] set ] ;
    aPath = [NSBezierPath bezierPathWithRect: NSMakeRect( 110, 110, 8, 8) ] ;
    [aPath stroke] ;
    
    [[NSColor blueColor] set ];
    aPath = [NSBezierPath bezierPathWithRect: NSMakeRect( 110, -110, 8, 8) ] ;
    [aPath stroke] ;*/
    
    //NSLog(@"test: %@", project.projectTitle);
    
    
    
    
    counter = 1;
    
    [self drawDays];
    [self drawDates];
    //[self drawProjectBar:project];
    [self drawProjectBar:dummyProject];
    
    
    //[[parentScrollView contentView] scrollToPoint: point];
    //[parentScrollView reflectScrolledClipView: [parentScrollView contentView]];
    
    //[[parentScrollView verticalScroller] setFloatValue:0.0];
    //[[parentScrollView contentView] scrollToPoint:NSMakePoint(0.0, self.frame.size.height - parentScrollView.contentView.si.height)];
    
    
    
    
    
}

- (void)drawProjectBar:(OutlineCollection *)aProject {
    
    

    for (OutlineCollection *p in aProject.childObject) {
        
        //aPath = [NSBezierPath bezierPathWithRect: NSMakeRect( 110, counter * 5, 10, 10) ] ;
        ///[aPath stroke] ;
        
        //[NSBezierPath strokeRect: NSMakeRect( 50, self.frame.size.height - (counter * 20),5, 20 ) ] ;
        
        NSInteger start = [self daysBetweenDates:minDate maxDate:p.startDate] * 20;
        NSInteger length = [self daysBetweenDates:p.startDate maxDate:p.endDate] * 20;
        
        // 
        [[NSColor greenColor] set ] ;
        [NSBezierPath fillRect: NSMakeRect(start, headerHeight + counter * (20 + 4), length, 20 ) ] ;
        // bordure noir.
        [[NSColor blackColor] set ] ;
        [NSBezierPath strokeRect: NSMakeRect(start, headerHeight + counter * (20 + 4), length, 20 ) ] ;
        
        [self drawProjectNames:(Project *)p startPosition:start length:length positionY:headerHeight + counter * (20 + 4)];
        
        
        counter++;
        
        
        
        [self drawProjectBar:p];
    }
}

- (void)drawProjectNames:(Project *)aProject 
           startPosition:(NSInteger)startPositionX 
                  length:(NSInteger)length
               positionY:(NSInteger)positionY {
    
    NSMutableDictionary *drawStringAttributes = [[NSMutableDictionary alloc] init];
    [drawStringAttributes setValue:[NSColor blackColor] forKey:NSForegroundColorAttributeName];
    //[drawStringAttributes setValue:[NSFont fontWithName:@"American Typewriter" size:11] forKey:NSFontAttributeName];
    [drawStringAttributes setValue:[NSFont boldSystemFontOfSize:11] forKey:NSFontAttributeName];
    
    NSString *projTitleString = [NSString stringWithFormat:aProject.projectTitle];
    NSSize stringSize = [projTitleString sizeWithAttributes:drawStringAttributes];

    NSPoint centerPoint;

    // si longueur du texte plus grand que la barre, afficher le titre à côté de la barre.
    if (stringSize.width > length) {
        centerPoint.x = startPositionX + length + 5;// + (stringSize.width / 2);
    } else {    // afficher le titre du projet dans la barre. 
        centerPoint.x = startPositionX + (length / 2) - (stringSize.width / 2);
    }
    // standard coordinate system.
    //centerPoint.y = self.frame.size.height - headerHeight;
    // flipped coordinate system.
    centerPoint.y = positionY + 10 - stringSize.height / 2;
    
    [projTitleString drawAtPoint:centerPoint withAttributes:drawStringAttributes];

}

- (void)drawDays {
    
    [[NSColor darkGrayColor] set ] ;
    //[[NSColor blackColor] set];
    
    for (int i = 0; i < days; i++) {
        // standard coordinate system.
        //[NSBezierPath strokeRect: NSMakeRect( 20 * i, 0, 0.3, self.frame.size.height - headerHeight) ] ;
        // flipped coordinate system.
        
        [NSBezierPath setDefaultLineWidth:1];
        //[NSBezierPath strokeRect: NSMakeRect( 20 * i, headerHeight + 5, 0, self.frame.size.height) ] ;
        
        NSPoint startPoint = {20 * i, headerHeight + 5};
        NSPoint endPoint = {20 * i, self.frame.size.height};
        [NSBezierPath strokeLineFromPoint:startPoint toPoint:endPoint];
    }
    
    //NSLog(@"days: %ld", days);
}

- (void)drawDates {
    
    [[NSColor blackColor] set];

    
    
    for (int i = 0; i < days; i++) {
        
        [NSGraphicsContext saveGraphicsState];
        
        NSMutableDictionary *drawStringAttributes = [[NSMutableDictionary alloc] init];
        [drawStringAttributes setValue:[NSColor blackColor] forKey:NSForegroundColorAttributeName];
        //[drawStringAttributes setValue:[NSFont fontWithName:@"American Typewriter" size:11] forKey:NSFontAttributeName];
        [drawStringAttributes setValue:[NSFont boldSystemFontOfSize:11] forKey:NSFontAttributeName];
        
        // incrementer la date par 1 jour.
        NSDate *date = [self dateByAddingDays:i toDate:minDate];
       
        NSString *dateString = [NSString stringWithFormat:[PTCommon stringFromDate:date]];
        //NSSize stringSize = [budgetString sizeWithAttributes:drawStringAttributes];
        //NSLog(@"height: %f", stringSize.height);
        NSPoint centerPoint;
        //centerPoint.x = (self.frame.size.width / 2) - (stringSize.width / 2);
        centerPoint.x = (20 * i) - 6;
        // standard coordinate system.
        //centerPoint.y = self.frame.size.height - headerHeight;
        // flipped coordinate system.
        centerPoint.y = headerHeight;
        //centerPoint.y = self.frame.size.height / 2 - (stringSize.height / 2);
        
        // rotation du texte.
        NSAffineTransform* transform = [NSAffineTransform transform];
        [transform translateXBy:centerPoint.x yBy:centerPoint.y];
        //[transform rotateByDegrees:70];
        [transform rotateByDegrees:290];
        [transform translateXBy:-centerPoint.x yBy:-centerPoint.y];
        [transform concat];
        
        [dateString drawAtPoint:centerPoint withAttributes:drawStringAttributes];
        
        [NSGraphicsContext restoreGraphicsState];
    }
    
    

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

// inverser les coordonnées de l'axe y.
- (BOOL)isFlipped
{
    return YES;
}

// ajouter un nombre de jours à une date et retourne la nouvelle date.
- (NSDate *)dateByAddingDays:(NSInteger)daysToAdd toDate:(NSDate *)aDate {
    
    // set up date components
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:daysToAdd];
    
    // create a calendar
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *newDate = [gregorian dateByAddingComponents:components toDate:aDate options:0];
    
    return newDate;
}

@end
