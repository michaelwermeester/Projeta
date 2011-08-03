//
//  PTCommon.h
//  Projeta
//
//  Created by Michael Wermeester on 03/08/11.
//  Copyright 2011 Michael Wermeester. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTCommon : NSObject

// loads server URL from preferences file and returns it as NSURL
+ (NSURL*)serverURL;
// loads server URL from preferences file and returns it as NSString
+ (NSString*)serverURLString;

@end
