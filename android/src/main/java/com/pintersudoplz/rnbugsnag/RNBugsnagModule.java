package com.pintersudoplz.rnbugsnag;

import android.content.Context;
import android.util.Log;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableNativeArray;

import com.facebook.react.bridge.Promise;


//BUGSNAG ANDROID API HERE : http://docs.bugsnag.com/platforms/android/#installation

import com.bugsnag.android.Bugsnag;
import com.bugsnag.android.MetaData;
import com.bugsnag.android.Severity;

class RNBugsnagModule extends ReactContextBaseJavaModule {
    private Context context;
    private Boolean suppressDev;

    public RNBugsnagModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.context = reactContext;
        suppressDev = false;
        Bugsnag.init(reactContext);
    }

    /**
     * @return the name of this module. This will be the name used to {@code require()} this module
     * from javascript.
     */
    @Override
    public String getName() {
        return "RNBugsnag";
    }

    @ReactMethod
    public void setIdentifier(String userId, String email, String fullName, Promise promise) {
        //This gets called whenever setIdentifier is invoked from javascript
        
        Bugsnag.setUser(userId, email, fullName);
        promise.resolve("Done!");
    }

    @ReactMethod
    public void notify(String exceptionTitle, String exceptionReason, String severity, Object otherData) {
        //This gets called whenever notify is invoked from javascript

        MetaData metaData = new MetaData();
        //TODO: Convert otherData to metaData
        Throwable error = new Throwable(String exceptionTitle, Throwable exceptionReason);
        Bugsnag.notify(error, severity, metaData);
        promise.resolve("Done!");
    }

    @ReactMethod
    public void reportException(String errorMessage, ReadableArray stacktrace, Integer exceptionId, ReadableMap otherData, Boolean isFatal, Promise promise) {
        //This gets called whenever a js error gets thrown

        if(suppressDev==true){
            promise.reject("0","RNBugsnag won't report errors on dev mode, use setSuppressDebug to set suppress to false in order to use it on dev.");
            return;
        }

        BugsnagStack st = new BugsnagStack(stacktrace);
        
        Error error = new Error(errorMessage);
        error.setStackTrace(st.getStackTrace());

        MetaData metaData = new MetaData();
        metaData.addToTab("Custom", "exceptionId", exceptionId);
        metaData.addToTab("Custom", "jsStacktrace", st.getStackTraceStr());

        if(isFatal){
            Bugsnag.notify(error, Severity.ERROR, metaData);
        }else{
            Bugsnag.notify(error, Severity.WARNING, metaData);
        }
        



        promise.resolve("Done!");
    }

    @ReactMethod
    public void setSuppressDebug(Boolean suppress, Promise promise) {
        //This gets called whenever setSuppressDebug is invoked from javascript
        suppressDev = suppress;
        promise.resolve("Done!");
    }

}



class BugsnagStack {
    private StackTraceElement[] stackTrace;
    private String stackStr;

    public BugsnagStack(ReadableArray stack) {
        super();
        stackTrace = new StackTraceElement[stack.size()];
        StringBuilder stringBuilder = new StringBuilder();
        for (int i = 0; i < stack.size(); i++) {
            ReadableMap frame = stack.getMap(i);
            stackTrace[i] = new StackTraceElement(
                    "ReactJS",
                    frame.getString("methodName"),
                    new File(frame.getString("file")).getName(),
                    frame.getInt("lineNumber")
            );
            stringBuilder.append(frame.getString("methodName"));
            stringBuilder.append("\n    ");
            stringBuilder.append(new File(frame.getString("file")).getName());
            stringBuilder.append(":");
            stringBuilder.append(frame.getInt("lineNumber"));
            if (frame.hasKey("column") && !frame.isNull("column")) {
                stringBuilder
                        .append(":")
                        .append(frame.getInt("column"));
            }
            stringBuilder.append("\n");
        }
        stackStr = stringBuilder.toString();
    }

    public StackTraceElement[] getStackTrace(){
        return stackTrace;
    }

    public String getStackTraceStr(){
        return stackStr;
    }

}