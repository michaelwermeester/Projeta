//
//  PTUsersView.h
//  Projeta
//
//  Created by Michael Wermeester on 04/07/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ASIHTTPRequest.h"

@interface PTUserManagementViewController : NSViewController {
    NSArray *arrUsr;
}

@property (nonatomic, copy) NSArray *arrUsr;

@end
