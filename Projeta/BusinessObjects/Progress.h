//
//  Progress.h
//  Projeta
//
//  Created by Michael Wermeester on 4/28/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTStatus;

@interface Progress : NSObject

@property (nonatomic, copy) NSString *progressComment;
@property (nonatomic, copy) NSNumber *percentageComplete;
@property (nonatomic, copy) NSNumber *statusId;
@property (nonatomic, retain) PTStatus *status;

- (NSArray *)createProgressKeys;

@end
