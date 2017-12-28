//
//  RecordingSettingsViewController.h
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 15/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

@import UIKit;

@class RecordingSettingsViewController;

@protocol RecordingSettingsViewControllerDelegate <NSObject>

- (void)recordingSettingsViewControllerDidTapKaraoke:(RecordingSettingsViewController *)controller;
- (BOOL)recordingSettingsViewControllerDidTapKaraokePlayPause:(RecordingSettingsViewController *)controller;
- (void)recordingSettingsViewController:(RecordingSettingsViewController *)controller didChangeMicrophoneEnabled:(BOOL)isEnabled;
- (void)recordingSettingsViewControllerDidTapChooseBackgroundColor:(RecordingSettingsViewController *)controller;

@end

@interface RecordingSettingsViewController : UIViewController

@property (nonatomic, weak) id<RecordingSettingsViewControllerDelegate> delegate;

@property (nonatomic, assign, getter=isMicrophoneEnabled) BOOL microphoneEnabled;
@property (nonatomic, copy) UIColor *sceneBackgroundColor;

@property (nonatomic, weak) UIWindow *containerWindow;
@property (nonatomic, weak) UIViewController *containerViewController;

- (void)resizeWindow;
- (void)resetKaraokePlayButtonState;

@end
