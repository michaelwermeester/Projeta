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

        /*Project *prj = [[super value] representedObject];
        NSLog(@"test");
        [badgeButton setTitle:prj.projectTitle];*/

- (void)setBadgeCount:(NSString *)badgeCount {
    
    
    [badgeButton setTitle:badgeCount];
    
    
    
}



//This method calculates and returns the size of the badge for the row index passed to the method. If the
//row for the row index passed to the method does not have a badge, then NSZeroSize is returned.
/*- (NSSize)sizeOfBadgeAtRow:(NSInteger)rowIndex
{
	id rowItem = [self itemAtRow:rowIndex];
	
	//Make sure that the item has a badge
	if(![self itemHasBadge:rowItem]) {
		return NSZeroSize;
	}
	
	NSAttributedString *badgeAttrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", [self badgeValueForItem:rowItem]]
																		  attributes:[NSDictionary dictionaryWithObjectsAndKeys:BADGE_FONT, NSFontAttributeName, nil]];
	
	NSSize stringSize = [badgeAttrString size];
	
	//Calculate the width needed to display the text or the minimum width if it's smaller
	CGFloat width = stringSize.width+(2*BADGE_MARGIN);
	
	if(width<MIN_BADGE_WIDTH) {
		width = MIN_BADGE_WIDTH;
	}
	
	
	return NSMakeSize(width, BADGE_HEIGHT);
}*/

@end
