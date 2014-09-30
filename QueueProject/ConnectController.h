//
//  ConnectController.h
//  QueueProject
//
//  Created by Student on 5/16/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface ConnectController : UIViewController <MCBrowserViewControllerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UISwitch *swVisible;
@property (weak, nonatomic) IBOutlet UITableView *tblConnectedDevices;
@property (weak, nonatomic) IBOutlet UIButton *btnDisconnect;

- (IBAction)toggleVisibility:(id)sender;
- (IBAction)browseForDevices:(id)sender;
- (IBAction)disconnect:(id)sender;

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification;
@property (nonatomic, strong) NSMutableArray *arrConnectedDevices;

@end
