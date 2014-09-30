//
//  DetailViewController.h
//  QueueProject
//
//  Created by Student on 4/23/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, MPMediaPickerControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property(retain,nonatomic)MPMusicPlayerController *musicPlayer;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

-(void)interFaceSetUp;

@end
