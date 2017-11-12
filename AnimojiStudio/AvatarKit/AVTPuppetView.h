@import Foundation;
@import ARKit;

@class AVTPuppet;
#import "AVTAvatarView.h"

@interface AVTPuppetView: AVTAvatarView

@property (getter=isPreviewing, nonatomic, readonly) bool previewing;
@property (getter=isRecording, nonatomic, readonly) bool recording;

- (void)audioPlayerItemDidReachEnd:(id)arg1;
- (bool)exportMovieToURL:(NSURL *)movieURL options:(NSDictionary *)options completionHandler:(void (^)(NSError *error))completion;

- (NSTimeInterval)recordingDuration;

- (void)startPreviewing;
- (void)startRecording;

- (void)stopPreviewing;
- (void)stopRecording;

- (void)faceIsFullyActive;
- (void)fadePuppetToWhite:(int)arg;

- (void)setup;

@property (readonly) AVTPuppet *puppet;

@property (nonatomic, readonly) ARSession *arSession;

@end
