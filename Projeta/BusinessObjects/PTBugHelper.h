//
//  PTBugHelper.h
//  Projeta
//
//  Created by Michael Wermeester on 4/21/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTBugHelper : NSObject

@property (nonatomic, copy) NSArray *bug;

+ (PTBugHelper *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary;

+ (BOOL)createBug:(Bug *)theBug successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)())failureBlock_ mainWindowController:(id)sender;
+ (BOOL)updateBug:(Bug *)theBug successBlock:(void(^)(NSMutableData *))successBlock_ failureBlock:(void(^)())failureBlock_ mainWindowController:(id)sender;

@end
