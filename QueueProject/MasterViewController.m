//
//  MasterViewController.m
//  QueueProject
//
//  Created by Student on 4/23/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "IPhoneDetailViewController.h"
#import "MusicPlayer.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController
{
    //Ivars
    int songFilterType;//keeps track of what the segmented controller is on
    MPMediaPropertyPredicate *predicate; //predicate for searching song names
    UIImage *playImage;
    UIImage *queueImage;
    UIImage *deleteImage;
    NSIndexPath *queueIndex;
    UITableViewCell *buttonCell;
    NSIndexPath *deleteSpot;
    NSInteger qr;
}

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    
    //set up our segmented conroller(default will be on song title)
    songFilterType = 0;
    self.searchBar.placeholder = @"Search song title";
    qr = -1;
    
    
    //Make the two buttons
    self.playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playImage = [UIImage imageNamed:@"play2"];
    deleteImage = [UIImage imageNamed:@"delete"];

	// Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    //self.iPhonedetailViewController = [[IPhoneDetailViewController alloc]init];
    self.iPhonedetailViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"Detail"];
    
    //set up a notification so we can reload masterView from DetailView
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTables)
                                                 name:@"reloadRequest"
                                               object:nil];
    
    //set up our arrays for the search bar
    self.filteredArray = [NSMutableArray arrayWithCapacity:[[MusicPlayer sharedStore].allItems count]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //display correct amount of rows based on whether you are searching in the search bar or not
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {

        return [self.filteredArray count];
        
    }
    //for the queued list display how many songs are queued
    else if (songFilterType == 3)
    {
        //if the queue is empty then return one cell which will say "no queued songs"
        if([[MusicPlayer sharedStore].queuedSongs count] == 0)
        {
            return 1;
        }
        else
        {
            return [[MusicPlayer sharedStore].queuedSongs count];
        }

    }
    else
    {
        //return the number of songs on device
        return [[MusicPlayer sharedStore].allItems count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    
        //switch statement for controlling filtering when the user hits the segmented controler
        switch (songFilterType)
        {
            
            //filtering by song title
            case 0:
            
                //If we are using the search bar then pick a song in the search results
                if(tableView == self.searchDisplayController.searchResultsTableView)
                {
                    //this gets the song and artist name for each song on the device
                    MPMediaItem *song = self.filteredArray[indexPath.row];
                    NSString *songTitle = [song valueForProperty:MPMediaItemPropertyTitle];
                    NSString *songArtist = [song valueForProperty:MPMediaItemPropertyArtist];
                
                    cell.textLabel.text = songTitle;
                    cell.detailTextLabel.text = songArtist;
                    return cell;
                }
                //otherwise just pick a song in the complete list
                else
                {
                    //this gets the song and artist name for each song on the device
                    MPMediaItem *song = [MusicPlayer sharedStore].allItems[indexPath.row];
                    NSString *songTitle = [song valueForProperty:MPMediaItemPropertyTitle];
                    NSString *songArtist = [song valueForProperty:MPMediaItemPropertyArtist];
                
                
                    cell.textLabel.text = songTitle;
                    cell.detailTextLabel.text = songArtist;
                    return cell;
                
                }
                break;
            
            //filtering by artist name
            case 1:

                //If we are using the search bar then pick a song in the search results
                if(tableView == self.searchDisplayController.searchResultsTableView)
                {
                    //this gets the song and artist name for each song on the device
                    MPMediaItem *song = self.filteredArray[indexPath.row];
                    NSString *songTitle = [song valueForProperty:MPMediaItemPropertyTitle];
                    NSString *songArtist = [song valueForProperty:MPMediaItemPropertyArtist];
                
                    cell.textLabel.text = songArtist;
                    cell.detailTextLabel.text = songTitle;
                    return cell;
                }
                //otherwise just pick a song in the complete list
                else
                {
                
                    //this gets the song and artist name for each song on the device
                    MPMediaItem *song = [MusicPlayer sharedStore].allItems[indexPath.row];
                    NSString *songTitle = [song valueForProperty:MPMediaItemPropertyTitle];
                    NSString *songArtist = [song valueForProperty:MPMediaItemPropertyArtist];
                
                    cell.textLabel.text = songArtist;
                    cell.detailTextLabel.text = songTitle;
                    return cell;
                }
                break;
            
            //filtering by album name
            case 2:
            
                //If we are using the search bar then pick a song in the search results
                if(tableView == self.searchDisplayController.searchResultsTableView)
                {
                    //this gets the song and artist name for each song on the device
                    MPMediaItem *song = self.filteredArray[indexPath.row];
                    NSString *albumTitle = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
                    NSString *songTitle = [song valueForProperty:MPMediaItemPropertyTitle];
                
                    //For songs with no album title just display "Unknown Album"
                    if([albumTitle isEqualToString:@""])
                    {
                        albumTitle = @"Unknown Album";
                    }
                
                    cell.textLabel.text = albumTitle;
                    cell.detailTextLabel.text = songTitle;
                    return cell;
                }
                //otherwise just pick a song in the complete list
                else
                {
                    //this gets the song and artist name for each song on the device
                    MPMediaItem *song = [MusicPlayer sharedStore].allItems[indexPath.row];
                    NSString *albumTitle = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
                    NSString *songTitle = [song valueForProperty:MPMediaItemPropertyTitle];
                
                    //For songs with no album title just display "Unknown Album"
                    if([albumTitle isEqualToString:@""])
                    {
                        albumTitle = @"Unknown Album";
                    }
                
                    cell.textLabel.text = albumTitle;
                    cell.detailTextLabel.text = songTitle;
                    return cell;
                }
                break;
            
            case 3:

                    //If there are no songs in the queue then display one cell that says that
                    if([[MusicPlayer sharedStore].queuedSongs count] == 0)
                    {
                        cell.textLabel.text = @"No songs queued";
                        cell.detailTextLabel.text = @"";
                        queueIndex = 0;
                        return cell;
                    }
                    //if they click on a song already in the queue, give them an option to delete from the queue
                    else if(indexPath == queueIndex || qr == indexPath.row)
                    {
                        
                         buttonCell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
                    
                        //make a button
                        self.playButton.frame = CGRectMake(buttonCell.frame.origin.x + 130, 0, 40, 40);
                        [self.playButton setImage:deleteImage forState:UIControlStateNormal];
                        [self.playButton addTarget:self action:@selector(pressedDeleteButton) forControlEvents:UIControlEventTouchUpInside];
                        [self.playButton setTag:2];
                        
                        //save the index they hit delete at
                        deleteSpot = indexPath;
                        
                        //add it as a subview of the cell
                        [buttonCell.contentView addSubview:self.playButton];
                        buttonCell.textLabel.text = @"";
                        buttonCell.detailTextLabel.text = @"";
                        queueIndex = 0;
                        qr = -1;
                        
                        return buttonCell;
                    }
                    else
                    {
                        //this gets the song and artist name for each song on the device
                        MPMediaItem *song = [MusicPlayer sharedStore].queuedSongs[indexPath.row];
                        NSString *songTitle = [song valueForProperty:MPMediaItemPropertyTitle];
                        NSString *songArtist = [song valueForProperty:MPMediaItemPropertyArtist];
                        
                        //Adding a number in front of the song title so you can tell what # the song is in the queue
                        NSInteger num = indexPath.row + 1;
                        NSString *songTitleWithNum = [NSString stringWithFormat:@"%ld.) %@", (long)num, songTitle];
                        cell.textLabel.text = songTitleWithNum;
                        cell.detailTextLabel.text = songArtist;
                        return cell;
                    }

                
                break;

            default:
                return cell;
                break;
        
        }
    return cell;
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //selection for ipad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        //if you click on a song in the queue bring up the option to delete it
        if( songFilterType == 3)
        {
            queueIndex = indexPath;
            [self.tableView reloadData];
            
        }
        else
        {
            //if we searched for a song send that song to the detail VC
            if(tableView == self.searchDisplayController.searchResultsTableView)
            {
                MPMediaItem *song = self.filteredArray[indexPath.row];
                [[MusicPlayer sharedStore] queueASong:song];
                self.detailViewController.detailItem = song;
            
            }
            //otherwise send whichever song was picked from the complete list
            else
            {
                MPMediaItem *song =[MusicPlayer sharedStore].allItems[indexPath.row];
                [[MusicPlayer sharedStore] queueASong:song];
                self.detailViewController.detailItem = song;
            
            }
        }
    }
    //selection for iphone
    else
    {
        //if you click on a song in the queue bring up the option to delete it
        if( songFilterType == 3)
        {
            queueIndex = indexPath;
            qr = indexPath.row;
            [self.tableView reloadData];
        }
        else
        {
            //if we searched for a song send that song to the detail VC
            if(tableView == self.searchDisplayController.searchResultsTableView)
            {
                MPMediaItem *song = self.filteredArray[indexPath.row];
                [[MusicPlayer sharedStore] queueASong:song];
                self.iPhonedetailViewController.detailItem = song;
            }
            //otherwise send whichever song was picked from the complete list
            else
            {
                MPMediaItem *song =[MusicPlayer sharedStore].allItems[indexPath.row];
                [[MusicPlayer sharedStore] queueASong:song];
                self.iPhonedetailViewController.detailItem = song;
            }
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

    // Update the filtered array based on the search text and scope.
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    // Remove all objects from the filtered search array
    [self.filteredArray removeAllObjects];
    
    //This is the convoluted way you need to search for predicates in MPMusicITems... DO NOT CHANGE THIS!!!!!!
    switch (songFilterType)
    {
        // predicate should be song title
        case 0:
        {
            predicate = [MPMediaPropertyPredicate predicateWithValue:searchText forProperty:MPMediaItemPropertyTitle comparisonType:MPMediaPredicateComparisonContains];
        }
        break;
        
        //predicate should be song artist
        case 1:
        {
            predicate = [MPMediaPropertyPredicate predicateWithValue:searchText forProperty:MPMediaItemPropertyArtist comparisonType:MPMediaPredicateComparisonContains];
        }
        break;
        
        //predicate should be song album
        case 2:
        {
            predicate = [MPMediaPropertyPredicate predicateWithValue:searchText forProperty:MPMediaItemPropertyAlbumTitle comparisonType:MPMediaPredicateComparisonContains];

        }
        break;
            
        //For the Queue just filter by song Title
        case 3:
        {
            predicate = [MPMediaPropertyPredicate predicateWithValue:searchText forProperty:MPMediaItemPropertyTitle comparisonType:MPMediaPredicateComparisonContains];
        }
        break;
            
        default:
            break;
    }
   
        NSSet *predicates = [NSSet setWithObjects: predicate, nil];
        MPMediaQuery *songsQuery =  [[MPMediaQuery alloc] initWithFilterPredicates: predicates];
        NSArray *itemsFromQueue = [songsQuery items];
        self.filteredArray = [NSMutableArray arrayWithArray:itemsFromQueue];

}

//determines whether the search bar should reload
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

//this is fired when the segmented controller is switched
- (IBAction)songFilterChanged:(id)sender
{
    //clicking a segment will change what the user wants to filter by(song title, artist, album, ect)
    switch (self.segmentedController.selectedSegmentIndex)
    {
        case 0:
        {
            //song title
            songFilterType = 0;
            self.searchBar.hidden = NO;
            self.searchBar.placeholder = @"Search song title";
            [[buttonCell.contentView viewWithTag:2] removeFromSuperview];
            [self.tableView reloadData];
            break;
        }
        case 1:
        {
            //artist name
            songFilterType = 1;
            self.searchBar.hidden = NO;
            self.searchBar.placeholder = @"Search artist name";
            [[buttonCell.contentView viewWithTag:2] removeFromSuperview];
            [self.tableView reloadData];
            break;
        }
        case 2:
        {
            //album name
            songFilterType = 2;
            self.searchBar.hidden = NO;
            self.searchBar.placeholder = @"Search album name";
            [[buttonCell.contentView viewWithTag:2] removeFromSuperview];
            [self.tableView reloadData];
            break;
        }
        case 3:
        {
            //view the queue
            songFilterType = 3;
            self.searchBar.hidden = YES;
            self.searchBar.placeholder = @"Search song title in queue";
            [[buttonCell.contentView viewWithTag:2] removeFromSuperview];
            [self.tableView reloadData];
            break;
        }
        default:
            break;
    }
}

//this is hooked up to the now playing button on the iPhone MVC storyboard.
//It will be used to transition between master and detail views for the iPhone
- (IBAction)iPhoneNowPlayingButton:(id)sender
{
    //switch the the now playing screen as long as a song is playing.
    if(self.iPhonedetailViewController.detailItem != nil)
    {
        //[self presentViewController:self.iPhonedetailViewController animated:NO completion:nil];
        [self performSegueWithIdentifier:@"showDetail"sender:self];
    }
}

//called when you want to remove a song from the queue
-(void)pressedDeleteButton
{
    //figure out which song to remove and reorder the queue
    NSInteger row = deleteSpot.row;
    [[MusicPlayer sharedStore] reorderQueueOnDelete:row];
    [[buttonCell.contentView viewWithTag:2] removeFromSuperview];
    
    //make sure the music player gets set accordingly
    [self.detailViewController interFaceSetUp];
    
    if(row == 0)
    {
        [self.detailViewController.playPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }

    [self.tableView reloadData];
    
}

//manually reload the tables from our DVC
-(void)reloadTables
{
    [self.tableView reloadData];
}


@end
