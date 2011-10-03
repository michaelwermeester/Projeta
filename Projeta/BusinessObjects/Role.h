//
//  Role.h
//  Projeta
//
//  Created by Michael Wermeester on 20/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Role : NSObject <NSCopying> {
    NSString *code;
    NSNumber *roleId;
}

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSNumber *roleId;

+ (Role *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

// Required by NSCopying protocol.
- (id) copyWithZone:(NSZone *)zone;

@end
