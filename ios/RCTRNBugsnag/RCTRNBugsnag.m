#import "RCTRNBugsnag.h"

@implementation RNBugsnag

RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(init,
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    resolve(@"Hello World!");
}

@end
