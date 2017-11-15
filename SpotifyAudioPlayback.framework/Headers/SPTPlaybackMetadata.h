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

#import <Foundation/Foundation.h>


@interface SPTPlaybackTrack : NSObject

@property (readonly, nonnull) NSString *name;
@property (readonly, nonnull) NSString *uri;
@property (readonly, nonnull) NSString *playbackSourceUri;
@property (readonly, nonnull) NSString *playbackSourceName;
@property (readonly, nonnull) NSString *artistName;
@property (readonly, nonnull) NSString *artistUri;
@property (readonly, nonnull) NSString *albumName;
@property (readonly, nonnull) NSString *albumUri;

/// The URL of the album cover art of the track.
@property (nullable, nonatomic, copy, readonly) NSString *albumCoverArtURL;

@property (readonly) NSTimeInterval duration;
@property (readonly) NSUInteger indexInContext;

- (instancetype _Nullable)initWithName:(NSString* _Nonnull)name
                                   uri:(NSString* _Nonnull)uri
                     playbackSourceUri:(NSString* _Nonnull)playbackSourceUri
                    playbackSourceName:(NSString* _Nonnull)playbackSourceName
                            artistName:(NSString* _Nonnull)artistName
                             artistUri:(NSString* _Nonnull)artistUri
                             albumName:(NSString* _Nonnull)albumName
                              albumUri:(NSString* _Nonnull)albumUri
                      albumCoverArtURL:(NSString * _Nullable)albumCoverArtURL
                              duration:(NSTimeInterval)duration
                        indexInContext:(NSUInteger)indexInContext;

@end


@interface SPTPlaybackMetadata: NSObject

@property (readonly, nullable) SPTPlaybackTrack *prevTrack;
@property (readonly, nullable) SPTPlaybackTrack *currentTrack;
@property (readonly, nullable) SPTPlaybackTrack *nextTrack;

- (instancetype _Nullable)initWithPrevTrack:(SPTPlaybackTrack* _Nullable)prevTrack
                               currentTrack:(SPTPlaybackTrack* _Nullable)currentTrack
                                  nextTrack:(SPTPlaybackTrack* _Nullable)nextTrack;

@end