@import Foundation;
@import SceneKit;

@class AVTAvatarInstance;

@interface AVTPuppet: NSObject

+ (instancetype)puppetNamed:(NSString *)name options:(NSDictionary *)options;
+ (NSArray <NSString *> *)puppetNames;
+ (UIImage *)thumbnailForPuppetNamed:(NSString *)name options:(NSDictionary *)options;

@property (readonly) SCNNode *avatarNode;
@property (readonly) SCNNode *lightingNode;

@end

#define ASPuppet NSClassFromString(@"AVTPuppet")
