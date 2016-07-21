#import "RCTBridgeModule.h"

@interface RNBugsnag : NSObject <RCTBridgeModule>
@property BOOL suppressDev;
+ (RNBugsnag*)init;
- (void)notifyWithTitle: (NSString *)exceptionTitle
              andReason:(NSString *)exceptionReason
           withSeverity:(NSString *)severity
           andOtherData:(NSDictionary *) otherData;
@end
