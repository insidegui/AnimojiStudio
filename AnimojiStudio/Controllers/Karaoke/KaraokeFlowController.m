//
//  KaraokeFlowController.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 15/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "KaraokeFlowController.h"

#import "UIViewController+Children.h"

#import "SpotifyCoordinator.h"
#import "SpotifySearchViewController.h"

#import <SpotifyMetadata/SpotifyMetadata.h>

@interface KaraokeFlowController () <SpotifySearchViewControllerDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, weak) SpotifySearchViewController *searchController;

@end

@implementation KaraokeFlowController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SpotifySearchViewController *search = [SpotifySearchViewController new];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:search];
    
    self.searchController = search;
    self.searchController.delegate = self;
    
    [self installChildViewController:self.navigationController];
}

- (void)spotifySearchViewController:(SpotifySearchViewController *)controller didSearchForTerm:(NSString *)term
{
    __weak typeof(self) weakSelf = self;
    [self.spotifyCoordinator searchForTerm:term completion:^(NSError *error, SPTListPage *result) {
        if (error) {
            NSLog(@"Spotify search error: %@", error);
        } else {
            NSLog(@"SEARCH DONE");
            NSLog(@"%@", result.items);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.searchController setTracks:result.items];
            });
        }
    }];
}

- (void)spotifySearchViewController:(SpotifySearchViewController *)controller didSelectTrack:(SPTPartialTrack *)track
{
    [self.delegate karaokeFlowController:self didFinishWithTrackID:track.playableUri.absoluteString];
}

- (void)spotifySearchViewControllerDidSelectDone:(SpotifySearchViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)spotifySearchViewController:(SpotifySearchViewController *)controller didSelectPreviewTrack:(SPTPartialTrack *)track
{    
    [self.spotifyCoordinator playSongPreviewWithURL:track.previewURL];
    
    __weak typeof(self) weakSelf = self;
    self.spotifyCoordinator.previewPlaybackDidFinish = ^{
        [weakSelf.searchController stopPreviewing];
    };
}

- (void)spotifySearchViewControllerDidSelectStop:(SpotifySearchViewController *)controller
{
    [self.spotifyCoordinator stopPreviewPlayback];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.spotifyCoordinator stopPreviewPlayback];
    [self.searchController stopPreviewing];
}

@end
