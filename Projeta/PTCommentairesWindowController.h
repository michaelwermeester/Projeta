//
//  PTCommentairesWindowController.h
//  Projeta
//
//  Created by Michael Wermeester on 4/9/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PTCommentairesViewController;
@class Task;

@interface PTCommentairesWindowController : NSWindowController {
    __weak NSView *commentsView;
    
}

@property (strong) Task *task;

@property (strong) PTCommentairesViewController *commentViewController;

@property (weak) IBOutlet NSView *commentsView;

@end
