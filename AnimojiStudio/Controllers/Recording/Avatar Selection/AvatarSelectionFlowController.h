//
//  AvatarSelectionFlowController.h
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 17/08/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

@import UIKit;

@class AvatarSelectionFlowController, AVTAvatarInstance;

@protocol AvatarSelectionDelegate <NSObject>

- (void)avatarSelectionFlowController:(AvatarSelectionFlowController *)controller didSelectAvatarInstance:(AVTAvatarInstance *)avatar;

@end

@interface AvatarSelectionFlowController : UIViewController

@property (nonatomic, weak) id<AvatarSelectionDelegate> delegate;

@end
