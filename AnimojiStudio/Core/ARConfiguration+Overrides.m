//
//  ARConfiguration+Overrides.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 14/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "ARConfiguration+Overrides.h"

@implementation ARConfiguration (Overrides)

- (void)setProvidesAudioData:(BOOL)providesAudioData
{
    // prevent this from working, we never want audio data from ARKit
    return;
}

@end
