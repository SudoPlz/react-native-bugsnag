#import "RCTRNBugsnag.h"

@implementation RNBugsnag

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(init,
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    
    //Run code that initializes BugSnag here
    resolve(@"Hello World!");
}


RCT_EXPORT_METHOD(setIdentifier:(NSString *)userId
                  withEmail:(NSString *)email
                  andFullName:(NSString *)fullName
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    
    //This gets called whenever setIdentifier is invoked from javascript
    resolve(@"User identified");
}



RCT_EXPORT_METHOD(reportException:(NSString *)errorMessage
                 withStack:(NSArray *)stacktrace
                 andExceptionId:(NSInteger *)exceptionId
                 isFatal:(BOOL) fatal
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    
    //This gets called whenever a js error gets thrown
    resolve(@"Error");
}



@end
