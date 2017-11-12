//
//  UIViewController+Children.h
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 11/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Children)

- (void)installChildViewController:(UIViewController *)child;
- (void)presentErrorControllerWithMessage:(NSString *)message;

@end
