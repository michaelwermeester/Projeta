//
//  Comment.h
//  Projeta
//
//  Created by Michael Wermeester on 4/8/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface PTComment : NSObject <NSCopying>


@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSNumber *commentId;
@property (nonatomic, copy) NSDate *dateCreated;
@property (nonatomic, retain) User *userCreated;

+ (PTComment *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

// Required by NSCopying protocol.
- (id) copyWithZone:(NSZone *)zone;

@end
