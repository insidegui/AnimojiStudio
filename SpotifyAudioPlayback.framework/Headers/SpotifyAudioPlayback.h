//
//  Spotify Audio Playback Framework.h
//  Spotify Audio Playback Framework
//
//  Created by Dmytro Ankudinov on 27/09/16.
//  Copyright © 2016 Spotify AB. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for Spotify Audio Playback Framework.
FOUNDATION_EXPORT double SpotifyAudioPlaybackVersionNumber;

//! Project version string for Spotify Audio Playback Framework.
FOUNDATION_EXPORT const unsigned char SpotifyAudioPlaybackVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Spotify_Audio_Playback_Framework/PublicHeader.h>

#import <SpotifyAudioPlayback/SPTCircularBuffer.h>
#import <SpotifyAudioPlayback/SPTCoreAudioController.h>
#import <SpotifyAudioPlayback/SPTAudioStreamingController.h>
#import <SpotifyAudioPlayback/SPTAudioStreamingController_ErrorCodes.h>
#import <SpotifyAudioPlayback/SPTDiskCaching.h>

#if !TARGET_OS_IPHONE
#import <SpotifyAudioPlayback/SPTCoreAudioDevice.h>
#endif
