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

@interface RecordingViewController ()

@property (nonatomic, strong) ASPuppetView *puppetView;

@property (nonatomic, strong) AVTPuppet *puppet;
@property (nonatomic, strong) AVTAvatarInstance *avatarInstance;

@property (nonatomic, strong) UILabel *instructionLabel;

@property (nonatomic, strong) UIStackView *microphoneSettingsStack;
@property (nonatomic, strong) UILabel *microphoneLabel;
@property (nonatomic, strong) UISwitch *microphoneSwitch;

@end

@implementation RecordingViewController

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
    
    [self _installInstructionLabel];
    [self _installSettingsUI];
}

- (void)_installInstructionLabel
{
    self.instructionLabel = [UILabel new];
    self.instructionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.instructionLabel.text = @"Tap on the screen to start recording, tap again to stop recording.";
    self.instructionLabel.numberOfLines = 0;
    self.instructionLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.instructionLabel.textAlignment = NSTextAlignmentCenter;
    self.instructionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.instructionLabel.textColor = [UIColor grayColor];
    [self.view addSubview:self.instructionLabel];
    
    [self.instructionLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:22].active = YES;
    [self.instructionLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-22].active = YES;
    [self.instructionLabel.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-32].active = YES;
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

- (void)hideControls
{
    [UIView animateWithDuration:0.3 animations:^{
        self.instructionLabel.alpha = 0;
        self.microphoneSettingsStack.alpha = 0;
    } completion:^(BOOL finished) {
        [self.instructionLabel setHidden:YES];
        [self.microphoneSettingsStack setHidden:YES];
    }];
}

- (void)showControls
{
    [self.instructionLabel setHidden:NO];
    [self.microphoneSettingsStack setHidden:NO];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.instructionLabel.alpha = 1;
        self.microphoneSettingsStack.alpha = 1;
    }];
}

#pragma mark - Settings

- (void)_installSettingsUI
{
    self.microphoneLabel = [UILabel new];
    self.microphoneLabel.text = @"Record Audio";
    self.microphoneLabel.textColor = [UIColor darkGrayColor];
    
    self.microphoneSwitch = [UISwitch new];
    [self.microphoneSwitch addTarget:self action:@selector(microphoneEnabledSwitchAction:) forControlEvents:UIControlEventValueChanged];
    
    self.microphoneSettingsStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.microphoneLabel, self.microphoneSwitch]];
    self.microphoneSettingsStack.axis = UILayoutConstraintAxisHorizontal;
    self.microphoneSettingsStack.spacing = 8;
    
    self.microphoneSettingsStack.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.microphoneSettingsStack];
    
    [self.microphoneSettingsStack.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.microphoneSettingsStack.bottomAnchor constraintEqualToAnchor:self.instructionLabel.topAnchor constant:-22].active = YES;
}

- (IBAction)microphoneEnabledSwitchAction:(id)sender
{
    self.microphoneEnabled = self.microphoneSwitch.isOn;
}

@end
