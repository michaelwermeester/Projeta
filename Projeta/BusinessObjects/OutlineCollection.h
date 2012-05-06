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

@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *endDate;

// test - 06 May 2012
@property (nonatomic, copy) NSString *projectTitle;
@property (nonatomic, copy) NSString *projectDescription;
@property (nonatomic, assign) BOOL flagPublic;
@property (nonatomic, copy) NSDate *startDateReal;
@property (nonatomic, copy) NSDate *endDateReal;
@property (nonatomic, assign) BOOL completed;
@property (nonatomic, copy) NSString *projectStatus;
@property (nonatomic, copy) NSNumber *projectPercentage;
@property (readonly) NSString *percentageCompleteString;
@property (nonatomic, copy) NSNumber *projectId;
@property (strong) NSMutableArray *childProject;


- (BOOL)isLeaf;

// Required by NSCopying protocol.
//- (id) copyWithZone:(NSZone *)zone;

@end
