#import "RNBugsnag.h"

#import <Bugsnag/Bugsnag.h>




@implementation RNBugsnag

@synthesize suppressDev;

RCT_EXPORT_MODULE();




RCT_EXPORT_METHOD(notify:(NSString *)exceptionTitle
                  reason:(NSString *)exceptionReason
                  withSeverity:(NSString *)severity
                  andOtherData:(NSDictionary *) otherData
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    
    if(self.suppressDev==YES){
        reject(0, @"RNBugsnag won't report errors on dev mode, use setSuppressDebug to set suppress to false in order to use it on dev.", @{});
        return;
    }
    [Bugsnag notify:[NSException exceptionWithName:exceptionTitle reason:exceptionReason userInfo:@{}] withData:otherData atSeverity:severity];
    resolve(@"Done");
}



RCT_EXPORT_METHOD(setSuppressDebug:(BOOL) suppress
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    self.suppressDev = suppress;
    resolve(@"Done");
}



RCT_EXPORT_METHOD(setIdentifier:(NSString *)userId
                  withEmail:(NSString *)email
                  andFullName:(NSString *)fullName
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    //This gets called whenever setIdentifier is invoked from javascript

    [[Bugsnag configuration] setUser:userId withName:fullName andEmail:email];

    resolve(@"Done");
}






RCT_EXPORT_METHOD(reportException:(NSString *)errorMessage
                  withStack:(NSArray<NSDictionary *> *)stacktrace
                  exceptionId:(NSInteger *)exceptionId
                  andErrorData:(NSDictionary *) errorData
                  isFatal:(BOOL) fatal
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{

    //This gets called whenever a js error gets thrown

    if(self.suppressDev==YES){
        reject(0, @"RNBugsnag won't report errors on dev mode, use setSuppressDebug to set suppress to false in order to use it on dev.", nil);
        return;
    }


    NSMutableArray *stringFrameArray = [[NSMutableArray alloc] init];

    for (NSDictionary *stackFrame in stacktrace) {
        NSString *fileName = [NSString stringWithFormat:@"%@ @ %zd:%zd",
                              [stackFrame[@"file"] lastPathComponent],
                              [stackFrame[@"lineNumber"] integerValue],
                              [stackFrame[@"column"] integerValue]];

        [stringFrameArray addObject:[NSString stringWithFormat:@"%@ %@", fileName, stackFrame[@"methodName"]]];
    }

    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString([stringFrameArray componentsJoinedByString:@"\n"], nil),
                               };

    NSMutableDictionary *allErrorData = [errorData mutableCopy];
    [allErrorData addEntriesFromDictionary:@{@"jsStacktrace": [stringFrameArray componentsJoinedByString:@"\n"]}];

    NSString* severity;
    if(fatal){
        severity = @"error";
    }else{
        severity = @"warning";
    }
    [Bugsnag notify:[NSException exceptionWithName:errorMessage reason:[stringFrameArray componentsJoinedByString:@"\n"] userInfo:userInfo]
           withData:allErrorData atSeverity:severity];

    resolve(@"Done");
}


- (void)notifyWithTitle: (NSString *)exceptionTitle
              andReason:(NSString *)exceptionReason
           withSeverity:(NSString *)severity
           andOtherData:(NSDictionary *) otherData
{
    if(self.suppressDev==YES){
        return;
    }
    [Bugsnag notify:[NSException exceptionWithName:exceptionTitle reason:exceptionReason userInfo:@{}] withData:otherData atSeverity:severity];
}


+ (RNBugsnag*)init
{
    static RNBugsnag *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RNBugsnag alloc] init];
        // Do any other initialisation stuff here
        sharedInstance.suppressDev = false;
        [Bugsnag startBugsnagWithApiKey:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"BUGSNAG_API_KEY"]];
    });
    return sharedInstance;
}
@end
