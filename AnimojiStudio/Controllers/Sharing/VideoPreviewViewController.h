//
//  VideoPreviewViewController.h
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 12/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BigButton;
@class VideoPreviewViewController;

@protocol VideoPreviewDelegate <NSObject>

- (void)videoPreviewViewControllerDidSelectShare:(VideoPreviewViewController *)controller;

@end

@interface VideoPreviewViewController : UIViewController
@property (nonatomic, strong) BigButton *shareButton;
@property (nonatomic, weak) id<VideoPreviewDelegate> delegate;

@property (nonatomic, copy) NSURL *videoURL;

@end
