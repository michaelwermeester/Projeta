//
//  NSDate+MWExtensions.h
//  Projeta
//
//  Created by Michael Wermeester on 5/16/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// Catégorie pour la classe NSDate.
@interface NSDate (MWExtensions)

// retourne le nombre de jours entre 2 dates.
- (NSInteger)numberOfDaysUntil:(NSDate *)aDate;

@end