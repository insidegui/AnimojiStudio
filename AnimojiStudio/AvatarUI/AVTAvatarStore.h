//
//  AVTAvatarStore.h
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 10/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

@import Foundation;

@interface AVTAvatarStore: NSObject

- (instancetype)initWithDomainIdentifier:(NSString *)identifier;

@end

#define ASAvatarStore NSClassFromString(@"AVTAvatarStore")
