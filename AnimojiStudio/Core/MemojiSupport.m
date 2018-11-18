//
//  MemojiSupport.m
//  AnimojiStudio
//
//  Created by Guilherme Rambo on 16/08/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//

#import "MemojiSupport.h"

#import <objc/runtime.h>

NSURL *animojiStudioStoreLocation(void);

@interface AVTCoreDataCloudKitMirroringConfiguration: NSObject
+ (BOOL)cloudKitMirroringEnabled;
@end

@interface AVTCoreDataPersistentStoreConfiguration: NSObject

+ (instancetype)localConfigurationWithStoreLocation:(id)location environment:(id)environment;

@end

@interface AVTUIEnvironment: NSObject

+ (instancetype)defaultEnvironment;

@end

@import os.log;

const NSNotificationName DidSelectMemoji = @"DidSelectMemojiNotificationName";

@interface MemojiSupport ()

@property (readonly) NSArray *mutableLibraryItems;
@property (assign) BOOL memojiRuntimeInitializedSuccessfully;

@end

@implementation MemojiSupport
{
    os_log_t _log;
}

+ (instancetype)sharedInstance
{
    static MemojiSupport *_shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [MemojiSupport new];
    });
    return _shared;
}

- (instancetype)init
{
    self = [super init];

    _log = os_log_create("AnimojiStudio", "MemojiSupport");

    return self;
}

+ (void)prepareMemojiRuntime
{
    [MemojiSupport sharedInstance].memojiRuntimeInitializedSuccessfully = [[MemojiSupport sharedInstance] _initializeMemojiRuntime];
}

- (BOOL)_initializeMemojiRuntime
{
    if (![[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/AvatarUI.framework"] load]) {
        os_log_error(_log, "Failed to load AvatarUI framework. Memoji support disabled.");
        return NO;
    }

    Class AVTArchiverBasedStoreBackend = NSClassFromString(@"AVTArchiverBasedStoreBackend");
    if (!AVTArchiverBasedStoreBackend) {
        os_log_error(_log, "Class AVTArchiverBasedStoreBackend not found. Memoji support disabled.");
        return NO;
    }

    Class AVTUIEnvironment = NSClassFromString(@"AVTUIEnvironment");
    if (!AVTUIEnvironment) {
        os_log_error(_log, "Class AVTUIEnvironment not found. Memoji support disabled.");
        return NO;
    }

    Method m1 = class_getClassMethod(AVTArchiverBasedStoreBackend, NSSelectorFromString(@"storeLocationForDomainIdentifier:environment:"));
    if (!m1) {
        os_log_error(_log, "Method storeLocationForDomainIdentifier:environment: not found on class AVTArchiverBasedStoreBackend. Memoji support disabled.");
        return NO;
    }

    Method m2 = class_getClassMethod([self class], @selector(storeLocationForDomainIdentifier:environment:));

    method_exchangeImplementations(m1, m2);

    Method m3 = class_getInstanceMethod(AVTUIEnvironment, NSSelectorFromString(@"storeLocation"));
    if (!m3) {
        os_log_error(_log, "Method storeLocation not found on class AVTUIEnvironment. Memoji support disabled.");
        return NO;
    }

    Method m4 = class_getClassMethod([self class], @selector(storeLocation));

    method_exchangeImplementations(m3, m4);

    Method m5 = class_getInstanceMethod(AVTUIEnvironment, NSSelectorFromString(@"imageStoreLocation"));
    if (!m5) {
        os_log_error(_log, "Method imageStoreLocation not found on class AVTUIEnvironment. Memoji support disabled.");
        return NO;
    }

    Method m6 = class_getClassMethod([self class], @selector(imageStoreLocation));

    method_exchangeImplementations(m5, m6);

    Class AVTAvatarLibraryModel = NSClassFromString(@"AVTAvatarLibraryModel");
    if (!AVTAvatarLibraryModel) {
        os_log_error(_log, "Class AVTAvatarLibraryModel not found. Memoji support disabled.");
        return NO;
    }

    Method m7 = class_getInstanceMethod(AVTAvatarLibraryModel, NSSelectorFromString(@"performActionOnItemAtIndex:"));
    if (!m7) {
        os_log_error(_log, "Method performActionOnItemAtIndex: not found on class AVTAvatarLibraryModel. Memoji support disabled.");
        return NO;
    }

    class_addMethod(AVTAvatarLibraryModel, @selector(original_performActionOnItemAtIndex:), method_getImplementation(m7), method_getTypeEncoding(m7));

    Method m8 = class_getInstanceMethod([self class], @selector(performActionOnItemAtIndex:));
    method_exchangeImplementations(m7, m8);

    if (!NSClassFromString(@"AVTCoreDataPersistentStoreConfiguration")) {
        os_log_error(_log, "Class AVTCoreDataPersistentStoreConfiguration not found. Memoji support disabled.");
        return NO;
    }

    Method m9 = class_getClassMethod(NSClassFromString(@"AVTCoreDataPersistentStoreConfiguration"), NSSelectorFromString(@"remoteConfigurationWithDaemonClient:environment:"));
    Method m10 = class_getClassMethod([self class], @selector(localConfigurationWithStoreLocation:environment:));
    method_exchangeImplementations(m9, m10);

    if (!NSClassFromString(@"AVTCoreDataCloudKitMirroringConfiguration")) {
        os_log_error(_log, "Class AVTCoreDataCloudKitMirroringConfiguration not found. Memoji support disabled.");
        return NO;
    }

    Method m11 = class_getClassMethod(NSClassFromString(@"AVTCoreDataCloudKitMirroringConfiguration"), @selector(cloudKitMirroringEnabled));
    Method m12 = class_getClassMethod([self class], @selector(cloudKitMirroringEnabled));
    method_exchangeImplementations(m11, m12);

    os_log_info(_log, "Memoji runtime initialized successfully");

    return YES;
}

+ (BOOL)cloudKitMirroringEnabled
{
    return NO;
}

+ (id)localConfigurationWithStoreLocation:(id)location environment:(id)environment
{
    return [NSClassFromString(@"AVTCoreDataPersistentStoreConfiguration") localConfigurationWithStoreLocation:animojiStudioStoreLocation() environment:[NSClassFromString(@"AVTUIEnvironment") defaultEnvironment]];
}

+ (NSURL *)storeLocationForDomainIdentifier:(id)identifier environment:(id)environment
{
    return animojiStudioStoreLocation();
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

- (void)original_performActionOnItemAtIndex:(NSUInteger)index
{
    // implementation replaced at runtime
    return;
}

- (void)performActionOnItemAtIndex:(NSUInteger)index
{
    if (index >= self.mutableLibraryItems.count) return;

    id item = self.mutableLibraryItems[index];

    if ([item isKindOfClass:NSClassFromString(@"AVTAvatarLibraryCreateNewItem")]) {
        [self original_performActionOnItemAtIndex:index];
        return;
    }

    NSData *memojiData = [[item valueForKey:@"avatarRecord"] valueForKey:@"avatarData"];
    if (!memojiData) return;

    [[NSNotificationCenter defaultCenter] postNotificationName:DidSelectMemoji object:memojiData];
}

+ (BOOL)deviceSupportsMemoji
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ASSimulateMemojiUnsupported"]) return NO;

    return [MemojiSupport sharedInstance].memojiRuntimeInitializedSuccessfully;
}

@end

NSURL *animojiStudioStoreLocation(void) {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"MemojiStore"];
    return [NSURL fileURLWithPath:path];
}

int override_AVTUIIsAvatarSyncEnabled(void)
{
    return 0;
}
