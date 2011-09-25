//
//  Role.m
//  Projeta
//
//  Created by Michael Wermeester on 20/09/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "Role.h"

@implementation Role

@synthesize code = code;
@synthesize roleId = roleId;

+ (Role *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    Role *instance = [[Role alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.code = [aDictionary objectForKey:@"code"];
    self.roleId = [NSDecimalNumber decimalNumberWithString:(NSString *)[aDictionary objectForKey:@"roleId"]];
    
}

@end