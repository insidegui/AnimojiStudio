//
//  PuppetSelectionViewController.h
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 11/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PuppetSelectionViewController;

@protocol PuppetSelectionDelegate <NSObject>

- (void)puppetSelectionViewController:(PuppetSelectionViewController *)controller didSelectPuppetWithName:(NSString *)puppetName;

@end

@interface PuppetSelectionViewController : UIViewController

@property (nonatomic, weak) id<PuppetSelectionDelegate> delegate;

@end
