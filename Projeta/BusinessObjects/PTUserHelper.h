//
//  PTUser.h
//  
//
//  Created by Michael Wermeester on 16/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "User.h"

@interface PTUserHelper : NSObject {
    NSArray *users;
}

@property (nonatomic, copy) NSArray *users;

+ (PTUserHelper *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
+ (NSMutableArray *)setAttributesFromDictionary2:(NSDictionary *)aDictionary;

#pragma mark Web service methods
/*********************************************************************************************
* mainWindowController parameter is used for animating the main window's progress indicator. *
*********************************************************************************************/

// creates a new user in database.
+ (BOOL)createUser:(User *)theUser mainWindowController:(id)sender;
// updates username, first name and last name of a given user. 
+ (BOOL)updateUser:(User *)theUser mainWindowController:(id)sender;

@end
