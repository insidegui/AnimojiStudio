//
//  SongTableViewCell.h
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 15/11/17.
//  Copyright © 2017 Guilherme Rambo. All rights reserved.
//

@import UIKit;

@interface SongTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void (^didTapPreviewButton)(void);

- (void)showStoppedState;
- (void)showPlayingState;

@end
