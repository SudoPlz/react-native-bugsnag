#import "RNBugsnag.h"

#import <Bugsnag/Bugsnag.h>

@implementation RNBugsnag

RCT_EXPORT_MODULE();




RCT_EXPORT_METHOD(notify:(NSString *)exceptionTitle
                  reason:(NSString *)exceptionReason
                  withSeverity:(NSString *)severity
                  andOtherData:(NSDictionary *) otherData
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    //    #ifdef DEBUG
    //        reject(@"RNBugsnag won't report errors on dev mode");
    //        return;
    //    #endif
    [Bugsnag notify:[NSException exceptionWithName:exceptionTitle reason:exceptionReason userInfo:@{}] withData:otherData atSeverity:severity];
    resolve(@"Done");
}





RCT_EXPORT_METHOD(setIdentifier:(NSString *)userId
                  withEmail:(NSString *)email
                  andFullName:(NSString *)fullName
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
        //This gets called whenever setIdentifier is invoked from javascript

//    #ifdef DEBUG
//        reject(@"RNBugsnag won't report errors on dev mode");
//        return;
//    #endif
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

//    #ifdef DEBUG
//        reject(@"RNBugsnag won't report errors on dev mode");
//        return;
//    #endif



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



+ (void) init{
    [Bugsnag startBugsnagWithApiKey:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"BUGSNAG_API_KEY"]];
}



@end
