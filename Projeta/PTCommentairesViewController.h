//
//  PTCommentairesViewController.h
//  Projeta
//
//  Created by Michael Wermeester on 4/8/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Webkit/Webkit.h>

@class Task;

@interface PTCommentairesViewController : NSViewController {
    __weak WebView *commentWebView;
}


@property (strong) Task *task;
@property (strong) NSMutableArray *arrComment;
@property (weak) IBOutlet WebView *commentWebView;

@end
