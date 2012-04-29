//
//  PTStatus.h
//  Projeta
//
//  Created by Michael Wermeester on 4/29/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTStatus : NSObject <NSCopying>

@property (nonatomic, copy) NSString *statusName;
@property (nonatomic, copy) NSNumber *statusId;

+ (PTStatus *)initWithId:(NSNumber *)anId name:(NSString *)aName;

// Required by NSCopying protocol.
- (id) copyWithZone:(NSZone *)zone;

- (NSArray *)statusIdKey;

@end
