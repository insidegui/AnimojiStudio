//
//  BigButton.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 17/08/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

#import "BigButton.h"

#import "ASAppearance.h"

@implementation BigButton
{
    CALayer *_highlightLayer;
}

- (instancetype)init
{
    self = [super init];

    [self _configureBigButton];

    return self;
}

- (void)_configureBigButton
{
    self.backgroundColor = [UIColor primaryColor];
    self.tintColor = [UIColor whiteColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    self.layer.cornerRadius = 12;

    self.translatesAutoresizingMaskIntoConstraints = NO;

    self.layer.masksToBounds = YES;

    [self _installHighlightLayer];
}

- (void)_installHighlightLayer
{
    _highlightLayer = [CALayer new];
    _highlightLayer.backgroundColor = [UIColor whiteColor].CGColor;
    _highlightLayer.opacity = 0;
    _highlightLayer.frame = self.bounds;
    [self.layer addSublayer:_highlightLayer];

    [self addTarget:self action:@selector(_moveIntoPressedState) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(_moveIntoPressedState) forControlEvents:UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(_moveIntoRelaxedState) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(_moveIntoRelaxedState) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(_moveIntoRelaxedState) forControlEvents:UIControlEventTouchDragExit];
}

- (UIViewAnimationOptions)_animationOptions
{
    return UIViewAnimationOptionAllowAnimatedContent |
           UIViewAnimationOptionAllowUserInteraction |
           UIViewAnimationOptionBeginFromCurrentState;
}

- (void)_moveIntoPressedState
{
    [UIView animateWithDuration:0.6
                          delay:0
         usingSpringWithDamping:0.4
          initialSpringVelocity:1.2
                        options:[self _animationOptions]
                     animations:^{
                         self.layer.transform = CATransform3DMakeScale(0.95, 0.95, 1);
                     } completion:nil];

    [UIView animateWithDuration:0.3 animations:^{
        self->_highlightLayer.opacity = 0.2;
    }];
}

- (void)_moveIntoRelaxedState
{
    [UIView animateWithDuration:0.8
                          delay:0
         usingSpringWithDamping:0.4
          initialSpringVelocity:1.2
                        options:[self _animationOptions]
                     animations:^{
                         self.layer.transform = CATransform3DIdentity;
                     } completion:nil];

    [UIView animateWithDuration:0.3 animations:^{
        self->_highlightLayer.opacity = 0;
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction setAnimationDuration:0];
    _highlightLayer.frame = self.bounds;
    [CATransaction commit];
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, 50);
}

@end
