//
//  MemojiSelectionViewController.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 17/08/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

#import "MemojiSelectionViewController.h"

#import "UIViewController+Children.h"

@interface MemojiSelectionViewController ()

@end

@implementation MemojiSelectionViewController

+ (instancetype)memojiSelectionViewControllerWithEmbeddedController:(UIViewController *)controller
{
    MemojiSelectionViewController *selectionController = [MemojiSelectionViewController new];

    [selectionController installChildViewController:controller];

    return selectionController;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    
    self.title = @"Memoji";
}

@end
