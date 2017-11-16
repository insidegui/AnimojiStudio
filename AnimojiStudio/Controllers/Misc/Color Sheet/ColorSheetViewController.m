//
//  ColorSheetViewController.m
//  ColorSliders
//
//  Created by Guilherme Rambo on 14/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "ColorSheetViewController.h"

#import "ColorSheetPresentationController.h"

@interface ColorSheetViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIVisualEffectView *backgroundView;

@property (nonatomic, strong) UISlider *redSlider;
@property (nonatomic, strong) UISlider *greenSlider;
@property (nonatomic, strong) UISlider *blueSlider;

@property (nonatomic, strong) UIStackView *sliderStack;

@end

@implementation ColorSheetViewController

- (instancetype)init
{
    self = [super init];
    
    [self _configureCustomPresentation];
    
    return self;
}

- (void)_configureCustomPresentation
{
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self build];
}

- (void)build
{
    CGFloat radius = 36;
    
    [self.view setOpaque:NO];
    [self.view setClipsToBounds:NO];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    self.view.layer.cornerRadius = radius;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOpacity = 0.16;
    self.view.layer.shadowRadius = 2;
    self.view.layer.shadowOffset = CGSizeMake(0, -1);
    
    self.backgroundView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.backgroundView.frame = self.view.bounds;
    self.backgroundView.clipsToBounds = YES;
    self.backgroundView.layer.cornerRadius = radius;
    
    [self.view addSubview:self.backgroundView];
    
    self.redSlider = [self _colorSliderWithColor:[UIColor redColor]];
    self.greenSlider = [self _colorSliderWithColor:[UIColor greenColor]];
    self.blueSlider = [self _colorSliderWithColor:[UIColor blueColor]];
    
    self.sliderStack = [[UIStackView alloc] initWithArrangedSubviews:@[_redSlider, _greenSlider, _blueSlider]];
    self.sliderStack.axis = UILayoutConstraintAxisVertical;
    self.sliderStack.spacing = 8;
    self.sliderStack.distribution = UIStackViewDistributionEqualSpacing;
    self.sliderStack.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.backgroundView.contentView addSubview:self.sliderStack];
    
    [self.sliderStack.topAnchor constraintEqualToAnchor:self.backgroundView.contentView.topAnchor constant:46].active = YES;
    [self.sliderStack.bottomAnchor constraintEqualToAnchor:self.backgroundView.contentView.bottomAnchor constant:-46].active = YES;
    [self.sliderStack.leadingAnchor constraintEqualToAnchor:self.backgroundView.contentView.leadingAnchor constant:24].active = YES;
    [self.sliderStack.trailingAnchor constraintEqualToAnchor:self.backgroundView.contentView.trailingAnchor constant:-24].active = YES;
    
    [self _readColorValues];
}

- (UISlider *)_colorSliderWithColor:(UIColor *)color
{
    UISlider *slider = [UISlider new];
    
    slider.continuous = YES;
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    
    slider.minimumTrackTintColor = color;
    slider.thumbTintColor = color;
    
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    
    return slider;
}

- (IBAction)sliderAction:(UISlider *)sender
{
    [self _writeColorValues];
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    return [[ColorSheetPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

- (void)setColor:(UIColor *)color
{
    UIColor *oldValue = [_color copy];
    
    _color = [color copy];
    
    if (![oldValue isEqual:_color]) [self _readColorValues];
}

- (void)_readColorValues
{
    if (!self.isViewLoaded) return;
    
    CGFloat r = 1;
    CGFloat g = 1;
    CGFloat b = 1;
    
    if (![self.color getRed:&r green:&g blue:&b alpha:nil]) return;
    
    self.redSlider.value = r;
    self.greenSlider.value = g;
    self.blueSlider.value = b;
}

- (void)_writeColorValues
{
    [self willChangeValueForKey:@"color"];
    {
        _color = [UIColor colorWithRed:_redSlider.value
                                 green:_greenSlider.value
                                  blue:_blueSlider.value alpha:1];
    }
    [self didChangeValueForKey:@"color"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.willClose) self.willClose();
}

@end
