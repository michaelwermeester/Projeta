//
//  PTCommentHelper.m
//  Projeta
//
//  Created by Michael Wermeester on 4/9/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import "PTComment.h"
#import "PTCommentHelper.h"

@implementation PTCommentHelper

@synthesize comment = comment;

+ (PTCommentHelper *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    PTCommentHelper *instance = [[PTCommentHelper alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    
    NSArray *receivedComment= [aDictionary objectForKey:@"comment"];
    if ([receivedComment isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *parsedComment = [NSMutableArray arrayWithCapacity:[receivedComment count]];
        for (NSDictionary *item in receivedComment) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedComment addObject:[PTComment instanceFromDictionary:item]];
            }
        }
        
        self.comment = parsedComment;
    }
}

+ (NSMutableArray *)setAttributesFromJSONDictionary:(NSDictionary *)aDictionary {
    
    if (!aDictionary) {
        return nil;
    }
    
    // if dictionary contains array of dictionaries
    if ([[aDictionary objectForKey:@"comment"] isKindOfClass:[NSArray class]]) {
        
        NSArray *receivedComments = [aDictionary objectForKey:@"comment"];
        if (receivedComments) {
            
            NSMutableArray *parsedComments = [NSMutableArray arrayWithCapacity:[receivedComments count]];
            
            for (id item in receivedComments) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedComments addObject:[PTComment instanceFromDictionary:item]];
                }
            }
            
            return parsedComments;
        }
    }
    // if dictionary contains just a dictionary
    else if ([[aDictionary objectForKey:@"comment"] isKindOfClass:[NSDictionary class]]) {
        
        NSMutableArray *parsedComments = [NSMutableArray arrayWithCapacity:1];
        
        [parsedComments addObject:[PTComment instanceFromDictionary:[aDictionary objectForKey:@"comment"]]];
        
        return parsedComments;
    }
    
    return nil;
}

@end
