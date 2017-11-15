//
//  VideoPreviewViewController.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 12/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "VideoPreviewViewController.h"

#import "ASAppearance.h"

@import AVFoundation;

@interface VideoPreviewViewController ()

@property (nonatomic, copy) NSURL *previouslyLoadedVideo;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *videoLayer;

@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIButton *shareButton;

@end

@implementation VideoPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view setOpaque:YES];
    
    self.title = @"Share Video";
    
    [self build];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self _loadVideoIfNeeded];
}

- (void)build
{
    self.videoView = [UIView new];
    self.videoView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.videoView];
    
    [self.videoView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:1].active = YES;
    [self.videoView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:1].active = YES;
    [self.videoView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [self.videoView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    
    self.shareButton = [UIButton new];
    [self.shareButton setTitle:@"Share your creation" forState:UIControlStateNormal];
    self.shareButton.backgroundColor = [UIColor primaryColor];
    self.shareButton.tintColor = [UIColor whiteColor];
    self.shareButton.titleLabel.textColor = [UIColor whiteColor];
    self.shareButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    self.shareButton.layer.cornerRadius = 12;
    
    self.shareButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.shareButton];
    
    [self.shareButton.heightAnchor constraintEqualToConstant:50].active = YES;
    [self.shareButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:22].active = YES;
    [self.shareButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-22].active = YES;
    [self.shareButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-22].active = YES;
    
    [self.shareButton addTarget:self action:@selector(shareButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(togglePlaying:)];
    [self.videoView addGestureRecognizer:tap];
}

- (void)_loadVideoIfNeeded
{
    if (!self.videoURL || !self.isViewLoaded) return;
    
    if ([self.previouslyLoadedVideo isEqual:self.videoURL]) return;
    
    self.previouslyLoadedVideo = self.videoURL;
    
    [self.videoLayer removeFromSuperlayer];
    [self.player pause];
    [self.player cancelPendingPrerolls];
    
    self.player = [AVPlayer playerWithURL:self.videoURL];
    self.videoLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    self.videoLayer.frame = self.videoView.bounds;
    [self.videoView.layer addSublayer:self.videoLayer];
    
    [self.player play];
}

- (IBAction)togglePlaying:(id)sender
{
    if (self.player.rate > 0) {
        [self.player pause];
    } else {
        if (CMTimeCompare(self.player.currentTime, self.player.currentItem.duration) == 0) {
            [self.player seekToTime:kCMTimeZero];
        }
        [self.player play];
    }
}

- (void)setVideoURL:(NSURL *)videoURL
{
    _videoURL = [videoURL copy];
    
    [self _loadVideoIfNeeded];
}

- (IBAction)shareButtonTapped:(id)sender
{
    [self.delegate videoPreviewViewControllerDidSelectShare:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.player pause];
    [self.player cancelPendingPrerolls];
}

@end
