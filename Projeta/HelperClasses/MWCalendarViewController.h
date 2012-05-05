//
//  MWCalendarViewController.h
//  Projeta
//
//  Created by Michael Wermeester on 5/5/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MWCalendarViewController : NSViewController {
    __weak NSDatePicker *datePicker;
}

// DatePicker de la view.
@property (weak) IBOutlet NSDatePicker *datePicker;

@end
