//
//  SpotifyCoordinator.h
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 15/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

@import UIKit;

@class SpotifyCoordinator;

@protocol SpotifyCoordinatorDelegate <NSObject>

- (void)spotifyCoordinatorDidFinishLogin:(SpotifyCoordinator *)coordinator;

@end

@interface SpotifyCoordinator : NSObject

@property (nonatomic, weak) id<SpotifyCoordinatorDelegate> delegate;

- (void)startAuthFlowFromViewController:(UIViewController *)presenter withError:(NSError **)outError;
- (BOOL)handleCallbackURL:(NSURL *)url;

- (void)playTrackID:(NSString *)trackID;
- (void)stop;

- (void)searchForTerm:(NSString *)term completion:(void(^)(NSError *error, id result))completionHandler;

- (void)playSongPreviewWithURL:(NSURL *)url;
- (void)stopPreviewPlayback;

@property (nonatomic, copy) void (^previewPlaybackDidFinish)(void);

@end
