//
//  AvatarSelectionFlowController.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 17/08/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

#import "AvatarSelectionFlowController.h"

#import "PuppetSelectionViewController.h"

#import "AVTAvatarStore.h"
#import "AVTAvatarLibraryViewController.h"

#import "MemojiSupport.h"
#import "AVTPuppet.h"

#import "UIViewController+Children.h"

#import "WelcomeViewController.h"

@interface AvatarSelectionFlowController ()

@property (nonatomic, strong) WelcomeViewController *welcomeController;

@property (nonatomic, strong) PuppetSelectionViewController *puppetSelectionController;
@property (nonatomic, strong) AVTAvatarLibraryViewController *avatarLibraryController;

@end

@implementation AvatarSelectionFlowController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.welcomeController = [WelcomeViewController new];
    [self installChildViewController:self.welcomeController];
}

@end
