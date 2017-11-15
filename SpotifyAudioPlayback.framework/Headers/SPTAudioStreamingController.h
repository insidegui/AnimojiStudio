/*
 Copyright 2015 Spotify AB
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "SPTAudioPlaybackTypes.h"
#import "SPTDiskCache.h"
#import "SPTDiskCaching.h"
#import "SPTPlaybackMetadata.h"
#import "SpPlaybackEvent.h"
#import "SPTPlaybackState.h"

/** A volume value, in the range 0.0..1.0. */
typedef double SPTVolume;

/** The playback bitrates availabe. */
typedef NS_ENUM(NSUInteger, SPTBitrate) {
    /** The lowest bitrate, roughly equivalent to ~96kbit/sec. */
    SPTBitrateLow = 0,
    /** The normal bitrate, roughly equivalent to ~160kbit/sec.  */
    SPTBitrateNormal = 1,
    /** The highest bitrate, roughly equivalent to ~320kbit/sec. */
    SPTBitrateHigh = 2,
};


/** Repeat mode options */
typedef NS_ENUM(NSUInteger, SPTRepeatMode) {
    /** Repeate disabled */
    SPTRepeatOff = 0,
    /** Repeates context */
    SPTRepeatContext = 1,
    /** Repeates current song */
    SPTRepeatOne = 2
};


@class SPTCoreAudioController;
@protocol SPTAudioStreamingDelegate;
@protocol SPTAudioStreamingPlaybackDelegate;

/** This class manages audio streaming from Spotify.
 
 \note There must be only one concurrent instance of this class in your app.
 */
@interface SPTAudioStreamingController : NSObject

///----------------------------
/// @name Initialisation and Setup
///----------------------------

// Hide parameterless init
- (id)init __attribute__((unavailable("init not available, use +sharedInstance")));
+(id)new __attribute__((unavailable("new not available, use +sharedInstance")));


/**
 Access the shared `SPAudioStreamingController` instance
 @return Returns the shared `SPAudioStreamingController` instance
 */
+ (instancetype)sharedInstance;

/** Start the `SPAudioStreamingController` thread with a custom audio controller.
 
 @note You MUST initialize the `SPAudioStreamingController sharedInstance` before calling any other method.
 
 @param clientId Your client id found at developer.spotify.com
 @param audioController Custom audio controller
 @param error If method returns NO, error will be set
 @param allowCaching YES of persisten disk caching is allowed
 @return Returns YES if initialization was successful
 */
- (BOOL)startWithClientId:(NSString *)clientId audioController:(SPTCoreAudioController *)audioController allowCaching:(BOOL)allowCaching error:(NSError *__autoreleasing*)error;

/** Start the `SPAudioStreamingController` thread with the default audioController.
 
 @note You need to start the `SPAudioStreamingController sharedInstance` before calling any other method.
 
 @param clientId Your client id found at developer.spotify.com
 @param error If method returns NO, error will be set
 @return Returns YES if initialization was successful
 */
- (BOOL)startWithClientId:(NSString *)clientId error:(NSError *__autoreleasing*)error;

/** Shut down the `SPTAudioStreamingController` thread.
 @note If a user is currently logged in, the application should first call
 logout and wait for the `-audioStreamingDidLogout:` delegate method
 @param error If method returns NO, error will be set
 @return Returns YES if initialization was successful
 */
- (BOOL)stopWithError:(NSError *__autoreleasing*)error;


/** Log into the Spotify service for audio playback.
 
 Audio playback will not be available until the receiver is successfully logged in.
 
 @discussion Login is asynchronous.
 Success will be notified on the `audioStreamingDidLogin:` delegate method and
 failure will be notified on the `audioStreaming:didEncounterError:` delegate method.
 
 @param accessToken An authenticated access token authorized with the `streaming` scope.
 */
- (void)loginWithAccessToken:(NSString *)accessToken;


/** Log out of the Spotify service
 
 @discussion This method is asynchronous. When logout is complete you will be notified by the
 `audioStreamingDidLogout:` delegate method.
 */
- (void)logout;

///----------------------------
/// @name Properties
///----------------------------

/** YES while the `SPTAudioStreamingController` is initialized */
@property (atomic, readonly, assign) BOOL initialized;

/** Returns `YES` if the receiver is logged into the Spotify service, otherwise `NO`. */
@property (atomic, readonly) BOOL loggedIn;

/** The receiver's delegate, which deals with session events such as login, logout, errors, etc. */
@property (nonatomic, weak) id <SPTAudioStreamingDelegate> delegate;

/** The receiver's playback delegate, which deals with audio playback events. */
@property (nonatomic, weak) id <SPTAudioStreamingPlaybackDelegate> playbackDelegate;

/**
 * @brief The object responsible for caching of audio data.
 * @discussion The object is an instance of a class that implements the `SPTDiskCaching` protocol.
 * If `nil`, no caching will be performed.
 */
@property (nonatomic, strong) id <SPTDiskCaching> diskCache;

///----------------------------
/// @name Controlling Playback
///----------------------------

/** Set playback volume to the given level.
 
 @param volume The volume to change to, as a value between `0.0` and `1.0`.
 @param block The callback block to be executed when the command has been
 received, which will pass back an `NSError` object if an error ocurred.
 @see -volume
 */
- (void)setVolume:(SPTVolume)volume callback:(SPTErrorableOperationCallback)block;

/** Set the target streaming bitrate.
 
 The library will attempt to stream audio at the given bitrate. If the given
 bitrate is not available, the closest match will be used. This process is
 completely transparent, but you should be aware that data usage isn't guaranteed.
 
 @param bitrate The bitrate to target.
 @param block The callback block to be executed when the command has been
 received, which will pass back an `NSError` object if an error ocurred.
 */
- (void)setTargetBitrate:(SPTBitrate)bitrate callback:(SPTErrorableOperationCallback)block;

/** Seek playback to a given location in the current track.
 
 @param position in sec to seek to.
 @param block The callback block to be executed when the command has been
 received, which will pass back an `NSError` object if an error ocurred.
 @see -playbackState
 */
- (void)seekTo:(NSTimeInterval)position callback:(SPTErrorableOperationCallback)block;

/** Set the "playing" status of the receiver.
 
 @param playing Pass `YES` to resume playback, or `NO` to pause it.
 @param block The callback block to be executed when the command has been
 received, which will pass back an `NSError` object if an error ocurred.
 @see -playbackState
 */
- (void)setIsPlaying:(BOOL)playing callback:(SPTErrorableOperationCallback)block;

/** Play a Spotify URI.
 
 Supported URI types: Tracks, Albums and Playlists
 
 @param spotifyUri The Spotify URI to play.
 @param index The index of an item that should be played first, e.g. 0 - for the very first track
 in the playlist or a single track
 @param position starting position for playback in sec
 @param block The callback block to be executed when the playback command has been
 received, which will pass back an `NSError` object if an error ocurred.
 */
- (void)playSpotifyURI:(NSString *)spotifyUri startingWithIndex:(NSUInteger)index startingWithPosition:(NSTimeInterval)position callback:(SPTErrorableOperationCallback)block;

/** Queue a Spotify URI.
 
 Supported URI types: Tracks
 
 @param spotifyUri The Spotify URI to queue.
 @param block The callback block to be executed when the playback command has been
 received, which will pass back an `NSError` object if an error ocurred.
 */
- (void)queueSpotifyURI:(NSString *)spotifyUri callback:(SPTErrorableOperationCallback)block;

/** Go to the next track in the queue.
 
 @param block The callback block to be executed when the command has been
 received, which will pass back an `NSError` object if an error ocurred.
 */
- (void)skipNext:(SPTErrorableOperationCallback)block;

/** Go to the previous track in the queue
 
 @param block The callback block to be executed when the command has been
 received, which will pass back an `NSError` object if an error ocurred.
 */
- (void)skipPrevious:(SPTErrorableOperationCallback)block;

/** Set state for shuffle, on or off.
 
 @param enable The state to set, YES to enable shuffle and NO to disable.
 @param block The callback block to be executed when the command has been
 received, which will pass back an `NSError` object if an error ocurred.
 */
- (void)setShuffle:(BOOL)enable callback:(SPTErrorableOperationCallback)block;

/** Set repeat state, on, off or repeat-one
 
 @param mode The state to set, SPTRepeatOff, SPTRepeatContext or SPTRepeatOne.
 @param block The callback block to be executed when the command has been
 received, which will pass back an `NSError` object if an error ocurred.
 */
- (void)setRepeat:(SPTRepeatMode)mode callback:(SPTErrorableOperationCallback)block;

/** Returns current volume */
@property (atomic, readonly) SPTVolume volume;

/** Metadata for the currently playing context */
@property (atomic, readonly) SPTPlaybackMetadata *metadata;

/** The players current state */
@property (atomic, readonly) SPTPlaybackState *playbackState;

/** Returns the current streaming bitrate the receiver is using. */
@property (atomic, readonly) SPTBitrate targetBitrate;

@end


/// Defines events relating to the connection to the Spotify service.
@protocol SPTAudioStreamingDelegate <NSObject>

@optional

/** Called on error
 @param audioStreaming The object that sent the message.
 @param error An NSError. Domain is SPTAudioStreamingErrorDomain and code is one of SpErrorCode
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didReceiveError:(NSError *)error;

/** Called when the streaming controller logs in successfully.
 @param audioStreaming The object that sent the message.
 */
- (void)audioStreamingDidLogin:(SPTAudioStreamingController *)audioStreaming;

/** Called when the streaming controller logs out.
 @param audioStreaming The object that sent the message.
 */
- (void)audioStreamingDidLogout:(SPTAudioStreamingController *)audioStreaming;

/** Called when the streaming controller encounters a temporary connection error.
 
 You should not throw an error to the user at this point. The library will attempt to reconnect without further action.
 
 @param audioStreaming The object that sent the message.
 */
- (void)audioStreamingDidEncounterTemporaryConnectionError:(SPTAudioStreamingController *)audioStreaming;

/** Called when the streaming controller recieved a message for the end user from the Spotify service.
 
 This string should be presented to the user in a reasonable manner.
 
 @param audioStreaming The object that sent the message.
 @param message The message to display to the user.
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didReceiveMessage:(NSString *)message;

/** Called when network connectivity is lost.
 @param audioStreaming The object that sent the message.
 */
- (void)audioStreamingDidDisconnect:(SPTAudioStreamingController *)audioStreaming;

/** Called when network connectivitiy is back after being lost.
 @param audioStreaming The object that sent the message.
 */
- (void)audioStreamingDidReconnect:(SPTAudioStreamingController *)audioStreaming;

@end


/// Defines events relating to audio playback.
@protocol SPTAudioStreamingPlaybackDelegate <NSObject>

@optional

/** Called for each received low-level event
 @param audioStreaming The object that sent the message.
 @param event The event code
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didReceivePlaybackEvent:(SpPlaybackEvent)event;

/** Called when playback has progressed
 @param audioStreaming The object that sent the message.
 @param position The new playback location in sec.
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangePosition:(NSTimeInterval)position;

/** Called when playback status changes.
 @param audioStreaming The object that sent the message.
 @param isPlaying Set to `YES` if the object is playing audio, `NO` if it is paused.
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangePlaybackStatus:(BOOL)isPlaying;

/** Called when playback is seeked "unaturally" to a new location.
 @param audioStreaming The object that sent the message.
 @param position The new playback location in sec.
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didSeekToPosition:(NSTimeInterval)position;

/** Called when playback volume changes.
 @param audioStreaming The object that sent the message.
 @param volume The new volume.
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeVolume:(SPTVolume)volume;

/** Called when shuffle status changes.
 @param audioStreaming The object that sent the message.
 @param enabled Set to `YES` if the object requests shuffled playback, otherwise `NO`.
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeShuffleStatus:(BOOL)enabled;


/** Called when repeat status changes.
 @param audioStreaming The object that sent the message.
 @param repeateMode Set to `SPTRepeatOff`, `SPTRepeatContext` or `SPTRepeatOne`.
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeRepeatStatus:(SPTRepeatMode)repeateMode;


/** Called when metadata for current, previous, or next track is changed.
 *
 * This event occurs when playback starts or changes to a different context,
 * when a track switch occurs, etc. This is an informational event that does
 * not require action, but should be used to keep the UI display updated with
 * the latest metadata information.
 *
 @param audioStreaming The object that sent the message.
 @param metadata for previous, current, and next tracks
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeMetadata:(SPTPlaybackMetadata *)metadata;

/** Called when the streaming controller begins playing a new track.
 
 @param audioStreaming The object that sent the message.
 @param trackUri The Spotify URI of the track that started to play.
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didStartPlayingTrack:(NSString *)trackUri;

/** Called before the streaming controller begins playing another track.
 
 @param audioStreaming The object that sent the message.
 @param trackUri The Spotify URI of the track that stopped.
 */
- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didStopPlayingTrack:(NSString *)trackUri;

/** Called when the audio streaming object requests playback skips to the next track.
 @param audioStreaming The object that sent the message.
 */
- (void)audioStreamingDidSkipToNextTrack:(SPTAudioStreamingController *)audioStreaming;

/** Called when the audio streaming object requests playback skips to the previous track.
 @param audioStreaming The object that sent the message.
 */
- (void)audioStreamingDidSkipToPreviousTrack:(SPTAudioStreamingController *)audioStreaming;

/** Called when the audio streaming object becomes the active playback device on the user's account.
 @param audioStreaming The object that sent the message.
 */
- (void)audioStreamingDidBecomeActivePlaybackDevice:(SPTAudioStreamingController *)audioStreaming;

/** Called when the audio streaming object becomes an inactive playback device on the user's account.
 @param audioStreaming The object that sent the message.
 */
- (void)audioStreamingDidBecomeInactivePlaybackDevice:(SPTAudioStreamingController *)audioStreaming;

/** Called when the streaming controller lost permission to play audio.
 
 This typically happens when the user plays audio from their account on another device.
 
 @param audioStreaming The object that sent the message.
 */
- (void)audioStreamingDidLosePermissionForPlayback:(SPTAudioStreamingController *)audioStreaming;

/** Called when the streaming controller popped a new item from the playqueue.
 
 @param audioStreaming The object that sent the message.
 */
- (void)audioStreamingDidPopQueue:(SPTAudioStreamingController *)audioStreaming;


@end
