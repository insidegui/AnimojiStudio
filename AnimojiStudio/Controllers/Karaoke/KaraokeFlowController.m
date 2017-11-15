//
//  KaraokeFlowController.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 15/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "KaraokeFlowController.h"

#import "UIViewController+Children.h"

#import "SpotifyCoordinator.h"
#import "SpotifySearchViewController.h"

@interface KaraokeFlowController ()

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, weak) SpotifySearchViewController *searchController;

@end

@implementation KaraokeFlowController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SpotifySearchViewController *search = [SpotifySearchViewController new];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:search];
    
    self.searchController = search;
    
    [self installChildViewController:self.navigationController];
}

@end
