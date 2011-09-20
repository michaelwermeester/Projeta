//
//  PTRoleHelper.h
//  Projeta
//
//  Created by Michael Wermeester on 20/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTRoleHelper : NSObject {
    NSArray *role;
}

@property (nonatomic, copy) NSArray *role;

+ (PTRoleHelper *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary;

@end
