//
//  User.h
//  
//
//  Created by Michael Wermeester on 16/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface User : NSObject {
    NSString *password;
    NSNumber *userId;
    NSString *username;
}

@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *username;

+ (User *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
