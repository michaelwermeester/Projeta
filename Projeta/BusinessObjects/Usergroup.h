//
//  UserGroup.h
//  Projeta
//
//  Created by Michael Wermeester on 31/10/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Usergroup : NSObject {
    NSString *code;
    NSString *comment;
    NSNumber *usergroupId;
}

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSNumber *usergroupId;

+ (Usergroup *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
