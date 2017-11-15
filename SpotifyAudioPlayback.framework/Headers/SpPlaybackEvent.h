/*
 Copyright 2016 Spotify AB

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

typedef enum : NSUInteger {
	/**
	 * \brief Playback has started or has resumed
	 * \see SpPlaybackPlay, SpPlaybackIsPlaying, \ref observing
	 */
	SPPlaybackNotifyPlay,

	/**
	 * \brief Playback has been paused
	 *
	 * If the device is the active speaker (according to SpPlaybackIsActiveDevice()),
	 * the application should stop playing audio immediately.
	 *
	 * \note The application is not supposed to discard audio data that has been
	 * delivered by SpCallbackPlaybackAudioData() but that has not been played yet.
	 * This audio data still needs to be played when playback resumes
	 * (#SPPlaybackNotifyPlay).
	 *
	 * \see SpPlaybackPause, SpPlaybackIsPlaying, \ref observing
	 */
	SPPlaybackNotifyPause,

	/**
	 * \brief The current track or its metadata has changed
	 *
	 * This event occurs when playback of a new/different track starts. If your
	 * application displays metadata of the current track, use SpGetMetadata() to
	 * reload the metadata when you receive this event.
	 *
	 *
	 * Note : SPPlaybackNotifyTrackChanged is only sent if the current
	 * track was changed. SPPlaybackNotifyMetadataChanged is a more general
	 * event that can be used to detect all kinds of UI changes. If you
	 * display information about the previous and next tracks you should
	 * use SPPlaybackNotifyMetadataChanged to detect updates to those
	 * as well.  For example, if the upcoming track is changed then
	 * SPPlaybackNotifyTrackChanged will not be sent but
	 * SPPlaybackNotifyMetadataChanged will be.
	 *
	 */
	SPPlaybackNotifyTrackChanged,

	/**
	 * \brief Playback has skipped to the next track
	 *
	 * This event occurs when SpPlaybackSkipToNext() was invoked or when
	 * the user skipped to the next track using Spotify Connect. It does not
	 * occur when playback goes to a new track after the previous track has
	 * reached the end.
	 *
	 * \see SpPlaybackSkipToNext
	 * \deprecated Use SPPlaybackNotifyMetadataChanged instead.
	 */
	SPPlaybackNotifyNext,

	/**
	 * \brief Playback as skipped to the previous track
	 * \see SpPlaybackSkipToPrev
	 * \deprecated Use SPPlaybackNotifyMetadataChanged instead.
	 */
	SPPlaybackNotifyPrev,

	/**
	 * \brief "Shuffle" was switched on
	 *
	 * \see SpPlaybackEnableShuffle, SpPlaybackIsShuffled, \ref observing
	 */
	SPPlaybackNotifyShuffleOn,

	/**
	 * \brief "Shuffle" was switched off
	 *
	 * \see SpPlaybackEnableShuffle, SpPlaybackIsShuffled, \ref observing
	 */
	SPPlaybackNotifyShuffleOff,

	/**
	 * \brief "Repeat" was switched on
	 *
	 * \see SpPlaybackEnableRepeat, SpPlaybackIsRepeated, SpPlaybackGetRepeatMode \ref observing
	 */
	SPPlaybackNotifyRepeatOn,

	/**
	 * \brief "Repeat" was switched off
	 *
	 * \see SpPlaybackEnableRepeat, SpPlaybackIsRepeated, \ref observing
	 */
	SPPlaybackNotifyRepeatOff,

	/**
	 * \brief This device has become the active playback device
	 *
	 * This event occurs when the users moves playback to this device using
	 * Spotify Connect, or when playback is moved to this device as a side-effect
	 * of invoking one of the SpPlayback...() functions.
	 *
	 * When this event occurs, it may be a good time to initialize the audio
	 * pipeline of the application.  You should not unpause when you receive this
	 * event -- wait for SPPlaybackNotifyPlay.
	 *
	 * \see SpPlaybackIsActiveDevice
	 */
	SPPlaybackNotifyBecameActive,

	/**
	 * \brief This device is no longer the active playback device
	 *
	 * This event occurs when the user moves playback to a different device using
	 * Spotify Connect.
	 *
	 * When this event occurs, the application should stop producing audio
	 * immediately. The application should not take any other action. Specifically,
	 * the application must not invoke any of the SpPlayback...() functions
	 * unless requested by some subsequent user interaction.
	 *
	 * \see SpPlaybackIsActiveDevice
	 */
	SPPlaybackNotifyBecameInactive,

	/**
	 * \brief This device has temporarily lost permission to stream audio from Spotify
	 *
	 * A user can only stream audio on one of her devices at any given time.
	 * If playback is started on a different device, this event may occur.
	 * If the other device is Spotify Connect-enabled, the event
	 * SPPlaybackNotifyBecameInactive may occur instead of or in addition to this
	 * event.
	 *
	 * When this event occurs, the application should stop producing audio
	 * immediately. The application should not take any other action. Specifically,
	 * the application must not invoke any of the SpPlayback...() functions
	 * unless requested by some subsequent user interaction.
	 */
	SPPlaybackNotifyLostPermission,

	/**
	 * \brief The application should flush its audio buffers
	 *
	 * This event occurs for example when seeking to a different position within
	 * a track. If possible, the application should discard all samples that it
	 * has received in SpCallbackPlaybackAudioData() but that it has not played yet.
	 */
	SPPlaybackEventAudioFlush,

	/**
	 * \brief The library will not send any more audio data
	 *
	 * This event occurs when the library reaches the end of a playback context
	 * and has no more audio to deliver.  This occurs, for instance, at the end
	 * of a playlist when repeat is disabled.  When the application receives this
	 * event, it should finish playing out all of its buffered audio, including
	 * padding with silence if necessary, until it can report samples_buffered
	 * as 0 to SpCallbackPlaybackAudioData().
	 */
	SPPlaybackNotifyAudioDeliveryDone,

	/**
	 * \brief Playback changed to a different Spotify context
	 *
	 * This event occurs when playback starts or changes to a different context
	 * than was playing before, such as a change in album or playlist.  This is
	 * an informational event that does not require action, but may be used to
	 * update the UI display, such as whether the user is playing from a preset.
	 *
	 * \deprecated Use SPPlaybackNotifyMetadataChanged instead.
	 */
	SPPlaybackNotifyContextChanged,

	/**
	 * \brief Application accepted all samples from the current track
	 *
	 * This is an informative event that indicates that all samples from the
	 * current track have been delivered to and accepted by the application.
	 * The track has not finished yet (\see SPPlaybackNotifyTrackChanged).
	 * No action is necessary by the application, but this event may be used
	 * to store track boundary information if desired.
	 */
	SPPlaybackNotifyTrackDelivered,

	/**
	 * \brief Metadata is changed
	 *
	 * This event occurs when playback starts or changes to a different context,
	 * when a track switch occurs, etc. This is an informational event that does
	 * not require action, but should be used to keep the UI display updated with
	 * the latest metadata information.
	 *
	 */
	SPPlaybackNotifyMetadataChanged,
} SpPlaybackEvent;

typedef enum : NSUInteger {
	/** \brief The operation was successful. */
	SPErrorOk = 0,

	/** \brief The operation failed due to an unspecified issue. */
	SPErrorFailed,

	/**
	 * \brief The library could not be initialized.
	 * \see SpInit
	 */
	SPErrorInitFailed,

	/**
	 * \brief The library could not be initialized because of an incompatible API version.
	 *
	 * When calling SpInit(), you are required to set the field SpConfig::api_version
	 * to SP_API_VERSION. This error indicates that the library that the application
	 * is linked against was built for a different SP_API_VERSION. There might be
	 * an issue with the include or library paths in the build environment,
	 * or the wrong SDK shared object is loaded at runtime.
	 *
	 * \see SpInit, SpConfig::api_version
	 */
	SPErrorWrongAPIVersion,

	/**
	 * \brief An unexpected NULL pointer was passed as an argument to a function.
	 */
	SPErrorNullArgument,

	/** \brief An unexpected argument value was passed to a function. */
	SPErrorInvalidArgument,

	/** \brief A function was invoked before SpInit() or after SpFree() was called. */
	SPErrorUninitialized,

	/** \brief SpInit() was called more than once. */
	SPErrorAlreadyInitialized,

	/**
	 * \brief Login to Spotify failed because of invalid credentials.
	 * \see SpConnectionLoginPassword, SpConnectionLoginBlob, SpConnectionLoginZeroConf
	 */
	SPErrorLoginBadCredentials,

	/** \brief The operation requires a Spotify Premium account */
	SPErrorNeedsPremium,

	/** \brief The Spotify user is not allowed to log in from this country. */
	SPErrorTravelRestriction,

	/**
	 * \brief The application has been banned by Spotify.
	 *
	 * This most likely means that the application key specified in SpConfig::app_key
	 * has been revoked.
	 */
	SPErrorApplicationBanned,

	/**
	 * \brief An unspecified login error occurred.
	 *
	 * In order to help debug the issue, the application should register the callback
	 * SpCallbackDebugMessage(), which receives additional information
	 * about the error.
	 */
	SPErrorGeneralLoginError,

	/**
	 * \brief The operation is not supported.
	 */
	SPErrorUnsupported,

	/**
	 * \brief The operation is not supported if the device is not the active playback
	 *        device.
	 * \see SpPlaybackIsActiveDevice
	 */
	SPErrorNotActiveDevice,

	/**
	 * \brief The API has been rate-limited.
	 *
	 * The API is rate-limited if it is asked to perform too many actions
	 * in a short amount of time.
	 */
	SPErrorAPIRateLimited,

	/**
	 * \brief Error range reserved for playback-related errors.
	 */
	SPErrorPlaybackErrorStart = 1000,

	/** \brief An unspecified playback error occurred.
	 *
	 * In order to help debug the issue, the application should register the callback
	 * SpCallbackDebugMessage(), which receives additional information
	 * about the error.
	 */
	SPErrorGeneralPlaybackError,

	/**
	 * \brief The application has been rate-limited.
	 *
	 * The application is rate-limited if it requests the playback of too many
	 * tracks within a given amount of time.
	 */
	SPErrorPlaybackRateLimited,

	/**
	 * \brief The Spotify user has reached a capping limit that is in effect
	 *        in this country and/or for this track.
	 */
	SPErrorPlaybackCappingLimitReached,

	/**
	 * \brief Cannot change track while ad is playing.
	 */
	SPErrorAdIsPlaying,

	/**
	 * \brief The track is (temporarily) corrupt in the Spotify catalogue.
	 *
	 * This track will be skipped because it cannot be downloaded.  This is a
	 * temporary issue with the Spotify catalogue that will be resolved.  The
	 * error is for informational purposes only.  No action is required.
	 */
	SPErrorCorruptTrack,

	/**
	 * \brief Unable to read all tracks from the playing context.
	 *
	 * This could be caused by temporary communication or server problems, or
	 * by the underlying context being removed or shortened during playback (for
	 * instance, the user deleted all tracks in the playlist while listening.)
	 */
	SPErrorContextFailed,

	/*
	 * \brief The item that was being prefetched was unavailable, and cannot be fetched.
	 * This could be due to an invalid URI, changes in track availability, or geographical limitations.
	 * This is a permanent error, and the item should not be tried again.
	 */
	SPErrorPrefetchItemUnavailable,

	/**
	 * \brief An item is already actively being prefetched. You must stop the current prefetch request to start another one.
	 * This error is only relevant for builds with offline storage enabled.
	 */
	SPAlreadyPrefetching,

	/**
	 * \brief A permanent error was encountered while writing to a registered file storage callback.
	 * This error is only relevant for builds with offline storage enabled.
	 */
	SPStorageWriteError,

	/**
	 * \brief Prefetched item was not fully downloaded or failed. If error happens prefetch can be retried.
	 * This error is only relevant for builds with offline storage enabled.
	 */
	SPPrefetchDownloadFailed,
} SpErrorCode;

NSError * NSErrorFromSPErrorCode(SpErrorCode code);

