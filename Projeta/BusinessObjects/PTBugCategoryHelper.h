//
//  PTUserGroupHelper.h
//  Projeta
//
//  Created by Michael Wermeester on 31/10/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BugCategory;

@interface PTBugCategoryHelper : NSObject {
    NSArray *bugCategory;
}

@property (nonatomic, copy) NSArray *bugCategory;

+ (PTBugCategoryHelper *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary;

+ (void)serverBugcategoriesToArray:(NSString *)urlString successBlock:(void (^)(NSMutableArray*))successBlock failureBlock:(void(^)(NSError *))failureBlock;

+ (void)bugcategories:(void(^)(NSMutableArray *))successBlock failureBlock:(void(^)(NSError *))failureBlock;

@end
