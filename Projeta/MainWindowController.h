//
//  MainWindow.h
//  Projeta
//
//  Created by Michael Wermeester on 17/06/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PXSourceList.h"

@interface MainWindowController : NSWindowController <NSWindowDelegate, PXSourceListDataSource, PXSourceListDelegate> {
    
    NSMutableArray *sourceListItems;
}

@property (strong) IBOutlet PXSourceList *sourceList;

- (void)initializeSidebar;

@end
