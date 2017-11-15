//
//  SpotifySearchViewController.h
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 15/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

@import UIKit;

@class SPTPartialTrack, SpotifySearchViewController;

@protocol SpotifySearchViewControllerDelegate <NSObject>

- (void)spotifySearchViewController:(SpotifySearchViewController *)controller didSearchForTerm:(NSString *)term;
- (void)spotifySearchViewController:(SpotifySearchViewController *)controller didSelectTrack:(SPTPartialTrack *)track;
- (void)spotifySearchViewController:(SpotifySearchViewController *)controller didSelectPreviewTrack:(SPTPartialTrack *)track;

- (void)spotifySearchViewControllerDidSelectDone:(SpotifySearchViewController *)controller;

@end

@interface SpotifySearchViewController : UITableViewController

@property (nonatomic, weak) id<SpotifySearchViewControllerDelegate> delegate;

@property (nonatomic, strong) NSArray <SPTPartialTrack *> *tracks;

- (void)stopPreviewing;

@property (nonatomic, copy) NSString *previewTrackID;

@end
