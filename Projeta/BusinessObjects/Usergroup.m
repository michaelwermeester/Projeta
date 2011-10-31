//
//  UserGroup.m
//  Projeta
//
//  Created by Michael Wermeester on 31/10/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "Usergroup.h"

@implementation Usergroup

@synthesize code = code;
@synthesize comment = comment;
@synthesize usergroupId = usergroupId;

+ (Usergroup *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    Usergroup *instance = [[Usergroup alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.code = [aDictionary objectForKey:@"code"];
    self.comment = [aDictionary objectForKey:@"comment"];
    self.usergroupId = [NSDecimalNumber decimalNumberWithString:(NSString *)[aDictionary objectForKey:@"usergroupId"]];
    
}

@end
