//
//  ASColorWell.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 14/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "ASColorWell.h"

#import "ASAppearance.h"

@interface ASColorWell ()

@property (nonatomic, strong) CAShapeLayer *colorLayer;

@end

@implementation ASColorWell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self build];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    [self build];
    
    return self;
}

- (void)build
{
    // default color is white
    _color = [UIColor whiteColor];
    
    self.colorLayer = [CAShapeLayer new];
    self.colorLayer.frame = self.bounds;
    self.colorLayer.fillColor = self.color.CGColor;
    self.colorLayer.lineWidth = 2.0;
    self.colorLayer.strokeColor = [UIColor primaryColor].CGColor;
    
    [self _updateColorLayer];
    
    [self.layer addSublayer:self.colorLayer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self _updateColorLayer];
}

- (void)setColor:(UIColor *)color
{
    _color = [color copy];
    
    [self _updateColorLayer];
}

- (void)_updateColorLayer
{
    self.colorLayer.path = CGPathCreateWithEllipseInRect(self.bounds, nil);
    self.colorLayer.frame = self.bounds;
    self.colorLayer.fillColor = self.color.CGColor;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(28, 28);
}

@end
