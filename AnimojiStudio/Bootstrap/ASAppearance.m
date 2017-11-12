//
//  ASAppearance.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 11/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "ASAppearance.h"

@implementation UIColor (AnimojiStudio)

+ (UIColor *)primaryColor
{
    return [UIColor colorWithRed:0.30 green:0.15 blue:0.96 alpha:1.00];
}

@end

@implementation ASAppearance

+ (void)install
{
    [UIWindow appearance].tintColor = [UIColor primaryColor];
    [UINavigationBar appearance].tintColor = [UIColor primaryColor];
    [UIButton appearance].tintColor = [UIColor primaryColor];
    [UIBarButtonItem appearance].tintColor = [UIColor primaryColor];
    [UISwitch appearance].tintColor = [UIColor primaryColor];
    [UISwitch appearance].onTintColor = [UIColor primaryColor];
    
    [UINavigationBar appearance].prefersLargeTitles = YES;
    
    NSDictionary *attrs = @{NSForegroundColorAttributeName: [UIColor primaryColor]};
    [UINavigationBar appearance].largeTitleTextAttributes = attrs;
    [UINavigationBar appearance].titleTextAttributes = attrs;
}

@end
