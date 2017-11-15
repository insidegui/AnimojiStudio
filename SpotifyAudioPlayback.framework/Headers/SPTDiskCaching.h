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

/**
 @brief The `SPTDiskCaching` protocol is implemented by classes that handle caching of Spotify data to persistent storage.
 
 Methods of this protocol will be called from within Spotify SDK when it requires access to persistent storage for caching.

 */
@protocol SPTDiskCaching <NSObject>

/**
 Creates a disk cache of certain size or changes the size of an existing cache.

 This method will be called when a new cache needs to be created or when the size of an existing cache needs to be changed. The cache should be accessible via other 'SPTDiskCaching' methods when using the same key as provided in this method.

 @param key An alphanumeric string, through which the cache is identified and accessed via 'SPTDiskCaching' methods.
 @param size The requested amount of bytes in the cache.
 @return `YES` if the cache of requested size has been allocated successfully, otherwise `NO`.
 */
- (BOOL)allocateCacheWithKey:(NSString *)key
                        size:(NSUInteger)size;

/**
 Reads data from the existing disk cache.

 This method will be called whenever a data needs to be read from the existing disk cache. The cache is identified by its key.

 @param key The identifier of the cache.
 @param length The amount of bytes to be read from the cache.
 @param offset The amount of bytes to be skipped from the beginning of the cache before reading starts.
 @return An instance of NSData containing the data read from the cache; 'nil' if reading failed.
 */
- (NSData *)readCacheDataWithKey:(NSString *)key
                          length:(NSUInteger)length
                          offset:(NSUInteger)offset;

/**
 Writes data to the existing disk cache.

 This method will be called whenever a data needs to be written to the existing disk cache. The cache is identified by its key.

 @param key The identifier of the cache.
 @param data Bytes to be written to the cache.
 @param offset The amount of bytes to be skipped from the beginning of the cache before writing starts.
 @return `YES` if writing to the cache has been successful, otherwise 'NO'.
 */
- (BOOL)writeCacheDataWithKey:(NSString *)key
                         data:(NSData *)data
                       offset:(NSUInteger)offset;

/**
 Closes the existing disk cache.

 This method will be called when a cache is no longer needed and can be deleted.

 @param key The identifier of the cache.

 */
- (void)closeCacheWithKey:(NSString *)key;

@end



