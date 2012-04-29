//
//  PTProgressHelper.h
//  Projeta
//
//  Created by Michael Wermeester on 4/29/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Progress;
@class Task;

@interface PTProgressHelper : NSObject

+ (BOOL)createProgress:(Progress *)theProgress forTask:(Task *)aTask successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)())failureBlock_ mainWindowController:(id)sender;

@end
