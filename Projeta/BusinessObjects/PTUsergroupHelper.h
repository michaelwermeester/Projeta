//
//  PTUserGroupHelper.h
//  Projeta
//
//  Created by Michael Wermeester on 31/10/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTUsergroupHelper : NSObject {
    NSArray *usergroup;
}

@property (nonatomic, copy) NSArray *usergroup;

+ (PTUsergroupHelper *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary;

@end
