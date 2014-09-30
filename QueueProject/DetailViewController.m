//
//  DetailViewController.m
//  QueueProject
//
//  Created by Student on 4/23/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import "DetailViewController.h"
#import "MasterViewController.h"
#import "MusicPlayer.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

//properties for our detail view attributes
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (strong, nonatomic) IBOutlet UIButton *helpButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;



- (void)configureView;
- (void) registerMediaPlayerNotifications;

@end

@implementation DetailViewController


- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem)
    {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil)
    {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem)
    {
        [self interFaceSetUp];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set up our music player controller
    self.musicPlayer = [MusicPlayer sharedStore].musicPlayer;
    
    //set up the look of our music player
    [self interFaceSetUp];
    [self registerMediaPlayerNotifications];
    
    
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

//method for detecting when volume slider is moved
- (IBAction)volumeChanged:(id)sender
{
    [self.musicPlayer setVolume:[self.volumeSlider value]];
}

//This is now a restart button not a previous song button
- (IBAction)previousSong:(id)sender
{
    //if the queued array has something in is, replay the current song
    if([[MusicPlayer sharedStore].queuedSongs count] != 0)
    {
        [self.musicPlayer skipToBeginning];
    }
}

//method for pressing the play/pause button
- (IBAction)playPause:(id)sender
{
    if([[MusicPlayer sharedStore].queuedSongs count] != 0)
    {
        //when the button is pressed pause the music if it was playing, and play the music if it was paused
        if([self.musicPlayer playbackState] == MPMusicPlaybackStatePlaying)
        {
            [self.musicPlayer pause];
            [self.playPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
           
        }
        else
        {
            [self.musicPlayer play];
             [self.playPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        }
    }
}

//method for pressing the next song button
- (IBAction)nextSong:(id)sender
{
    //Do nothing if you click next when nothing is queued
    if([[MusicPlayer sharedStore].queuedSongs count] != 0)
    {
        // it is not the end of the queue then skip to the next song
        if([[MusicPlayer sharedStore] checkIfEndOfQueue])
        {
            //skip to next song and reorder queue
            [self.musicPlayer skipToNextItem];
            [[MusicPlayer sharedStore] reorderQueueOnSkip];
            
            //reload the proper interface and play next song
            [self interFaceSetUp];
            
            //notification to our MVC so that we can reload its table
            NSNotification *notif = [NSNotification notificationWithName:@"reloadRequest" object:self];
            [[NSNotificationCenter defaultCenter] postNotification:notif];
            
            [self.musicPlayer play];
            [self.playPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        }
    }
    
}

//method for registering changes to any of the media player's main items
- (void)registerMediaPlayerNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    //fired when the current playing song is changed
    [notificationCenter addObserver: self
                           selector: @selector (handle_NowPlayingItemChanged:)
                               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object: self.musicPlayer];
    
    //fired when the current state of the music player changes (paused,playing,stopped)
    [notificationCenter addObserver: self
                           selector: @selector (handle_PlaybackStateChanged:)
                               name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object: self.musicPlayer];
    
    //fired when the volume slider changes
    [notificationCenter addObserver: self
                           selector: @selector (handle_VolumeChanged:)
                               name: MPMusicPlayerControllerVolumeDidChangeNotification
                             object: self.musicPlayer];
    
    [self.musicPlayer beginGeneratingPlaybackNotifications];
}

//handles changes to when the now playing item is changed
- (void) handle_NowPlayingItemChanged: (id) notification
{
    //handles the changing of songs
    if([[MusicPlayer sharedStore].queuedSongs count] == 0)
    {
        //do nothing
    }
    else
    {
        MPMediaItem *current = self.musicPlayer.nowPlayingItem;
        
        if(current == [MusicPlayer sharedStore].queuedSongs[0])
        {
            //do nothing
        }
        else
        {
            [[MusicPlayer sharedStore] reorderQueueOnSkip];
            [self interFaceSetUp];
            NSNotification *notif = [NSNotification notificationWithName:@"reloadRequest" object:self];
            [[NSNotificationCenter defaultCenter] postNotification:notif];
        }
    }
}

//handles changes to the current music playback state
- (void) handle_PlaybackStateChanged: (id) notification
{
    /*
    MPMusicPlaybackState playbackState = [self.musicPlayer playbackState];
    
    //if the current state is pause, display a play button
    if (playbackState == MPMusicPlaybackStatePaused)
    {
        [self.playPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        
    }
    //if the current state is playing display a pause button
    else if (playbackState == MPMusicPlaybackStatePlaying)
    {
        [self.playPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        
    }
    //if the current state is stop display a play button and also stop the music player from playing
    else if (playbackState == MPMusicPlaybackStateStopped)
    {
        
        [self.playPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.musicPlayer stop];
    }*/

}

//handles changes to the volume slider (Might need to be taken out in ios7)
- (void) handle_VolumeChanged: (id) notification
{
    [self.volumeSlider setValue:[self.musicPlayer volume]];
}

//helper method to set up the look of the music player interface
-(void)interFaceSetUp
{
    //[self.volumeSlider setValue:[self.musicPlayer volume]];
    //self.musicPlayer = [MusicPlayer sharedStore].musicPlayer;
    
    //figure out whether to display a pause or play button based on if music is currently playing or not
    if([self.musicPlayer playbackState] == MPMusicPlaybackStatePlaying)
    {
        [self.playPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
    else
    {
        [self.playPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    
    //Code for displaying the current songs artwork song title artist and album
    MPMediaItem *currentItem;
    if([[MusicPlayer sharedStore].queuedSongs count] == 0)
    {
        currentItem = nil;
    }
    else
    {
        currentItem = [MusicPlayer sharedStore].queuedSongs[0];
    }
    
    UIImage *artworkBlankImage = [UIImage imageNamed:@"noArtworkImage.png"];
    UIImage *artWorkImage = NULL;
    MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
    
    //set up the artwork image for current song (default is no artwork image)
    if (artwork != nil)
    {
        artWorkImage = [artwork imageWithSize: CGSizeMake (400, 400)];
    }
    
    //if the song has artwork then display that, otherwise display default music pic
    if(artWorkImage)
    {
        [self.artworkImageView setImage:artWorkImage];
    }
    else
    {
        [self.artworkImageView setImage:artworkBlankImage];
    }
    
    
    //set up the title label for current song
    NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    if (titleString)
    {
        self.titleLabel.text = [NSString stringWithFormat:@"Title: %@",titleString];
    }
    else
    {
        self.titleLabel.text = @"Title: Unknown title";
    }
    
    //set up the artist label for current song
    NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    if (artistString)
    {
        self.artistLabel.text = [NSString stringWithFormat:@"Artist: %@",artistString];
    }
    else
    {
        self.artistLabel.text = @"Artist: Unknown artist";
    }
    
    //set up the album label for current song
    NSString *albumString = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    if (albumString)
    {
        self.albumLabel.text = [NSString stringWithFormat:@"Album: %@",albumString];
    }
    else
    {
        self.albumLabel.text = @"Album: Unknown album";
    }
    
}

//button to connect to a host's library, or make your library the host
- (IBAction)connectToHost:(id)sender
{
    
}


@end
