//
//  WelcomeViewController.h
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 17/08/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

@import UIKit;

@class WelcomeViewController;

@protocol WelcomeViewControllerDelegate <NSObject>

- (void)welcomeViewControllerDidSelectMemojiMode:(WelcomeViewController *)controller;
- (void)welcomeViewControllerDidSelectClassicAnimojiMode:(WelcomeViewController *)controller;

@end

@interface WelcomeViewController : UIViewController

@property (nonatomic, weak) id<WelcomeViewControllerDelegate> delegate;

@end
