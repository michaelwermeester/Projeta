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
int max;
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
    }
    
    return self;
}

// drawing code. 
- (void)drawRect:(NSRect)dirtyRect
{
    
    Project *dummyProject = [[Project alloc] init];
    dummyProject.childProject = [[NSMutableArray alloc] init];
    [dummyProject.childProject addObject:project];
    
    totalProjects = [self countTotalProjects:dummyProject];
    
    minDate = project.startDate;
    maxDate = project.endDate;
    // 
    days = [self daysBetweenDates:minDate maxDate:maxDate];
    
    // s'il y a moins de jours que la vue est large, prendre la largeur de la vue comme largeur pour la grille.
    max = days;
    
    NSRect f = self.frame;
    if (self.frame.size.width / 20 > days) {
        max = self.frame.size.width;
        f.size.width = max;
    } else {
        f.size.width = days * 20;
    }
    
    // height of header (dates): 39
    f.size.height = totalProjects * 20 + headerHeight;
    
    if (f.size.height < parentViewSize.height) {
        f.size.height = parentViewSize.height - 60;
    }
    
    self.frame = f;

    
    counter = 1;
    
    [self drawDays];
    [self drawDates];
    [self drawProjectBar:dummyProject];
}

- (void)drawProjectBar:(OutlineCollection *)aProject {
    

    for (OutlineCollection *p in aProject.childObject) {
        
        NSInteger start = [self daysBetweenDates:minDate maxDate:p.startDate] * 20;
        NSInteger length = [self daysBetweenDates:p.startDate maxDate:p.endDate] * 20;

        // arrière-plan du rectangle en blanc.
        [[NSColor whiteColor] set];
        [NSBezierPath fillRect: NSMakeRect(start, headerHeight + counter * (20 + 4), length, 20 ) ] ;
        // dessiner le rectangle en bleu (avec une légère transparence).
        [[NSColor colorWithCalibratedRed:0.039f green:0.36f blue:0.56f alpha:0.5f] set];
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
    [drawStringAttributes setValue:[NSFont boldSystemFontOfSize:11] forKey:NSFontAttributeName];
    
    NSString *projTitleString = [NSString stringWithFormat:aProject.projectTitle];
    NSSize stringSize = [projTitleString sizeWithAttributes:drawStringAttributes];

    NSPoint centerPoint;

    // si longueur du texte plus grand que la barre, afficher le titre à côté de la barre.
    if (stringSize.width > length) {
        centerPoint.x = startPositionX + length + 5;
    } else {    // afficher le titre du projet dans la barre. 
        centerPoint.x = startPositionX + (length / 2) - (stringSize.width / 2);
    }

    // flipped coordinate system.
    centerPoint.y = positionY + 10 - stringSize.height / 2;
    
    [projTitleString drawAtPoint:centerPoint withAttributes:drawStringAttributes];

}

- (void)drawDays {
    
    [[NSColor darkGrayColor] set ] ;

    for (int i = 0; i < max; i++) {
        
        [NSBezierPath setDefaultLineWidth:1];
        
        NSPoint startPoint = {20 * i, headerHeight + 5};
        NSPoint endPoint = {20 * i, self.frame.size.height};
        [NSBezierPath strokeLineFromPoint:startPoint toPoint:endPoint];
    }
}

- (void)drawDates {
    
    [[NSColor blackColor] set];

    
    
    for (int i = 0; i < max; i++) {
        
        [NSGraphicsContext saveGraphicsState];
        
        NSMutableDictionary *drawStringAttributes = [[NSMutableDictionary alloc] init];
        [drawStringAttributes setValue:[NSColor blackColor] forKey:NSForegroundColorAttributeName];
        [drawStringAttributes setValue:[NSFont boldSystemFontOfSize:11] forKey:NSFontAttributeName];
        
        // incrementer la date par 1 jour.
        NSDate *date = [self dateByAddingDays:i toDate:minDate];
       
        NSString *dateString = [NSString stringWithFormat:[PTCommon stringFromDate:date]];
        
        NSPoint centerPoint;
        centerPoint.x = (20 * i) - 6;
        // flipped coordinate system.
        centerPoint.y = headerHeight;
        
        // rotation du texte.
        NSAffineTransform* transform = [NSAffineTransform transform];
        [transform translateXBy:centerPoint.x yBy:centerPoint.y];
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
    
     return [dt1 numberOfDaysUntil:dt2];
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
