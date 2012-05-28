//
//  PTStatus.h
//  Projeta
//
//  Created by Michael Wermeester on 4/29/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTStatus : NSObject <NSCopying>

// propriétés.
@property (nonatomic, copy) NSString *statusName;
@property (nonatomic, copy) NSNumber *statusId;

// constructeur qui crée un nouveau statut avec une ID et un nom.
+ (PTStatus *)initWithId:(NSNumber *)anId name:(NSString *)aName;

// Requis par protocole NSCopying.
- (id) copyWithZone:(NSZone *)zone;

- (NSArray *)statusIdKey;

@end
