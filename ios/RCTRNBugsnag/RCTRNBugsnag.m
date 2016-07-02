#import "RCTRNBugsnag.h"
//#import "Bugsnag.h"


@implementation RNBugsnag

//BUGSNAG IOS API HERE : http://docs.bugsnag.com/platforms/ios/#installation


RCT_EXPORT_MODULE();





RCT_EXPORT_METHOD(init,
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    
    //Run code that initializes BugSnag here
    
//    [Bugsnag startBugsnagWithApiKey:@"FETCH_THE_API_KEY_FROM_INFO_PLIST_AND_PASS_HERE"];

    resolve(@"Hello World!");
}






RCT_EXPORT_METHOD(setIdentifier:(NSString *)userId
                  withEmail:(NSString *)email
                  andFullName:(NSString *)fullName
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
        //This gets called whenever setIdentifier is invoked from javascript
    
    #ifdef DEBUG
        reject(@"RNBugsnag won't report errors on dev mode");
        return;
    #endif
    [[Bugsnag configuration] setUser:userId withName:fullName andEmail:email];
    
    resolve(@"User identified");
}






RCT_EXPORT_METHOD(reportException:(NSString *)errorMessage
                  withStack:(NSArray<NSDictionary *> *)stacktrace
                  andExceptionId:(NSInteger *)exceptionId
                  isFatal:(BOOL) fatal
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    
    //This gets called whenever a js error gets thrown
    
    #ifdef DEBUG
        reject(@"RNBugsnag won't report errors on dev mode");
        return;
    #endif
    
    
    
    NSMutableArray *stringFrameArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *stackFrame in stack) {
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
    [allErrorData addEntriesFromDictionary:@{@"Stacktrace": [stringFrameArray componentsJoinedByString:@"\n"]}];
    
    NSString* severity;
    if(isFatal){
        severity = @"error"
    }else{
        severity = @"warning"
    }
//    [Bugsnag notify:[NSException exceptionWithName:errorMessage reason:[stringFrameArray componentsJoinedByString:@"\n"] userInfo:userInfo]
//           withData:allErrorData atSeverity:severity];
    
    resolve(@"Error");
}






@end
