//
//  PTUser.m
//  
//
//  Created by Michael Wermeester on 16/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import "PTUser.h"

#import "User.h"

@implementation PTUser

@synthesize users = users;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (PTUser *)instanceFromDictionary:(NSDictionary *)aDictionary {

    PTUser *instance = [[PTUser alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}



- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (!aDictionary) {
        return;
    }


    NSArray *receivedUsers = [aDictionary objectForKey:@"users"];
    if (receivedUsers) {

        NSMutableArray *parsedUsers = [NSMutableArray arrayWithCapacity:[receivedUsers count]];
        for (id item in receivedUsers) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedUsers addObject:[User instanceFromDictionary:item]];
            }
        }

        self.users = parsedUsers;

    }

}

+ (NSMutableArray *)setAttributesFromDictionary2:(NSDictionary *)aDictionary {
    
    if (!aDictionary) {
        return nil;
    }
    
    
    NSArray *receivedUsers = [aDictionary objectForKey:@"users"];
    if (receivedUsers) {
        
        NSMutableArray *parsedUsers = [NSMutableArray arrayWithCapacity:[receivedUsers count]];
        for (id item in receivedUsers) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedUsers addObject:[User instanceFromDictionary:item]];
            }
        }
        
        //self.users = parsedUsers;
        return parsedUsers;
    }
    
    return nil;
}

@end
