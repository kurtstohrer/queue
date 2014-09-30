//
//  DevicesConnectedViewController.h
//  QueueProject
//
//  Created by Student on 5/19/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface DevicesConnectedViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtMessage;
@property (weak, nonatomic) IBOutlet UITextView *tvChat;

- (IBAction)sendMessage:(id)sender;
- (IBAction)cancelMessage:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

-(void)sendMyMessage;
-(void)didReceiveDataWithNotification:(NSNotification *)notification;
@end
