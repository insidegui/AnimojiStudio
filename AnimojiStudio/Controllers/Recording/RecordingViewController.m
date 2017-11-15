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
#import "RecordingSettingsViewController.h"

@interface RecordingViewController () <RecordingSettingsViewControllerDelegate>

@property (nonatomic, strong) ASPuppetView *puppetView;

@property (nonatomic, strong) AVTPuppet *puppet;
@property (nonatomic, strong) AVTAvatarInstance *avatarInstance;

@property (nonatomic, strong) ColorSheetViewController *colorSheet;

@property (nonatomic, strong) UIWindow *settingsContainer;
@property (nonatomic, weak) RecordingSettingsViewController *settingsController;

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
    
    [self _loadMicPreference];
}

- (void)_loadMicPreference
{
    BOOL savedMicEnabledSetting = [[NSUserDefaults standardUserDefaults] boolForKey:kMicrophoneEnabled];
    
    self.settingsController.microphoneEnabled = savedMicEnabledSetting;
    self.microphoneEnabled = savedMicEnabledSetting;
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

- (void)_installSettingsUI
{
    RecordingSettingsViewController *settings = [RecordingSettingsViewController new];
    
    settings.delegate = self;
    
    self.settingsContainer = [UIWindow new];
    [self.settingsContainer setOpaque:NO];
    [self.settingsContainer setBackgroundColor:[UIColor clearColor]];
    [self.settingsContainer setWindowLevel:CGFLOAT_MAX];
    [self.settingsContainer setRootViewController:settings];
    self.settingsContainer.screen = [UIScreen mainScreen];
    
    self.settingsContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.settingsController = settings;
    self.settingsController.containerViewController = self;
    self.settingsController.containerWindow = self.settingsContainer;
    
    [self.settingsController resizeWindow];
    [self.settingsContainer setHidden:NO];
}

- (void)recordingSettingsViewControllerDidTapKaraoke:(RecordingSettingsViewController *)controller
{
    [self.delegate recordingViewControllerDidTapKaraoke:self];
}

- (void)recordingSettingsViewControllerDidTapChooseBackgroundColor:(RecordingSettingsViewController *)controller
{
    [self showColorSheet];
}

- (void)recordingSettingsViewController:(RecordingSettingsViewController *)controller didChangeMicrophoneEnabled:(BOOL)isEnabled
{
    self.microphoneEnabled = isEnabled;
    
    [[NSUserDefaults standardUserDefaults] setBool:isEnabled forKey:kMicrophoneEnabled];
}

#pragma mark - Color customization

- (void)setSceneBackgroundColor:(UIColor *)color
{
    self.puppetView.scene.background.contents = color;
    self.settingsController.sceneBackgroundColor = color;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showControls];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self hideControls];
}

@end
