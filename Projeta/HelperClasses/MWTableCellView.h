//
//  MWTableCellView.h
//  Projeta
//
//  Created by Michael Wermeester on 06/11/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWTableCellView : NSTableCellView

@property (strong) IBOutlet NSButton *badgeButton;

- (void)setBadgeCount:(NSString *)badgeCount;

@end
