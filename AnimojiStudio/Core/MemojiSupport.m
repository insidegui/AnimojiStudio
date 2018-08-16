//
//  MemojiSupport.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 16/08/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

#import "MemojiSupport.h"

#import <objc/runtime.h>

@implementation MemojiSupport

+ (BOOL)swizzleMemojiRelatedMethods
{
    Class AVTArchiverBasedStoreBackend = NSClassFromString(@"AVTArchiverBasedStoreBackend");
    if (!AVTArchiverBasedStoreBackend) return NO;
    Class AVTUIEnvironment = NSClassFromString(@"AVTUIEnvironment");
    if (!AVTUIEnvironment) return NO;

    Method m1 = class_getClassMethod(AVTArchiverBasedStoreBackend, NSSelectorFromString(@"storeLocationForDomainIdentifier:environment:"));
    if (!m1) return NO;

    Method m2 = class_getClassMethod([self class], @selector(storeLocationForDomainIdentifier:environment:));

    method_exchangeImplementations(m1, m2);

    Method m3 = class_getClassMethod(AVTUIEnvironment, NSSelectorFromString(@"storeLocation"));
    if (!m3) return NO;

    Method m4 = class_getClassMethod([self class], @selector(storeLocation));

    method_exchangeImplementations(m3, m4);

    Method m5 = class_getClassMethod(AVTUIEnvironment, NSSelectorFromString(@"imageStoreLocation"));
    if (!m5) return NO;

    Method m6 = class_getClassMethod([self class], @selector(imageStoreLocation));

    method_exchangeImplementations(m5, m6);

    return YES;
}

+ (NSURL *)storeLocationForDomainIdentifier:(id)identifier environment:(id)environment
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"MemojiStore"];
    return [NSURL fileURLWithPath:path];
}

+ (NSURL *)storeLocation
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"MemojiStore"];
    return [NSURL fileURLWithPath:path];
}

+ (NSURL *)imageStoreLocation
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"MemojiStore"];
    return [NSURL fileURLWithPath:path];
}

@end
