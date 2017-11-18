//
//  RecordingStatusViewController.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 12/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "RecordingStatusViewController.h"

#import "ASAppearance.h"

#import "PuppetSelectionViewController.h"

@interface RecordingStatusViewController () <PuppetSelectionDelegate>

@property (nonatomic, strong) UIVisualEffectView *backgroundView;

@property (nonatomic, strong) UIView *recordingIndicator;
@property (nonatomic, strong) UILabel *elapsedTimeLabel;

@property (nonatomic, strong) NSTimer *recordingTimer;
@property (nonatomic, assign) NSTimeInterval elapsedTime;

@property (nonatomic, strong) PuppetSelectionViewController *puppetsController;

@end

@implementation RecordingStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self build];
}

- (void)build
{
    self.backgroundView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.backgroundView.frame = self.view.bounds;
    
    [self.view addSubview:self.backgroundView];
    
    [self _installPuppetSelection];
    [self _installRecordingIndicator];
}

- (void)_installPuppetSelection
{
    CGFloat height = 44;
    
    self.puppetsController = [PuppetSelectionViewController new];
    self.puppetsController.delegate = self;
    self.puppetsController.referenceHeight = height;
    self.puppetsController.usesHorizontalLayout = YES;
    self.puppetsController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.puppetsController willMoveToParentViewController:self];
    [self addChildViewController:self.puppetsController];
    [self.backgroundView.contentView addSubview:self.puppetsController.view];
    [self.puppetsController didMoveToParentViewController:self];
    
    [self.puppetsController.view.heightAnchor constraintEqualToConstant:height].active = YES;
    [self.puppetsController.view.leadingAnchor constraintEqualToAnchor:self.backgroundView.contentView.leadingAnchor constant:16].active = YES;
    [self.puppetsController.view.trailingAnchor constraintEqualToAnchor:self.backgroundView.contentView.trailingAnchor constant:-16].active = YES;
    [self.puppetsController.view.topAnchor constraintEqualToAnchor:self.backgroundView.contentView.topAnchor constant:8].active = YES;
}

- (void)_installRecordingIndicator
{
    self.recordingIndicator = [UIView new];
    self.recordingIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.recordingIndicator.backgroundColor = [UIColor primaryColor];
    self.recordingIndicator.layer.cornerRadius = 37.5;
    
    [self.backgroundView.contentView addSubview:self.recordingIndicator];
    
    [self.recordingIndicator.widthAnchor constraintEqualToConstant:75].active = YES;
    [self.recordingIndicator.heightAnchor constraintEqualToConstant:75].active = YES;
    [self.recordingIndicator.topAnchor constraintEqualToAnchor:self.puppetsController.view.bottomAnchor constant:8].active = YES;
    [self.recordingIndicator.centerXAnchor constraintEqualToAnchor:self.puppetsController.view.centerXAnchor].active = YES;
    
    self.elapsedTimeLabel = [UILabel new];
    self.elapsedTimeLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    self.elapsedTimeLabel.textColor = [UIColor whiteColor];
    self.elapsedTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.elapsedTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.elapsedTimeLabel.text = @"00:00";
    
    [self.recordingIndicator addSubview:self.elapsedTimeLabel];
    
    [self.elapsedTimeLabel.centerXAnchor constraintEqualToAnchor:self.recordingIndicator.centerXAnchor].active = YES;
    [self.elapsedTimeLabel.centerYAnchor constraintEqualToAnchor:self.recordingIndicator.centerYAnchor].active = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recordingIndicatorTapped:)];
    [self.recordingIndicator addGestureRecognizer:tap];
}

- (IBAction)recordingIndicatorTapped:(id)sender
{
    [self.delegate recordingStatusControllerDidSelectStop:self];
}

- (void)startCountingTime
{
    [self stopCountingTime];
    
    self.elapsedTime = 0;
    
    self.recordingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(recordingTimerFired:) userInfo:nil repeats:YES];
}

- (void)stopCountingTime
{
    [self.recordingTimer invalidate];
    self.recordingTimer = nil;
}

- (IBAction)recordingTimerFired:(id)sender
{
    self.elapsedTime += 1;
}

- (void)setElapsedTime:(NSTimeInterval)elapsedTime
{
    _elapsedTime = elapsedTime;
    
    [self _updateTimeLabelWithCurrentTime];
}

- (void)_updateTimeLabelWithCurrentTime
{
    NSDate *refDate = [NSDate dateWithTimeInterval:self.elapsedTime sinceDate:[NSDate date]];
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitSecond|NSCalendarUnitMinute fromDate:[NSDate date] toDate:refDate options:0];
    
    NSInteger minute = [comps valueForComponent:NSCalendarUnitMinute];
    NSInteger second = [comps valueForComponent:NSCalendarUnitSecond];
    
    self.elapsedTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)minute, (long)second];
}

#pragma mark Changing Puppets

- (void)puppetSelectionViewController:(PuppetSelectionViewController *)controller didSelectPuppetWithName:(NSString *)puppetName
{
    [self.delegate recordingStatusController:self didChangePuppetToPuppetWithName:puppetName];
}

@end
