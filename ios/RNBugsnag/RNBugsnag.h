#import "RCTBridgeModule.h"

@interface RNBugsnag : NSObject <RCTBridgeModule>
@property BOOL suppressDev;
+ (RNBugsnag*)init;
@end
