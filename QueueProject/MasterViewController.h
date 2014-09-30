//
//  MasterViewController.h
//  QueueProject
//
//  Created by Student on 4/23/14.
//  Copyright (c) 2014 Student. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;
@class IPhoneDetailViewController;

@interface MasterViewController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate>

//Two view controllers(one for iPhone version)
@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) IPhoneDetailViewController *iPhonedetailViewController;

//Search bar and segmented controller
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nowPlaying;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedController;
//Arrays for filtering text in the search bar
@property (strong, nonatomic) NSMutableArray *filteredArray;

//buttons for removing a song from the queue
@property(strong, nonatomic) UIButton *playButton;
@property(strong, nonatomic) UIButton *queueButton;

//method for manually reloading the tables
-(void)reloadTables;
@end
