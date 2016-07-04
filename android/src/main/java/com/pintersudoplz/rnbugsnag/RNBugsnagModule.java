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

    public RNBugsnagModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.context = reactContext;
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
    public void reportException(String errorMessage, ReadableArray stacktrace, Integer exceptionId, ReadableMap otherData, Boolean isFatal, Promise promise) {
        //This gets called whenever a js error gets thrown

        ArrayList<Object> stack = ((ReadableNativeArray ) stacktrace).toArrayList();
        Error error = new Error(errorMessage);
        error.setStackTrace(stackTraceToStackTraceElement(stack));

        MetaData metaData = new MetaData();
        metaData.addToTab("Custom", "Stacktrace", stackTraceToString(stack));

        if(isFatal){
            Bugsnag.notify(error, Severity.ERROR, metaData);
        }else{
            Bugsnag.notify(error, Severity.WARNING, metaData);
        }
        



        promise.resolve("Done!");
    }










    private StackTraceElement[] stackTraceToStackTraceElement(ArrayList<Object> stack) {
        StackTraceElement[] stackTraceElements = new StackTraceElement[stack.size()];
        for (int i = 0; i < stack.size(); i++) {
            HashMap<String, Object> frame = (HashMap<String, Object>) stack.get(i);
            stackTraceElements[i] = new StackTraceElement(
                    "ReactJS",
                    (String) frame.get("methodName"),
                    new File((String) frame.get("file")).getName(),
                    (Integer) ((Double) frame.get("lineNumber")).intValue()
            );
        }
        return stackTraceElements;
    }

     private String stackTraceToString(ArrayList<Object> stack) {
        StringBuilder stringBuilder = new StringBuilder();
        for (int i = 0; i < stack.size(); i++) {
            HashMap<String, Object> frame = (HashMap<String, Object>) stack.get(i);
            stringBuilder.append((String) frame.get("methodName"));
            stringBuilder.append("\n    ");
            stringBuilder.append(new File((String) frame.get("file")).getName());
            stringBuilder.append(":");
            stringBuilder.append( (Integer) ((Double) frame.get("lineNumber")).intValue());
            if (frame.containsKey("column") && frame.get("column")!=null) {
                stringBuilder
                        .append(":")
                        .append((Integer) ((Double) frame.get("column")).intValue());
            }
            stringBuilder.append("\n");
        }
        return stringBuilder.toString();
    }

}
