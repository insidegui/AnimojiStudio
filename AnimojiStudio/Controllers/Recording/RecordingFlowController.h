//
//  RecordingFlowController.h
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 11/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

@import UIKit;

@class SpotifyCoordinator;

@interface RecordingFlowController : UIViewController

@property (nonatomic, weak) SpotifyCoordinator *spotifyCoordinator;
@property (nonatomic, copy) NSString *karaokeTrackID;

@end
