@import Foundation;
@import SceneKit;

@interface AVTAvatarInstance: NSObject
@end

@interface AVTPuppet: NSObject

+ (instancetype)puppetNamed:(NSString *)name options:(NSDictionary *)options;
+ (NSArray <NSString *> *)puppetNames;
+ (UIImage *)thumbnailForPuppetNamed:(NSString *)name options:(NSDictionary *)options;

@property (readonly) SCNNode *avatarNode;
@property (readonly) SCNNode *lightingNode;

@end

@interface AVTAvatar: NSObject
+ (instancetype)avatarWithDataRepresentation:(NSData *)data error:(NSError **)outError;
@end

#define ASPuppet NSClassFromString(@"AVTPuppet")
#define ASAvatar NSClassFromString(@"AVTAvatar")
