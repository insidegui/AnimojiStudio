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
- (void)recordingStatusController:(RecordingStatusViewController *)controller didChangePuppetToPuppetWithName:(NSString *)newPuppetName;

@end

@interface RecordingStatusViewController : UIViewController

@property (nonatomic, weak) id<RecordingStatusViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *preSelectedPuppetName;

- (void)startCountingTime;
- (void)stopCountingTime;

@end
