//
//  PTClientDetailsWindowController.h
//  Projeta
//
//  Created by Michael Wermeester on 2/1/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Client;

@interface PTClientDetailsWindowController : NSWindowController

@property (strong) Client *client;

@property (readonly) NSString *windowTitle;

@end
