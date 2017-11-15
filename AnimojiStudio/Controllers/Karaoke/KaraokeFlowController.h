//
//  KaraokeFlowController.h
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 15/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KaraokeFlowController, SpotifyCoordinator;

@protocol KaraokeFlowControllerDelegate <NSObject>

- (void)karaokeFlowController:(KaraokeFlowController *)controller didFinishWithTrackID:(NSString *)trackID;

@end

@interface KaraokeFlowController : UIViewController

@property (nonatomic, weak) SpotifyCoordinator *spotifyCoordinator;
@property (nonatomic, weak) id<KaraokeFlowControllerDelegate> delegate;

@end
