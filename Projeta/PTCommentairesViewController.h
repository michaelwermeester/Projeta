//
//  PTCommentairesViewController.h
//  Projeta
//
//  Created by Michael Wermeester on 4/8/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Webkit/Webkit.h>

@class MainWindowController;
@class PTComment;
@class Task;

@interface PTCommentairesViewController : NSViewController {
    __weak WebView *commentWebView;
    __unsafe_unretained NSTextView *commentTextView;
    __weak NSButton *sendCommentButton;
}


@property (strong) PTComment *comment;

// parent window controller.
@property (strong) NSWindowController *parentWindowController;
// reference to the (parent) MainWindowController
@property (assign) MainWindowController *mainWindowController;

@property (strong) Task *task;
@property (strong) NSMutableArray *arrComment;
@property (weak) IBOutlet WebView *commentWebView;
@property (unsafe_unretained) IBOutlet NSTextView *commentTextView;
@property (weak) IBOutlet NSButton *sendCommentButton;
- (IBAction)sendCommentButtonClicked:(id)sender;

@end
