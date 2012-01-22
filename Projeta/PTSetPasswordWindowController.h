//
//  PTSetPasswordWindowController.h
//  Projeta
//
//  Created by Michael Wermeester on 1/20/12.
//  Copyright (c) 2012 Michael Wermeester. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PTSetPasswordWindowController : NSWindowController {

    __weak NSImageView *password1InvalidImageView;
    __weak NSImageView *password2InvalidImageView;
    __weak NSSecureTextField *password1TextField;
    __weak NSSecureTextField *password2TextField;
    __weak NSProgressIndicator *updatePasswordProgressIndicator;
    NSNumber *userId;
}


- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)okButtonClicked:(id)sender;

@property (weak) IBOutlet NSImageView *password1InvalidImageView;
@property (weak) IBOutlet NSImageView *password2InvalidImageView;
@property (weak) IBOutlet NSSecureTextField *password1TextField;
@property (weak) IBOutlet NSSecureTextField *password2TextField;
@property (weak) IBOutlet NSProgressIndicator *updatePasswordProgressIndicator;

@property (nonatomic, copy) NSNumber *userId;

// closes this sheet.
- (void)endSheet;

// checks if both passwords are the same.
- (Boolean)arePasswordsEqual;

- (void)updateFailed:(NSError *)failure;
- (void)updateFinished:(NSMutableData *)data;

@end
