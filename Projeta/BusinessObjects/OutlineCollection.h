//
//  OutlineCollection.h
//  Projeta
//
//  Created by Michael Wermeester on 06/11/11.
//  Copyright (c) 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OutlineCollection : NSObject /*<NSCopying>*/ {

    NSMutableArray *childObject;
    NSString *objectTitle;
}

@property (strong) NSMutableArray *childObject;
@property (nonatomic, copy) NSString *objectTitle;

- (BOOL)isLeaf;

// Required by NSCopying protocol.
//- (id) copyWithZone:(NSZone *)zone;

@end
