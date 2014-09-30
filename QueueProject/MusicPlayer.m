//
//  MusicPlayer.m
//  QueueProject
//
//  Created by Student on 4/23/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import "MusicPlayer.h"

@implementation MusicPlayer


+(id)sharedStore
{
    static MusicPlayer *sharedStore = nil;
    
    //Do I need to create a sharedStore?
    if(!sharedStore)
    {
        sharedStore = [[self alloc] initPrivate];
        
    }
    
    return sharedStore;
}

//If someone calls [[DataStore alloc] init], let them know you should only have one instance of this class
-(instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[DataStore sharedStore]!" userInfo:nil];
}

//Here is the real (secret) initializer
-(instancetype)initPrivate
{
    self = [super init];
    
    if(self)
    {
        self.allItems = [[NSMutableArray alloc] init];
        self.queuedSongs = [[NSMutableArray alloc] init];
        self.myQuery = [[MPMediaQuery alloc] init];
    }
    
    return self;
}

//method to set up query
-(void)setUpQuery:(MPMediaQuery*)query
{
    self.myQuery = query;
    NSArray *itemsFromGenericQuery = [self.myQuery items];
    self.allItems = [NSMutableArray arrayWithArray:itemsFromGenericQuery];
    
}

//setting up a method to make a MPMusicPlayerController
-(void)setUpMusicPlayerController:(MPMusicPlayerController *)mp
{
    self.musicPlayer = mp;
}

//method to add a song to the queue
-(void)queueASong:(MPMediaItem*)song
{
    //in here we want to add each individual song to our array of mpmedia items then add those to a media collection in which the music player will play from
    if([self.queuedSongs count] == 0)
    {
        [self.queuedSongs addObject:song];
        self.queuedCollection = [MPMediaItemCollection collectionWithItems:self.queuedSongs];
        [self.musicPlayer setQueueWithItemCollection:self.queuedCollection];
        self.musicPlayer.nowPlayingItem = song;
    }
    else
    {

        [self.queuedSongs addObject:song];
        self.queuedCollection = [MPMediaItemCollection collectionWithItems:self.queuedSongs];
        [self.musicPlayer setQueueWithItemCollection:self.queuedCollection];
    }
    //Eventually I think we want to create a seperate collections/query of our queued songs to play from.
}

//This will check when the user hits the next song button to see if there is in fact another song in the queue to play
-(BOOL)checkIfEndOfQueue
{
    //If there are more than 1 songs in the queue then you know you can skip to the next song. (Must re order queue)
    if([self.queuedSongs count] > 1)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

//called when the filter for searching for songs is changed so that it is reordered alphabetically
-(void)changedFilter:(int)filterType
{
    /* ATTEMPT TO GET THE ARTIST AND ALBUM TAB TO ORDER ALPHABETICALLY
    //order by song title for title and queue tabs
    if(filterType == 0 || filterType == 3)
    {
        MPMediaQuery *query = [MPMediaQuery songsQuery];
        query.groupingType = MPMediaGroupingTitle;
         [self.musicPlayer setQueueWithQuery:query];
    }
    //order by artist for srtist tab
    else if (filterType == 1)
    {
        MPMediaQuery *query = [MPMediaQuery artistsQuery];
        query.groupingType = MPMediaGroupingArtist;
         [self.musicPlayer setQueueWithQuery:query];
    }
    //otherwise order by album title
    else
    {
        MPMediaQuery *query = [MPMediaQuery albumsQuery];
        query.groupingType = MPMediaGroupingAlbum;
         [self.musicPlayer setQueueWithQuery:query];
    }*/
    
   
}

//method to reorderQueue when user hits the skip button
-(void)reorderQueueOnSkip
{
    [self.queuedSongs removeObjectAtIndex:0];
    self.queuedCollection = [MPMediaItemCollection collectionWithItems:self.queuedSongs];
    [self.musicPlayer setQueueWithItemCollection:self.queuedCollection];
}

//method for reordering queue when a song is deleted from the queue
-(void)reorderQueueOnDelete:(NSInteger)spot
{
    //if the currently playing song is set in the queue we have to pause after reordering our queue
    if(spot == 0)
    {
        //make sure that there is at least 2 songs before reordering
        if([self.queuedSongs count] == 1)
        {
            [self.queuedSongs removeObjectAtIndex:spot];
            [self.musicPlayer pause];
        }
        else
        {
            [self.queuedSongs removeObjectAtIndex:spot];
            self.queuedCollection = [MPMediaItemCollection collectionWithItems:self.queuedSongs];
            [self.musicPlayer setQueueWithItemCollection:self.queuedCollection];
            [self.musicPlayer pause];
        }

    }
    //if its not the current song playing thats being removed simply remove and reorder music player queue
    else
    {
        [self.queuedSongs removeObjectAtIndex:spot];
        self.queuedCollection = [MPMediaItemCollection collectionWithItems:self.queuedSongs];
        [self.musicPlayer setQueueWithItemCollection:self.queuedCollection];
    }
}
@end
