//
//  PTProjectDetailsViewController.m
//  Projeta
//
//  Created by Michael Wermeester on 2/4/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "PTProjectDetailsViewController.h"

@implementation PTProjectDetailsViewController

@synthesize projectViewController;
@synthesize prjTreeController;

@synthesize project;
@synthesize startDateRealCalendarButton;
@synthesize calendarPopover;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"PTProjectDetailsView" bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (IBAction)startDateRealCalendarButtonClicked:(id)sender {
    
    // si bouton clicked...
    if (self.startDateRealCalendarButton.intValue == 1) {
        [self.calendarPopover showRelativeToRect:[startDateRealCalendarButton bounds]
                                  ofView:startDateRealCalendarButton
                           preferredEdge:NSMaxYEdge];
    } else {
        [self.calendarPopover close];
    }

}

@end
