//
//  PTUser.h
//  
//
//  Created by Michael Wermeester on 16/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PTUser : NSObject {
    NSArray *users;
}

@property (nonatomic, copy) NSArray *users;

+ (PTUser *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
+ (NSMutableArray *)setAttributesFromDictionary2:(NSDictionary *)aDictionary;

@end
