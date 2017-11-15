//
//  RecordingViewController.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 11/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "RecordingViewController.h"

#import "AVTPuppet.h"

#import "ASPuppetView.h"
#import "ASColorWell.h"

#import "ColorSheetViewController.h"

@interface RecordingViewController ()

@property (nonatomic, strong) ASPuppetView *puppetView;

@property (nonatomic, strong) AVTPuppet *puppet;
@property (nonatomic, strong) AVTAvatarInstance *avatarInstance;

@property (nonatomic, strong) UIVisualEffectView *settingsContainer;
@property (nonatomic, strong) UIStackView *settingsStack;

@property (nonatomic, strong) UILabel *instructionLabel;

@property (nonatomic, strong) UIStackView *microphoneSettingsStack;
@property (nonatomic, strong) UILabel *microphoneLabel;
@property (nonatomic, strong) UISwitch *microphoneSwitch;

@property (nonatomic, strong) UIStackView *bgColorStack;
@property (nonatomic, strong) UILabel *bgColorLabel;
@property (nonatomic, strong) ASColorWell *bgColorWell;

@property (nonatomic, strong) ColorSheetViewController *colorSheet;

@end

@implementation RecordingViewController

NSString * const kMicrophoneEnabled = @"kMicrophoneEnabled";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view setOpaque:YES];
    
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    self.title = @"Record";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(build) withObject:nil afterDelay:0.5];
}

- (void)build
{
    if (self.puppetView) return;
    
    self.puppetView = [ASPuppetView new];
    self.puppetView.alpha = 0;
    self.puppetView.frame = self.view.bounds;
    self.puppetView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.puppetView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.puppetView];

    if (self.avatarInstance) [self.puppetView setAvatarInstance:self.avatarInstance];

    [self.puppetView resetTracking];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.puppetView.alpha = 1;
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recordTapped:)];
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(broadcastTapped:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    [tap requireGestureRecognizerToFail:doubleTap];
    
    [self _installSettingsUI];
    
    [self.microphoneSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:kMicrophoneEnabled]];
    [self microphoneEnabledSwitchAction:self.microphoneSwitch];
}

- (void)setPuppetName:(NSString *)puppetName
{
    _puppetName = [puppetName copy];
    
    self.avatarInstance = (AVTAvatarInstance *)[AVTPuppet puppetNamed:_puppetName options:nil];
}

- (void)setAvatarInstance:(AVTAvatarInstance *)avatarInstance
{
    _avatarInstance = avatarInstance;
    
    [self.puppetView setAvatarInstance:_avatarInstance];
}

#pragma mark - Actions

- (IBAction)recordTapped:(id)sender
{
    [self.puppetView resetTracking];
    [self.delegate recordingViewControllerDidTapRecord:self];
}

- (IBAction)broadcastTapped:(id)sender
{
    [self.puppetView resetTracking];
    [self.delegate recordingViewControllerDidTapBroadcast:self];
}

- (void)hideControls
{
    [UIView animateWithDuration:0.3 animations:^{
        self.settingsContainer.alpha = 0;
    } completion:^(BOOL finished) {
        [self.settingsContainer setHidden:YES];
    }];
}

- (void)showControls
{
    [self.settingsContainer setHidden:NO];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.settingsContainer.alpha = 1;
    }];
}

#pragma mark - Settings

- (UIBlurEffect *)_settingsUIEffect
{
    return [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
}

- (void)_installSettingsUI
{
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
    [self.settingsStack.bottomAnchor constraintEqualToAnchor:self.settingsContainer.safeAreaLayoutGuide.bottomAnchor constant: -8].active = YES;
    
    [self _installMicrophoneSettingsUI];
    [self _installColorSettingsUI];
    [self _installInstructionLabel];
    
    [self.settingsStack setCustomSpacing:24 afterView:self.bgColorStack];
    
    [self.view addSubview:self.settingsContainer];
    
    [self.settingsContainer.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.settingsContainer.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
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
    self.microphoneEnabled = self.microphoneSwitch.isOn;
    [[NSUserDefaults standardUserDefaults] setBool:self.microphoneEnabled forKey:kMicrophoneEnabled];
}

- (void)_installInstructionLabel
{
    self.instructionLabel = [UILabel new];
    self.instructionLabel.text = @"Tap on the screen to start recording, tap again to stop recording. Double tap to live stream.";
    self.instructionLabel.numberOfLines = 0;
    self.instructionLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.instructionLabel.textAlignment = NSTextAlignmentCenter;
    self.instructionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.instructionLabel.textColor = [UIColor grayColor];
    
    [self.settingsStack addArrangedSubview:self.instructionLabel];
    
    [self.instructionLabel.widthAnchor constraintLessThanOrEqualToAnchor:self.settingsStack.widthAnchor multiplier:0.9].active = YES;
}

#pragma mark - Color customization

- (void)setSceneBackgroundColor:(UIColor *)color
{
    self.puppetView.scene.background.contents = color;
    self.bgColorWell.color = color;
    
    [self _toggleSettingsBackgroundEffectWithColor:color];
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

- (IBAction)tappedColorWell:(id)sender
{
    [self showColorSheet];
}

- (void)showColorSheet
{
    if (!self.colorSheet) {
        self.colorSheet = [ColorSheetViewController new];
        [self.colorSheet addObserver:self forKeyPath:@"color" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    id sceneBg = self.puppetView.scene.background.contents;
    if ([sceneBg isKindOfClass:[UIColor class]]) {
        self.colorSheet.color = sceneBg;
    } else {
        self.colorSheet.color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    }
    
    [self presentViewController:self.colorSheet animated:YES completion:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"color"]) {
        [self setSceneBackgroundColor:self.colorSheet.color];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc
{
    [self.colorSheet removeObserver:self forKeyPath:@"color"];
}

@end
