import React from 'react-native';
import stacktraceParser from 'stacktrace-parser';
// import _ from 'underscore';


const NativeBugsnag = React.NativeModules.RNBugsnag;

let exceptionID = 0;

//exception report timeout
const timeoutPromise = new Promise((resolve) => {
    setTimeout(() => {
        resolve();
    }, 1000);
});

const parseErrorStack = (error) => {
    if (!error || !error.stack) {
        return [];
    }
    return Array.isArray(error.stack) ? error.stack :
        stacktraceParser.parse(error.stack);
}


export function setup(props) {

    if (NativeBugsnag && ErrorUtils._globalHandler) {
        let defaultHandler = ErrorUtils.getGlobalHandler && ErrorUtils.getGlobalHandler() || ErrorUtils._globalHandler;
        ErrorUtils.setGlobalHandler((e, isFatal) => {
            let currentExceptionID = ++exceptionID;
            const stack = parseErrorStack(error);
            const reportExceptionPromise = NativeBugsnag.reportException(error.message, stack, currentExceptionID, {}, isFatal); //submit the exception to our native part
            return Promise.race([reportExceptionPromise, timeoutPromise]) //whatever finishes first
                .then(() => { //afterwards call the default error handler
                    defaultHandler(error, isFatal);
                });
        });
    }

    if (!!props && !!props.identifier) {
        setIdentifier(props.identifier.userId, props.identifier.userEmail, props.identifier.userFullname);
    }

    if (!!props && props.suppressDevErrors != null) { //if the user has specified wether to suppress or not
        setSuppressDebugOnDev(!!props.suppressDevErrors); //do what the user wishes to do
    } else { //otherwise
        setSuppressDebugOnDev(__DEV__ === true); // if on DEV suppress all the errors, otherwise don't
    }

}

export async function setSuppressDebugOnDev(suppress) {
    return await NativeBugsnag.setSuppressDebug(suppress);
}



export async function notify(exceptionTitle, exceptionReason, severity, otherData) {
    return await NativeBugsnag.notify(exceptionTitle, exceptionReason, severity, otherData);
}

export async function leaveBreadcrumb(message) {
    return await NativeBugsnag.leaveBreadcrumb(message);
}

export async function setContext(context) {
    return await NativeBugsnag.setContext(context);
}

export async function setReleaseStage(releaseStage) {
    return await NativeBugsnag.setReleaseStage(releaseStage);
}

export async function setAppVersion(appVersion) {
    return await NativeBugsnag.setAppVersion(appVersion);
}

export async function setIdentifier(userId, userEmail, userFullname) {
    return await NativeBugsnag.setIdentifier(userId, userEmail, userFullname);
}
