//
//  RecordingStatusViewController.h
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 12/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecordingStatusViewController;

@protocol RecordingStatusViewControllerDelegate <NSObject>

- (void)recordingStatusControllerDidSelectStop:(RecordingStatusViewController *)controller;

@end

@interface RecordingStatusViewController : UIViewController

@property (nonatomic, weak) id<RecordingStatusViewControllerDelegate> delegate;

- (void)startCountingTime;
- (void)stopCountingTime;

@end
