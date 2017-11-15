//
//  RecordingFlowController.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 11/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "RecordingFlowController.h"

#import "PuppetSelectionViewController.h"
#import "RecordingViewController.h"

#import "UIViewController+Children.h"

#import "RecordingCoordinator.h"

#import "RecordingStatusViewController.h"

#import "SharingFlowController.h"

@import ReplayKit;

@interface RecordingFlowController () <RPBroadcastActivityViewControllerDelegate, RPBroadcastControllerDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, weak) PuppetSelectionViewController *puppetSelectionController;
@property (nonatomic, weak) RecordingViewController *recordingController;

@property (nonatomic, strong) UIWindow *statusWindow;
@property (nonatomic, strong) RecordingStatusViewController *statusController;

@property (nonatomic, strong) RecordingCoordinator *coordinator;
@property (nonatomic, strong) RPBroadcastController *broadcastController;

@property (nonatomic, strong) UIImpactFeedbackGenerator *interactionHaptics;
@property (nonatomic, strong) UINotificationFeedbackGenerator *notificationHaptics;

@property (nonatomic, strong) SharingFlowController *sharingFlow;

@end

@interface RecordingFlowController (PuppetSelection) <PuppetSelectionDelegate>
@end

@interface RecordingFlowController (RecordingController) <RecordingViewControllerDelegate>
@end

@interface RecordingFlowController (RecordingCoordinator) <RecordingCoordinatorDelegate>
@end

@interface RecordingFlowController (RecordingStatus) <RecordingStatusViewControllerDelegate>
@end

@implementation RecordingFlowController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setupHaptics];
    
    PuppetSelectionViewController *selection = [PuppetSelectionViewController new];
    selection.delegate = self;
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:selection];
    
    [self installChildViewController:self.navigationController];
    
    self.puppetSelectionController = selection;
}

#pragma mark - Puppet Selection

- (void)puppetSelectionViewController:(PuppetSelectionViewController *)controller didSelectPuppetWithName:(NSString *)puppetName
{
    RecordingViewController *recording = [RecordingViewController new];
    recording.delegate = self;
    
    [self.navigationController pushViewController:recording animated:YES];
    recording.puppetName = puppetName;
    
    self.recordingController = recording;
}

#pragma mark - Recording

- (void)recordingCoordinator:(RecordingCoordinator *)coordinator recordingDidFailWithError:(NSError *)error
{
    NSString *errorMessage = (error.localizedDescription) ? error.localizedDescription : @"Unknown error";
    NSString *message = [NSString stringWithFormat:@"Sorry, the recording failed.\n%@", errorMessage];
    
    [self presentErrorControllerWithMessage:message];
    
    [self _performEventTapWithError:YES];
}

- (void)recordingCoordinator:(RecordingCoordinator *)coordinator wantsToPresentRecordingPreviewWithController:(__kindof UIViewController *)previewController
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController presentViewController:previewController animated:YES completion:nil];
    });
}

- (void)recordingCoordinatorDidFinishRecording:(RecordingCoordinator *)coordinator
{
    self.sharingFlow = [SharingFlowController new];
    
    self.sharingFlow.videoURL = self.coordinator.videoURL;
    
    [self.navigationController presentViewController:self.sharingFlow animated:YES completion:nil];
}

- (void)recordingViewControllerDidTapRecord:(RecordingViewController *)controller
{
    if (self.coordinator.isRecording) {
        [self stopRecording];
    } else {
        [self startRecording];
    }
}

- (void)startRecording
{
    self.coordinator = [RecordingCoordinator new];
    self.coordinator.delegate = self;
    
    [self transitionToRecordingState];
    
    [self.coordinator startRecordingWithAudio:self.recordingController.isMicrophoneEnabled frontCameraPreview:NO];
    
    [self _performLightTap];
}

- (void)stopRecording
{
    [self.coordinator stopRecording];
    [self transitionToNormalState];
    
    [self _performEventTapWithError:NO];
}

#pragma mark - Broadcasting

- (void)recordingViewControllerDidTapBroadcast:(RecordingViewController *)controller
{
    if (self.broadcastController.isBroadcasting) return;
    
    [self startBroadcasting];
}

- (void)startBroadcasting
{
    if (!self.broadcastController) {
        self.broadcastController = [RPBroadcastController new];
        self.broadcastController.delegate = self;
    }
    
#ifdef DEBUG
    NSLog(@"MIC ENABLED = %d", self.recordingController.isMicrophoneEnabled);
#endif

    [RPScreenRecorder sharedRecorder].microphoneEnabled = self.recordingController.isMicrophoneEnabled;
    
    [RPBroadcastActivityViewController loadBroadcastActivityViewControllerWithHandler:^(RPBroadcastActivityViewController * _Nullable broadcastActivityViewController, NSError * _Nullable error) {
        if (error) {
            [self presentErrorControllerWithMessage:error.localizedDescription];
            return;
        }
        
        broadcastActivityViewController.delegate = self;
        [self presentViewController:broadcastActivityViewController animated:YES completion:nil];
    }];
}

- (void)stopBroadcasting
{
    [self.broadcastController finishBroadcastWithHandler:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) [self presentErrorControllerWithMessage:error.localizedDescription];
            
            [self transitionToNormalState];
        });
    }];
}

- (void)broadcastActivityViewController:(RPBroadcastActivityViewController *)broadcastActivityViewController didFinishWithBroadcastController:(RPBroadcastController *)broadcastController error:(NSError *)error
{
    [broadcastActivityViewController dismissViewControllerAnimated:YES completion:^{
        if (error) {
            [self presentErrorControllerWithMessage:error.localizedDescription];
            return;
        }
        
        [self.broadcastController startBroadcastWithHandler:^(NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [self presentErrorControllerWithMessage:error.localizedDescription];
                } else {
                    [self transitionToBroadcastingState];
                }
            });
        }];
    }];
}

- (void)broadcastController:(RPBroadcastController *)broadcastController didUpdateServiceInfo:(NSDictionary<NSString *,NSObject<NSCoding> *> *)serviceInfo
{
#ifdef DEBUG
    NSLog(@"INFO: %@", serviceInfo);
#endif
}

- (void)broadcastController:(RPBroadcastController *)broadcastController didUpdateBroadcastURL:(NSURL *)broadcastURL
{
#ifdef DEBUG
    NSLog(@"BROADCAST URL = %@", broadcastURL);
#endif
}

- (void)broadcastController:(RPBroadcastController *)broadcastController didFinishWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self transitionToNormalState];
        
        if (error) [self presentErrorControllerWithMessage:error.localizedDescription];
    });
}

- (void)transitionToBroadcastingState
{
    [self transitionToRecordingState];
    [self _performLightTap];
}

#pragma mark - UI management for recording state

- (void)transitionToRecordingState
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.recordingController hideControls];
    
    [self installStatusWindow];
    [self.statusController startCountingTime];
}

- (void)transitionToNormalState
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.recordingController showControls];
    
    [self.statusController stopCountingTime];
    [self hideStatusWindow];
}

#pragma mark Status

- (void)installStatusWindow
{
    if (!self.statusWindow) {
        self.statusController = [RecordingStatusViewController new];
        
        self.statusController.delegate = self;
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        self.statusWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, screenHeight - 155, width, 155)];
        [self.statusWindow setRootViewController:self.statusController];
        
        [self.statusWindow setWindowLevel:CGFLOAT_MAX];
        self.statusWindow.screen = [UIScreen mainScreen];
    }
    
    self.statusWindow.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [self.statusWindow setHidden:NO];
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.statusWindow.alpha = 1;
        self.statusWindow.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideStatusWindow
{
    [UIView animateWithDuration:0.3 animations:^{
        self.statusWindow.alpha = 0;
    } completion:^(BOOL finished) {
        [self.statusWindow setHidden:YES];
    }];
}

- (void)recordingStatusControllerDidSelectStop:(RecordingStatusViewController *)controller
{
    if (self.broadcastController.isBroadcasting) {
        [self stopBroadcasting];
    } else {
        [self stopRecording];
    }
}

#pragma mark Haptics

- (void)_setupHaptics
{
    self.interactionHaptics = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    self.notificationHaptics = [[UINotificationFeedbackGenerator alloc] init];
}

- (void)_performLightTap
{
    [self.interactionHaptics prepare];
    [self.interactionHaptics impactOccurred];
}

- (void)_performEventTapWithError:(BOOL)isError
{
    [self.notificationHaptics prepare];
    
    UINotificationFeedbackType type = isError ? UINotificationFeedbackTypeError : UINotificationFeedbackTypeSuccess;
    [self.notificationHaptics notificationOccurred:type];
}

@end
