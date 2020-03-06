@import Foundation;
@import SceneKit;

@interface AVTAvatarInstance: NSObject
@end

@interface AVTAnimoji: NSObject

+ (instancetype)animojiNamed:(NSString *)name;
+ (NSArray <NSString *> *)animojiNames;
+ (UIImage *)thumbnailForAnimojiNamed:(NSString *)name options:(NSDictionary *)options;

@property (readonly) SCNNode *avatarNode;
@property (readonly) SCNNode *lightingNode;

@end

@interface AVTAvatar: NSObject
+ (instancetype)avatarWithDataRepresentation:(NSData *)data error:(NSError **)outError;
@end

#define ASAnimoji NSClassFromString(@"AVTAnimoji")
#define ASAvatar NSClassFromString(@"AVTAvatar")
