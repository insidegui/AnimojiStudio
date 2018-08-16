//
//  AVTAvatarLibraryViewController.h
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 10/06/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

@import UIKit;

@class AVTAvatarStore;

@interface AVTAvatarLibraryViewController: UIViewController

- (instancetype)initWithAvatarStore:(AVTAvatarStore *)store;

@end

#define ASAvatarLibraryViewController NSClassFromString(@"AVTAvatarLibraryViewController")
