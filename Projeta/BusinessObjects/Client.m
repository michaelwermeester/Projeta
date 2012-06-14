//
//  Client.m
//  Projeta
//
//  Created by Michael Wermeester on 2/1/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "Client.h"
#import "User.h"

@implementation Client

@synthesize address = address;
@synthesize clientId = clientId;
@synthesize clientName = clientName;
@synthesize comment = comment;
@synthesize faxNumber = faxNumber;
@synthesize phoneNumber = phoneNumber;
@synthesize primaryContactId = primaryContactId;
@synthesize vatNumber = vatNumber;


// Override isEqual method.
- (BOOL)isEqual:(id)anObject {
    
    if (self == anObject) {
        return YES;
    } else if (!anObject || ![anObject isKindOfClass:[self class]]) {
        return NO;
    } // compare if id and code are equal.
    else if ([[self clientId] isEqual:[(Client *)anObject clientId]] && [[self clientName] isEqual:[(Client *)anObject clientName]]) {
        return YES;
    } else {
        return NO;
    }
}

// Permet de créer un objet Client à partir d'un dictionnaire. 
+ (Client *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    Client *instance = [[Client alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

// initialise les propriétés à partir du dictionnaire. 
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.address = [aDictionary objectForKey:@"address"];
    self.clientId = [NSDecimalNumber decimalNumberWithString:(NSString *)[aDictionary objectForKey:@"clientId"]];
    self.clientName = [aDictionary objectForKey:@"clientName"];
    self.comment = [aDictionary objectForKey:@"comment"];
    self.faxNumber = [aDictionary objectForKey:@"faxNumber"];
    self.phoneNumber = [aDictionary objectForKey:@"phoneNumber"];
    self.primaryContactId = [User instanceFromDictionary:[aDictionary objectForKey:@"primaryContactId"]];
    self.vatNumber = [aDictionary objectForKey:@"vatNumber"];
    
}

// keys needed for updating clients.
- (NSArray *)updateClientsKeys {
    
    NSArray *retArr = [[NSArray alloc] initWithObjects: @"clientName", @"clientId", nil];
    
    return retArr;
}

@end
