//
//  RecordingSettingsViewController.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 15/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "RecordingSettingsViewController.h"

#import "ASColorWell.h"

@interface RecordingSettingsViewController ()

@property (nonatomic, strong) UIVisualEffectView *settingsContainer;
@property (nonatomic, strong) UIStackView *settingsStack;

@property (nonatomic, strong) UILabel *instructionLabel;

@property (nonatomic, strong) UIStackView *microphoneSettingsStack;
@property (nonatomic, strong) UILabel *microphoneLabel;
@property (nonatomic, strong) UISwitch *microphoneSwitch;

@property (nonatomic, strong) UIStackView *bgColorStack;
@property (nonatomic, strong) UILabel *bgColorLabel;
@property (nonatomic, strong) ASColorWell *bgColorWell;

@property (nonatomic, strong) UIButton *karaokeButton;
@property (nonatomic, strong) UIButton *karaokePlayButton;

@end

@implementation RecordingSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self build];
}

- (void)build
{
    [self _installSettingsUI];
}

- (UIBlurEffect *)_settingsUIEffect
{
    return [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
}

- (void)_installSettingsUI
{
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view.widthAnchor constraintEqualToConstant:[UIScreen mainScreen].bounds.size.width].active = YES;
    
    self.settingsContainer = [[UIVisualEffectView alloc] initWithEffect:nil];
    self.settingsContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.settingsStack = [UIStackView new];
    self.settingsStack.alignment = UIStackViewAlignmentCenter;
    self.settingsStack.axis = UILayoutConstraintAxisVertical;
    self.settingsStack.spacing = 8;
    self.settingsStack.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.settingsContainer.contentView addSubview:self.settingsStack];
    [self.settingsStack.leadingAnchor constraintEqualToAnchor:self.settingsContainer.leadingAnchor].active = YES;
    [self.settingsStack.trailingAnchor constraintEqualToAnchor:self.settingsContainer.trailingAnchor].active = YES;
    [self.settingsStack.topAnchor constraintEqualToAnchor:self.settingsContainer.topAnchor constant: 16].active = YES;
    [self.settingsStack.bottomAnchor constraintEqualToAnchor:self.settingsContainer.safeAreaLayoutGuide.bottomAnchor constant: -36].active = YES;
    
    [self _installMicrophoneSettingsUI];
    [self _installColorSettingsUI];
    [self _installKaraokeUI];
    
    [self _installInstructionLabel];
    
    [self.settingsStack setCustomSpacing:24 afterView:self.bgColorStack];
    
    [self.view addSubview:self.settingsContainer];
    
    [self.settingsContainer.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.settingsContainer.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.settingsContainer.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.settingsContainer.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
}

- (void)_installMicrophoneSettingsUI
{
    self.microphoneLabel = [UILabel new];
    self.microphoneLabel.text = @"Enable Microphone";
    self.microphoneLabel.textColor = [UIColor darkGrayColor];
    
    self.microphoneSwitch = [UISwitch new];
    [self.microphoneSwitch addTarget:self action:@selector(microphoneEnabledSwitchAction:) forControlEvents:UIControlEventValueChanged];
    
    self.microphoneSettingsStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.microphoneLabel, self.microphoneSwitch]];
    self.microphoneSettingsStack.axis = UILayoutConstraintAxisHorizontal;
    self.microphoneSettingsStack.spacing = 8;
    
    [self.settingsStack addArrangedSubview:self.microphoneSettingsStack];
}

- (void)_installColorSettingsUI
{
    self.bgColorLabel = [UILabel new];
    self.bgColorLabel.text = @"Background Color";
    self.bgColorLabel.textColor = [UIColor darkGrayColor];
    
    self.bgColorWell = [ASColorWell new];
    [self.bgColorWell addTarget:self action:@selector(tappedColorWell:) forControlEvents:UIControlEventTouchDown];
    
    self.bgColorStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.bgColorLabel, self.bgColorWell]];
    self.bgColorStack.axis = UILayoutConstraintAxisHorizontal;
    self.bgColorStack.spacing = 8;
    
    [self.settingsStack addArrangedSubview:self.bgColorStack];
}

- (IBAction)microphoneEnabledSwitchAction:(id)sender
{
    [self.delegate recordingSettingsViewController:self didChangeMicrophoneEnabled:self.microphoneSwitch.isOn];
}

- (void)_installInstructionLabel
{
    self.instructionLabel = [UILabel new];
    self.instructionLabel.text = @"Tap on the screen to start recording, tap again to stop recording.\nDouble tap to live stream.";
    self.instructionLabel.numberOfLines = 0;
    self.instructionLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.instructionLabel.textAlignment = NSTextAlignmentCenter;
    self.instructionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.instructionLabel.textColor = [UIColor grayColor];
    
    [self.settingsStack addArrangedSubview:self.instructionLabel];
    
    [self.instructionLabel.widthAnchor constraintLessThanOrEqualToAnchor:self.settingsStack.widthAnchor multiplier:0.9].active = YES;
}

- (void)_installKaraokeUI
{
    UIStackView *karaokeStackView = [UIStackView new];
    karaokeStackView.alignment = UIStackViewAlignmentCenter;
    karaokeStackView.axis = UILayoutConstraintAxisHorizontal;
    karaokeStackView.spacing = 8;
    karaokeStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.karaokeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.karaokeButton setTitle:@"Configure Karaoke" forState:UIControlStateNormal];
    [self.karaokeButton addTarget:self action:@selector(karaokeTapped:) forControlEvents:UIControlEventTouchUpInside];
    [karaokeStackView addArrangedSubview:self.karaokeButton];

    self.karaokePlayButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.karaokePlayButton setImage:[UIImage imageNamed:@"previewPlay"] forState:UIControlStateNormal];
    [self.karaokePlayButton addTarget:self action:@selector(karaokePlayPauseTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.karaokePlayButton.widthAnchor constraintEqualToConstant:30].active = YES;
    [self.karaokePlayButton.heightAnchor constraintEqualToConstant:30].active = YES;
    [karaokeStackView addArrangedSubview:self.karaokePlayButton];
    
    [self.karaokePlayButton setHidden:YES];
    
    [self.settingsStack addArrangedSubview:karaokeStackView];
}

- (IBAction)tappedColorWell:(id)sender
{
    [self.delegate recordingSettingsViewControllerDidTapChooseBackgroundColor:self];
}

- (IBAction)karaokeTapped:(id)sender
{
    [self.delegate recordingSettingsViewControllerDidTapKaraoke:self];
}

- (IBAction)karaokePlayPauseTapped:(id)sender
{
    if ([self.delegate recordingSettingsViewControllerDidTapKaraokePlayPause:self]) {
        [self.karaokePlayButton setImage:[UIImage imageNamed:@"previewStop"] forState:UIControlStateNormal];
    } else {
        [self.karaokePlayButton setImage:[UIImage imageNamed:@"previewPlay"] forState:UIControlStateNormal];
    }
}

- (void)resetKaraokePlayButtonState {
    [self.karaokePlayButton setImage:[UIImage imageNamed:@"previewPlay"] forState:UIControlStateNormal];
}

- (void)setKaraokePlayButtonHidden:(BOOL)isHidden
{
    [self.karaokePlayButton setHidden:isHidden];
}

- (void)_toggleSettingsBackgroundEffectWithColor:(UIColor *)color
{
    CGFloat r;
    CGFloat g;
    CGFloat b;
    if ([color getRed:&r green:&g blue:&b alpha:nil]) {
        [UIView animateWithDuration:0.3 animations:^{
            if (r < 0.8 || g < 0.8 || b < 0.8) {
                [self.settingsContainer setEffect:[self _settingsUIEffect]];
            } else {
                [self.settingsContainer setEffect:nil];
            }
        }];
    }
}

- (void)setSceneBackgroundColor:(UIColor *)sceneBackgroundColor
{
    _sceneBackgroundColor = [sceneBackgroundColor copy];
    
    self.bgColorWell.color = _sceneBackgroundColor;
    [self _toggleSettingsBackgroundEffectWithColor:_sceneBackgroundColor];
}

- (void)setMicrophoneEnabled:(BOOL)microphoneEnabled
{
    _microphoneEnabled = microphoneEnabled;
    
    self.microphoneSwitch.on = _microphoneEnabled;
}

- (void)setAllowsMicrophoneRecording:(BOOL)allow
{
    [self.microphoneSettingsStack setHidden:!allow];
    
    if (!allow) [self setMicrophoneEnabled:NO];
}

#pragma mark Floating window layout management

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self resizeWindow];
}

- (void)resizeWindow
{
    if (!self.containerWindow || !self.containerViewController) return;
    
    CGSize parentSize = self.containerViewController.view.bounds.size;
    CGSize ourSize = self.view.bounds.size;
    
    self.containerWindow.frame = CGRectMake(0, parentSize.height - ourSize.height, ourSize.width, ourSize.height);
}

@end
