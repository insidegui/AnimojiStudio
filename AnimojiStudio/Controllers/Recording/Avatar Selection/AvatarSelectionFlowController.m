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

@interface AvatarSelectionFlowController () <WelcomeViewControllerDelegate, PuppetSelectionDelegate>

@property (nonatomic, strong) WelcomeViewController *welcomeController;

@end

@implementation AvatarSelectionFlowController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.welcomeController = [WelcomeViewController new];
    self.welcomeController.delegate = self;

    [self installChildViewController:self.welcomeController];
}

- (void)welcomeViewControllerDidSelectMemojiMode:(WelcomeViewController *)controller
{
    [self _pushMemojiSelection];
}

- (void)welcomeViewControllerDidSelectClassicAnimojiMode:(WelcomeViewController *)controller
{
    [self _pushAnimojiPuppetSelection];
}

#pragma mark Memoji

- (void)_pushMemojiSelection
{
    AVTAvatarStore *store = [[ASAvatarStore alloc] initWithDomainIdentifier:[NSBundle mainBundle].bundleIdentifier];
    AVTAvatarLibraryViewController *libraryController = [[ASAvatarLibraryViewController alloc] initWithAvatarStore:store];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handleMemojiSelectedWithNotification:) name:DidSelectMemoji object:nil];

    [self.navigationController pushViewController:libraryController animated:YES];
}

- (void)_handleMemojiSelectedWithNotification:(NSNotification *)note
{
    NSData *memojiData = (NSData *)note.object;
    if (![memojiData isKindOfClass:[NSData class]]) return;

    NSError *error;
    id avatar = [AVTAvatar avatarWithDataRepresentation:memojiData error:&error];

    if (error) {
        // TODO: Present error
        return;
    }

    [self.delegate avatarSelectionFlowController:self didSelectAvatarInstance:(AVTAvatarInstance *)avatar];
}

#pragma mark Animoji

- (void)_pushAnimojiPuppetSelection
{
    PuppetSelectionViewController *controller = [PuppetSelectionViewController new];
    controller.delegate = self;

    [self.navigationController pushViewController:controller animated:YES];
}

- (void)puppetSelectionViewController:(PuppetSelectionViewController *)controller didSelectPuppetWithName:(NSString *)puppetName
{
    AVTAvatarInstance *instance = (AVTAvatarInstance *)[AVTPuppet puppetNamed:puppetName options:nil];
    [self.delegate avatarSelectionFlowController:self didSelectAvatarInstance:instance];
}

@end
