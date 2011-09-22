//
//  PTUser.h
//  
//
//  Created by Michael Wermeester on 16/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "User.h"

@interface PTUserHelper : NSObject {
    NSArray *users;
}

@property (nonatomic, copy) NSArray *users;

+ (PTUserHelper *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
+ (NSMutableArray *)setAttributesFromDictionary2:(NSDictionary *)aDictionary;

@end
