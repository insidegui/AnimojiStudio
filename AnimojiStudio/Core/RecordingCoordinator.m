//
//  RecordingCoordinator.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 12/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "RecordingCoordinator.h"

@import ReplayKit;
@import AVFoundation;

@interface RecordingCoordinator () <RPPreviewViewControllerDelegate>

@property (nonatomic, strong) RPScreenRecorder *recorder;
@property (nonatomic, assign, getter=isRecording) BOOL recording;

@property (nonatomic, strong) AVAssetWriter *assetWriter;
@property (nonatomic, strong) AVAssetWriterInput *videoInput;
@property (nonatomic, strong) AVAssetWriterInput *audioInput;

@property (nonatomic, assign) BOOL videoSessionStarted;
@property (nonatomic, assign) BOOL micSessionStarted;

@end

@implementation RecordingCoordinator

+ (BOOL)shouldUseDumbRecordingMode
{
    return NO;
}

- (void)startRecordingWithAudio:(BOOL)shouldCaptureAudio frontCameraPreview:(BOOL)shouldCaptureFrontCamera
{
    if (!self.recorder) {
        self.recorder = [RPScreenRecorder sharedRecorder];
        self.recorder.microphoneEnabled = shouldCaptureAudio;
        self.recorder.cameraEnabled = shouldCaptureFrontCamera;
    }
    
    if ([RecordingCoordinator shouldUseDumbRecordingMode]) {
        [self _startDumbRecording];
    } else {
        [self _startSmartRecording];
    }
}

- (void)stopRecording
{
    if ([RecordingCoordinator shouldUseDumbRecordingMode]) {
        [self _stopDumbRecording];
    } else {
        [self _stopSmartRecordingWithError:nil];
    }
}

#pragma mark Dumb Recording

- (void)_startDumbRecording
{
    __weak typeof(self) weakSelf = self;
    [self.recorder startRecordingWithHandler:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                weakSelf.recording = YES;
                return;
            }
            
            [weakSelf.delegate recordingCoordinator:weakSelf recordingDidFailWithError:error];
        });
    }];
}

- (void)_stopDumbRecording
{
    __weak typeof(self) weakSelf = self;
    [self.recorder stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.recording = NO;
            
            if (error || !previewViewController) {
                [weakSelf.delegate recordingCoordinator:weakSelf recordingDidFailWithError:error];
            } else {
                previewViewController.previewControllerDelegate = weakSelf;
                [weakSelf.delegate recordingCoordinator:weakSelf wantsToPresentRecordingPreviewWithController:previewViewController];
            }
        });
    }];
}

#pragma mark Smart Recording

- (NSURL *)_recordingURL
{
    NSString *basePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [basePath stringByAppendingPathComponent:@"Recordings"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filename = [NSString stringWithFormat:@"AnimojiRecording_%.0f.mov", [NSDate date].timeIntervalSince1970];
    
    NSURL *url = [NSURL fileURLWithPath:[NSString pathWithComponents:@[path, filename]]];
    
#ifdef DEBUG
    NSLog(@"Recording Output URL: %@", url);
#endif
    
    return url;
}

- (void)_startSmartRecording
{
#ifdef DEBUG
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ASDemoMode"]) {
        self.recording = YES;
        return;
    }
#endif
    
    NSError *writerError;
    self.assetWriter = [AVAssetWriter assetWriterWithURL:[self _recordingURL] fileType:AVFileTypeQuickTimeMovie error:&writerError];
    
    NSDictionary <NSString *, id> *aperture = @{
                                                AVVideoCleanApertureWidthKey: @(1024),
                                                AVVideoCleanApertureHeightKey: @(1024),
                                                AVVideoCleanApertureVerticalOffsetKey: @(10),
                                                AVVideoCleanApertureHorizontalOffsetKey: @(10)
                                                };
    
    NSDictionary <NSString *, id> *aspectRatio = @{
                                                   AVVideoPixelAspectRatioVerticalSpacingKey: @1,
                                                   AVVideoPixelAspectRatioHorizontalSpacingKey: @1
                                                   };
    
    NSDictionary <NSString *, id> *compressionSettings = @{
                                                           AVVideoPixelAspectRatioKey: aspectRatio,
                                                           AVVideoCleanApertureKey: aperture
                                                           };
    
    NSDictionary <NSString *, id> *videoSettings = @{
                                                     AVVideoCompressionPropertiesKey: compressionSettings,
                                                     AVVideoCodecKey: AVVideoCodecTypeHEVC,
                                                     AVVideoWidthKey: @(1024),
                                                     AVVideoHeightKey: @(1024),
                                                     AVVideoScalingModeKey: AVVideoScalingModeResizeAspectFill
                                                     };
    
    NSDictionary <NSString *, id> *audioSettings = @{
                                                     AVFormatIDKey: @(kAudioFormatMPEG4AAC),
                                                     AVNumberOfChannelsKey: @(2),
                                                     AVSampleRateKey: @(44100.0),
                                                     AVEncoderBitRateKey: @(128000)
                                                     };
    
    self.videoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    self.audioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:audioSettings];
    
    self.videoInput.expectsMediaDataInRealTime = YES;
    self.audioInput.expectsMediaDataInRealTime = YES;
    
    [self.assetWriter addInput:self.videoInput];
    [self.assetWriter addInput:self.audioInput];
    
    if (writerError) {
        [self.delegate recordingCoordinator:self recordingDidFailWithError:writerError];
        return;
    }
    
    if (![self.assetWriter startWriting]) {
        [self _stopSmartRecordingWithError:self.assetWriter.error];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.recorder startCaptureWithHandler:^(CMSampleBufferRef  _Nonnull sampleBuffer, RPSampleBufferType bufferType, NSError * _Nullable error) {
        if (!CMSampleBufferDataIsReady(sampleBuffer)) return;
        
        if (self.assetWriter.status != AVAssetWriterStatusWriting) return;
        
        switch (bufferType) {
            case RPSampleBufferTypeVideo:
                if (!weakSelf.videoSessionStarted) {
                    weakSelf.videoSessionStarted = YES;
                    [self.assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
                }
                
                if (weakSelf.videoInput.isReadyForMoreMediaData) {
                    [weakSelf.videoInput appendSampleBuffer:sampleBuffer];
                }
                break;
            case RPSampleBufferTypeAudioMic:
                if (!weakSelf.micSessionStarted) {
                    weakSelf.micSessionStarted = YES;
                    [self.assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
                }
                
                if (weakSelf.audioInput.isReadyForMoreMediaData) {
                    [weakSelf.audioInput appendSampleBuffer:sampleBuffer];
                }
                break;
            default: break;
        }
    } completionHandler:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [weakSelf.delegate recordingCoordinator:weakSelf recordingDidFailWithError:error];
            } else {
                weakSelf.recording = YES;
            }
        });
    }];
}

- (void)_stopSmartRecordingWithError:(NSError *)inputError
{
#ifdef DEBUG
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ASDemoMode"]) {
        self.recording = NO;
        [self.delegate recordingCoordinatorDidFinishRecording:self];
        return;
    }
#endif
    
    if (inputError) {
        [self.recorder stopCaptureWithHandler:nil];
        [self.delegate recordingCoordinator:self recordingDidFailWithError:inputError];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.recorder stopCaptureWithHandler:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.recording = NO;
            
            if (error) {
                [weakSelf.delegate recordingCoordinator:self recordingDidFailWithError:error];
            }
            
            [weakSelf.assetWriter finishWritingWithCompletionHandler:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.delegate recordingCoordinatorDidFinishRecording:weakSelf];
                });
            }];
        });
    }];
}

- (NSURL *)videoURL
{
#ifdef DEBUG
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ASDemoMode"]) {
        return [[NSBundle mainBundle] URLForResource:@"Foxie" withExtension:@"mov"];
    }
#endif
    
    return self.assetWriter.outputURL;
}

#pragma mark Preview Controller

- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController
{
    [previewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)previewController:(RPPreviewViewController *)previewController didFinishWithActivityTypes:(NSSet<NSString *> *)activityTypes
{
    [previewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
