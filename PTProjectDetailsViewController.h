//
//  PTProjectDetailsViewController.h
//  Projeta
//
//  Created by Michael Wermeester on 2/4/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PTProjectViewController;
@class Project;

@interface PTProjectDetailsViewController : NSViewController {
    
    PTProjectViewController *projectViewController;
    //NSTreeController *prjTreeController;
    
    __weak NSButton *startDateRealCalendarButton;
    NSPopover *calendarPopover;
}

@property (strong) PTProjectViewController *projectViewController;
@property (assign) IBOutlet NSTreeController *prjTreeController;

@property (strong) Project *project;

@property (weak) IBOutlet NSButton *startDateRealCalendarButton;
@property (strong) IBOutlet NSPopover *calendarPopover;

- (IBAction)startDateRealCalendarButtonClicked:(id)sender;

@end
