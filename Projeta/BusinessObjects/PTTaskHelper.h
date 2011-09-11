//
//  PTTaskHelper.h
//  Projeta
//
//  Created by Michael Wermeester on 11/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTTaskHelper : NSObject {
    NSArray *task;
}

@property (nonatomic, copy) NSArray *task;

+ (PTTaskHelper *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary;

@end
