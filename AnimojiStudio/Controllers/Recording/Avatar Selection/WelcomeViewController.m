//
//  WelcomeViewController.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 17/08/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

#import "WelcomeViewController.h"

#import "BigButton.h"

@interface WelcomeViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

@property (nonatomic, strong) BigButton *memojiButton;
@property (nonatomic, strong) BigButton *animojiButton;

@property (nonatomic, strong) UIStackView *buttonStack;

@property (nonatomic, assign) BOOL hasPerformedWelcomeAnimation;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _installTitle];
    [self _installSubtitle];
    [self _installButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self _performWelcomeAnimationIfNeeded];
}

- (void)_installTitle
{
    self.titleLabel = [UILabel new];
    self.titleLabel.text = @"Welcome to\nAnimojiStudio";
    self.titleLabel.font = [UIFont systemFontOfSize:36 weight:UIFontWeightBold];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.titleLabel];
    [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:22].active = YES;
    [self.titleLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:22].active = YES;
}

- (void)_installSubtitle
{
    self.subtitleLabel = [UILabel new];
    self.subtitleLabel.text = @"What type of recording would you like to make?";
    self.subtitleLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightSemibold];
    self.subtitleLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    self.subtitleLabel.numberOfLines = 0;
    self.subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.subtitleLabel];
    [self.subtitleLabel.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor].active = YES;
    [self.subtitleLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:16].active = YES;
    [self.subtitleLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-22].active = YES;
}

- (void)_installButtons
{
    self.memojiButton = [BigButton new];
    [self.memojiButton setTitle:@"Memoji" forState:UIControlStateNormal];
    [self.memojiButton addTarget:self action:@selector(didTapMemojiButton:) forControlEvents:UIControlEventTouchUpInside];

    self.animojiButton = [BigButton new];
    [self.animojiButton setTitle:@"Classic Animoji" forState:UIControlStateNormal];
    [self.animojiButton addTarget:self action:@selector(didTapAnimojiButton:) forControlEvents:UIControlEventTouchUpInside];

    self.buttonStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.memojiButton, self.animojiButton]];
    self.buttonStack.axis = UILayoutConstraintAxisVertical;
    self.buttonStack.spacing = 16;
    self.buttonStack.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.buttonStack];

    [self.buttonStack.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:22].active = YES;
    [self.buttonStack.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-22].active = YES;
    [self.buttonStack.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:50].active = YES;
}

- (IBAction)didTapMemojiButton:(id)sender
{
    [self.delegate welcomeViewControllerDidSelectMemojiMode:self];
}

- (IBAction)didTapAnimojiButton:(id)sender
{
    [self.delegate welcomeViewControllerDidSelectClassicAnimojiMode:self];
}

- (NSArray <UIView *> *)_welcomeAnimationParticipants
{
    return @[self.titleLabel, self.subtitleLabel, self.memojiButton, self.animojiButton];
}

- (NSTimeInterval)_welcomeAnimationPartDuration
{
    return 1.4;
}

- (void)_performWelcomeAnimationIfNeeded
{
    if (self.hasPerformedWelcomeAnimation) return;
    self.hasPerformedWelcomeAnimation = YES;

    __block NSTimeInterval delayMultiplier = 0.3;
    [[self _welcomeAnimationParticipants] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        [self _performWelcomeAnimationForView:view withDelay:delayMultiplier*(CGFloat)idx];
    }];
}

- (void)_performWelcomeAnimationForView:(UIView *)view withDelay:(NSTimeInterval)delay
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction setAnimationDuration:0];
    view.layer.opacity = 0;
    view.layer.transform = CATransform3DMakeTranslation(0, 60, 0);
    [CATransaction commit];

    [UIView animateWithDuration:[self _welcomeAnimationPartDuration] delay:delay usingSpringWithDamping:0.9 initialSpringVelocity:0.4 options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionAllowUserInteraction animations:^{
        view.layer.opacity = 1;
        view.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {

    }];
}

@end
