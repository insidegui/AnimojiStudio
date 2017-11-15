//
//  SpotifySearchViewController.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 15/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "SpotifySearchViewController.h"

#import <SpotifyMetadata/SpotifyMetadata.h>

NSString * const kTrackCellIdentifier = @"TrackCell";

@interface SpotifySearchViewController () <UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation SpotifySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setOpaque:YES];
    
    self.title = @"Search Music";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTrackCellIdentifier];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 0)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search for songs";
    [self.searchBar sizeToFit];
    [self.tableView setTableHeaderView:self.searchBar];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTapped:)];
    self.navigationItem.rightBarButtonItem = doneItem;
}

- (IBAction)doneTapped:(id)sender
{
    [self.delegate spotifySearchViewControllerDidSelectDone:self];
}

- (void)setTracks:(NSArray<SPTPartialTrack *> *)tracks
{
    _tracks = tracks;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tracks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTrackCellIdentifier];
    
    SPTPartialTrack *track = self.tracks[indexPath.row];
    
    [cell.textLabel setText:track.name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPTPartialTrack *track = self.tracks[indexPath.row];
    
    [self.delegate spotifySearchViewController:self didSelectTrack:track];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length < 3) return;
    
    [self.delegate spotifySearchViewController:self didSearchForTerm:searchBar.text];
}

@end
