//
//  PuppetCollectionViewCell.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 11/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "PuppetCollectionViewCell.h"

#import "AVTAnimoji.h"

@interface PuppetCollectionViewCell ()

@property (nonatomic, strong) UIImageView *puppetImageView;

@end

@implementation PuppetCollectionViewCell

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self build];
}

- (void)build
{
    if (self.puppetImageView) return;
    
    self.puppetImageView = [UIImageView new];
    self.puppetImageView.contentMode = UIViewContentModeScaleAspectFit;

    self.puppetImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.puppetImageView.frame = self.contentView.bounds;
    
    [self.contentView addSubview:self.puppetImageView];
    
    [self updateImage];
}

- (void)setPuppetName:(NSString *)puppetName
{
    _puppetName = [puppetName copy];
    
    [self updateImage];
}

- (void)updateImage
{
    if (!_puppetName.length) return;
    
    self.puppetImageView.image = [ASAnimoji thumbnailForAnimojiNamed:_puppetName options:nil];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        self.puppetImageView.layer.transform = CATransform3DMakeScale(1.4, 1.4, 1);
    } else {
        self.puppetImageView.layer.transform = CATransform3DIdentity;
    }
}

@end
