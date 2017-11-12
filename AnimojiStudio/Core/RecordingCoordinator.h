//
//  RecordingCoordinator.h
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 12/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

@import UIKit;

@class RecordingCoordinator;

@protocol RecordingCoordinatorDelegate <NSObject>

- (void)recordingCoordinator:(RecordingCoordinator *)coordinator recordingDidFailWithError:(NSError *)error;
- (void)recordingCoordinator:(RecordingCoordinator *)coordinator wantsToPresentRecordingPreviewWithController:(__kindof UIViewController *)previewController;
- (void)recordingCoordinatorDidFinishRecording:(RecordingCoordinator *)coordinator;

@end

@interface RecordingCoordinator : NSObject

@property (nonatomic, weak) id<RecordingCoordinatorDelegate> delegate;

@property (nonatomic, readonly, getter=isRecording) BOOL recording;

- (void)startRecordingWithAudio:(BOOL)shouldCaptureAudio frontCameraPreview:(BOOL)shouldCaptureFrontCamera;
- (void)stopRecording;

@property (nonatomic, readonly) NSURL *videoURL;

@end
