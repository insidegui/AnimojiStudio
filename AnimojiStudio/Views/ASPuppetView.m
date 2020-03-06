//
//  ASPuppetView.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 11/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

@import ARKit;

#import "ASPuppetView.h"

#import "AVTAnimoji.h"

@import SceneKit;

#import <objc/runtime.h>

@implementation ASPuppetView

- (void)resetTracking
{
    ARConfiguration *config = [self.arSession.configuration copy];
    config.providesAudioData = NO;
    [self.arSession runWithConfiguration:config options:ARSessionRunOptionResetTracking|ARSessionRunOptionRemoveExistingAnchors];
}

@end
