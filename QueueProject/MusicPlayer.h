//
//  MusicPlayer.h
//  QueueProject
//
//  Created by Student on 4/23/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MusicPlayer : NSObject

//property for holding all songs in a device's music library
@property(nonatomic) NSMutableArray *allItems;
@property(nonatomic) NSMutableArray *queuedSongs;
@property(nonatomic) MPMediaItemCollection *queuedCollection;
@property(nonatomic) MPMediaQuery *myQuery;
@property(nonatomic, retain) MPMusicPlayerController *musicPlayer;
@property (strong, nonatomic) id iPhoneDetailItem;

//replicating the singleton class from RIT maps project
+ (instancetype)sharedStore;
-(void)setUpQuery:(MPMediaQuery*)query;
-(void)setUpMusicPlayerController:(MPMusicPlayerController *)mp;
-(void)queueASong:(MPMediaItem *)song;
-(BOOL)checkIfEndOfQueue;
-(void)changedFilter:(int)filterType;
-(void)reorderQueueOnSkip;
-(void)reorderQueueOnDelete:(NSInteger)spot;


@end
