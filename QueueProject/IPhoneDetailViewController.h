//
//  IPhoneDetailViewController.h
//  QueueProject
//
//  Created by Student on 5/3/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface IPhoneDetailViewController : UIViewController <UISplitViewControllerDelegate, MPMediaPickerControllerDelegate>

@property (strong, nonatomic) id detailItem;

- (void)configureView;
- (void) registerMediaPlayerNotifications;

@end
