@import Foundation;
@import ARKit;

@class AVTAvatar;
#import "AVTView.h"

@interface AVTRecordView: AVTView

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

- (void)setAvatar:(id)arg1;

- (void)setup;

@property (readonly) AVTAnimoji *puppet;

@property (nonatomic, readonly) ARSession *arSession;

@end
