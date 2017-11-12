//
//  VideoPreviewViewController.h
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 12/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoPreviewViewController;

@protocol VideoPreviewDelegate <NSObject>

- (void)videoPreviewViewControllerDidSelectShare:(VideoPreviewViewController *)controller;

@end

@interface VideoPreviewViewController : UIViewController

@property (nonatomic, weak) id<VideoPreviewDelegate> delegate;

@property (nonatomic, copy) NSURL *videoURL;

@end
