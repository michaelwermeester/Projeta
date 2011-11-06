//
//  OutlineCollection.m
//  Projeta
//
//  Created by Michael Wermeester on 06/11/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import "OutlineCollection.h"

@implementation OutlineCollection

@synthesize childObject;
@synthesize objectTitle;

- (BOOL)isLeaf {
    if ([childObject count] > 0)
        return NO;
    else
        return YES;
}

/*- (id)copyWithZone:(NSZone *)zone {
    
    OutlineCollection *copy = [[OutlineCollection alloc] init];
    
    copy.objectTitle = [objectTitle copyWithZone:zone];
    
    return copy;
}*/

@end
