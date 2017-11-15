//
//  SongTableViewCell.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 15/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "SongTableViewCell.h"

@interface SongTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIStackView *titleStack;

@property (nonatomic, strong) UIButton *previewButton;

@end

@implementation SongTableViewCell

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self build];
}

- (void)build
{
    if (self.titleLabel) return;
    
    self.titleLabel = [UILabel new];
    self.titleLabel.text = self.title;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.subtitleLabel = [UILabel new];
    self.subtitleLabel.text = self.subtitle;
    self.subtitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.subtitleLabel.textColor = [UIColor grayColor];
    self.subtitleLabel.font = [UIFont systemFontOfSize:13];
    
    self.titleStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.titleLabel, self.subtitleLabel]];
    self.titleStack.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleStack.axis = UILayoutConstraintAxisVertical;
    self.titleStack.spacing = 2;
    [self.titleStack setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
    self.previewButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.previewButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self showStoppedState];
    
    [self.contentView addSubview:self.titleStack];
    [self.contentView addSubview:self.previewButton];
    
    [self.titleStack.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    [self.titleStack.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16].active = YES;
    
    [self.previewButton.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    [self.previewButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16].active = YES;
    
    [self.previewButton.widthAnchor constraintEqualToConstant:30].active = YES;
    [self.previewButton.heightAnchor constraintEqualToConstant:30].active = YES;
    
    [self.titleStack.trailingAnchor constraintLessThanOrEqualToAnchor:self.previewButton.leadingAnchor constant:-16].active = YES;
    
    [self.titleStack.topAnchor constraintGreaterThanOrEqualToAnchor:self.contentView.topAnchor constant:4].active = YES;
    [self.titleStack.bottomAnchor constraintLessThanOrEqualToAnchor:self.contentView.bottomAnchor constant:-4].active = YES;
    
    [self.previewButton addTarget:self action:@selector(previewButtonTapped:) forControlEvents:UIControlEventTouchDown];
}

- (void)showStoppedState
{
    [self.previewButton setImage:[UIImage imageNamed:@"previewPlay"] forState:UIControlStateNormal];
}

- (void)showPlayingState
{
    [self.previewButton setImage:[UIImage imageNamed:@"previewStop"] forState:UIControlStateNormal];
}

- (IBAction)previewButtonTapped:(id)sender
{
    if (!self.didTapPreviewButton) return;
    
    self.didTapPreviewButton();
    [self showPlayingState];
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    self.titleLabel.text = _title;
}

- (void)setSubtitle:(NSString *)subtitle
{
    _subtitle = [subtitle copy];
    
    self.subtitleLabel.text = _subtitle;
}

@end
