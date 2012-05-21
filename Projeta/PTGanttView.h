//
//  PTGanttView.h
//  Projeta
//
//  Created by Michael Wermeester on 5/5/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Project;

@interface PTGanttView : NSView {
    
}

@property (strong) Project *project;

@property (nonatomic, copy) NSDate *minDate;
@property (nonatomic, copy) NSDate *maxDate;

@property NSSize parentViewSize;

// ajouter un nombre de jours à une date et retourne la nouvelle date.
- (NSDate *)dateByAddingDays:(NSInteger)daysToAdd toDate:(NSDate *)aDate;

- (void)drawProjectNames:(Project *)aProject 
           startPosition:(NSInteger)startPositionX 
                  length:(NSInteger)length
               positionY:(NSInteger)positionY;

@end
