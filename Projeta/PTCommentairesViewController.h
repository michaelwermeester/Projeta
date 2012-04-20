//
//  PTCommentairesViewController.h
//  Projeta
//
//  Created by Michael Wermeester on 4/8/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Task;

@interface PTCommentairesViewController : NSViewController {
}


@property (strong) Task *task;
@property (strong) NSMutableArray *arrComment;

@end
