//
//  MemojiSupport.h
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 16/08/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSNotificationName DidSelectMemoji;

NS_ASSUME_NONNULL_BEGIN

@interface MemojiSupport : NSObject

+ (void)prepareMemojiRuntime;
+ (BOOL)deviceSupportsMemoji;

@end

NS_ASSUME_NONNULL_END
