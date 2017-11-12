//
//  UIViewController+Children.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 11/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "UIViewController+Children.h"

@implementation UIViewController (Children)

- (void)installChildViewController:(UIViewController *)child
{
    [child willMoveToParentViewController:self];
    
    child.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    child.view.frame = self.view.bounds;
    
    [self addChildViewController:child];
    [self.view addSubview:child.view];
    
    [child didMoveToParentViewController:self];
}

- (void)presentErrorControllerWithMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
