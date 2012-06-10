//
//  Client.h
//  Projeta
//
//  Created by Michael Wermeester on 2/1/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface Client : NSObject {
    NSString *address;
    NSNumber *clientId;
    NSString *clientName;
    NSString *comment;
    NSString *faxNumber;
    NSString *phoneNumber;
    User *primaryContactId;
    NSString *vatNumber;
}

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSNumber *clientId;
@property (nonatomic, copy) NSString *clientName;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *faxNumber;
@property (nonatomic, copy) NSString *phoneNumber;
@property (strong) User *primaryContactId;
@property (nonatomic, copy) NSString *vatNumber;

+ (Client *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSArray *)updateClientsKeys;

@end
