//
//  SharingFlowController.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 12/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "SharingFlowController.h"

#import "UIViewController+Children.h"
#import "VideoPreviewViewController.h"

@interface SharingFlowController () <VideoPreviewDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, weak) VideoPreviewViewController *previewController;

@end

@implementation SharingFlowController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    VideoPreviewViewController *preview = [VideoPreviewViewController new];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:preview];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    preview.navigationItem.rightBarButtonItem = doneItem;
    preview.delegate = self;
    preview.videoURL = self.videoURL;
    
    self.previewController = preview;
    
    [self installChildViewController:self.navigationController];
}

- (IBAction)done:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)setVideoURL:(NSURL *)videoURL
{
    _videoURL = [videoURL copy];
    
    self.previewController.videoURL = _videoURL;
}

- (void)videoPreviewViewControllerDidSelectShare:(VideoPreviewViewController *)controller
{
    if (!self.videoURL) return;
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[self.videoURL] applicationActivities:nil];
    
    __weak typeof(self) weakSelf = self;
    [activityController setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (!completed || !activityType) return;
        
        [weakSelf done:nil];
    }];
    activityController.popoverPresentationController.sourceView = self.previewController.shareButton;
    [self presentViewController:activityController animated:YES completion:nil];
}

@end
