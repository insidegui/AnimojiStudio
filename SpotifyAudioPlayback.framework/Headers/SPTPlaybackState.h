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


/**
 Represent aggregated playar state.
 The next substates are exposed: 
 -isPlaying
 -isRepeating
 -isShuffling
 -isActiveDevice
 -positionMs
 */
@interface SPTPlaybackState : NSObject

@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic, readonly) BOOL isRepeating;
@property (nonatomic, readonly) BOOL isShuffling;
@property (nonatomic, readonly) BOOL isActiveDevice;
@property (nonatomic, readonly) NSTimeInterval position;

- (instancetype _Nullable)initWithIsPlaying:(BOOL)isPlaying
							  isRepeating:(BOOL)isRepeating
							  isShuffling:(BOOL)isShuffling
						   isActiveDevice:(BOOL)isActiveDevice
							   position:(NSTimeInterval)position;
@end
