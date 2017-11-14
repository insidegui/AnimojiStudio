//
//  ColorSheetPresentationController.m
//  ColorSliders
//
//  Created by Guilherme Rambo on 14/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "ColorSheetPresentationController.h"

@implementation ColorSheetPresentationController
{
    UITapGestureRecognizer *_tapOutside;
    UISwipeGestureRecognizer *_flickOutside;
    UISwipeGestureRecognizer *_flickCard;
}

- (CGRect)frameOfPresentedViewInContainerView
{
    CGFloat padding = 16;
    CGFloat height = 260;
    CGRect baseRect = self.containerView.frame;
    CGFloat bottomInset = self.containerView.safeAreaInsets.bottom;
    
    CGFloat width = baseRect.size.width - padding * 2;
    CGFloat x = baseRect.size.width / 2 - width / 2;
    CGFloat y = baseRect.size.height - height - bottomInset;
    
    return CGRectMake(x, y, width, height);
}

- (void)presentationTransitionWillBegin
{
    [super presentationTransitionWillBegin];
    
    _tapOutside = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOutside:)];
    [self.containerView addGestureRecognizer:_tapOutside];
    
    _flickOutside = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOutside:)];
    _flickOutside.direction = UISwipeGestureRecognizerDirectionDown;
    [self.containerView addGestureRecognizer:_flickOutside];
    
    _flickCard = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOutside:)];
    _flickCard.direction = UISwipeGestureRecognizerDirectionDown;
    [self.presentedView addGestureRecognizer:_flickCard];
}

- (void)dismissalTransitionWillBegin
{
    [self.containerView removeGestureRecognizer:_tapOutside];
    [self.containerView removeGestureRecognizer:_flickOutside];
    [self.presentedView removeGestureRecognizer:_flickCard];
    
    [super dismissalTransitionWillBegin];
}

- (IBAction)tappedOutside:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
