//
//  Comment.m
//  Projeta
//
//  Created by Michael Wermeester on 4/8/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "PTComment.h"
#import "PTCommon.h"
#import "User.h"

@implementation PTComment

@synthesize comment = comment;
@synthesize commentId = commentId;
@synthesize dateCreated = dateCreated;
@synthesize userCreated = userCreated;

+ (PTComment *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    PTComment *instance = [[PTComment alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.dateCreated = [PTCommon dateFromJSONString:[aDictionary objectForKey:@"dateCreated"]];
    self.comment = [aDictionary objectForKey:@"comment"];
    self.commentId = [NSDecimalNumber decimalNumberWithString:(NSString *)[aDictionary objectForKey:@"commentId"]];
    
    self.userCreated = [User instanceFromDictionary:[aDictionary objectForKey:@"userCreated"]];
}

// Required by NSCopying protocol.
- (id) copyWithZone:(NSZone *)zone {
    
    PTComment *copy = [[PTComment alloc] init];
    
    copy.comment = [comment copyWithZone:zone];
    copy.commentId = [commentId copyWithZone:zone];
    copy.dateCreated = [dateCreated copyWithZone:zone];
    copy.userCreated = [userCreated copyWithZone:zone];
    
    return copy;
}



- (NSArray *)createCommentKeys
{
    NSArray *retArr = [[NSArray alloc] initWithObjects: @"comment", nil];
    
    return retArr;
}

@end
