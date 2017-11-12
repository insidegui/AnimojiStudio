//
//  AppDelegate.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 11/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import "AppDelegate.h"

#import "ASAppearance.h"

#import "ErrorViewController.h"
#import "RecordingFlowController.h"

@interface AppDelegate ()

@property (nonatomic, strong) RecordingFlowController *recordingFlow;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ASAppearance install];
    
    self.window = [UIWindow new];
    
    [self.window setOpaque:YES];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    if (![[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/AvatarKit.framework"] load]) {
        [self showErrorMessage:@"This app is only supported on iPhone X"];
        [self.window makeKeyAndVisible];
        return YES;
    }
    
    self.recordingFlow = [RecordingFlowController new];
    
    [self.window setRootViewController:self.recordingFlow];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)showErrorMessage:(NSString *)errorMessage
{
    ErrorViewController *controller = [ErrorViewController new];
    controller.message = errorMessage;
    [self.window setRootViewController:controller];
}

@end
