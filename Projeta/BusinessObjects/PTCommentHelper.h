//
//  PTCommentHelper.h
//  Projeta
//
//  Created by Michael Wermeester on 4/9/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Task;
@class Bug;

@interface PTCommentHelper : NSObject

@property (nonatomic, copy) NSArray *comment;

+ (PTCommentHelper *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary;

+ (BOOL)createComment:(PTComment *)theComment forProject:(Project *)aProject successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)())failureBlock_ mainWindowController:(id)sender;
+ (BOOL)createComment:(PTComment *)theComment forTask:(Task *)aTask successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)())failureBlock_ mainWindowController:(id)sender;
+ (BOOL)createComment:(PTComment *)theComment forBug:(Bug *)aBug successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)())failureBlock_ mainWindowController:(id)sender;

@end
