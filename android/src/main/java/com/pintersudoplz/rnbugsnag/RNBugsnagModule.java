package com.pintersudoplz.rnbugsnag;

import android.content.Context;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

//BUGSNAG ANDROID API HERE : http://docs.bugsnag.com/platforms/android/#installation

// import com.bugsnag.android.Bugsnag;
// import com.bugsnag.android.MetaData;
// import com.bugsnag.android.Severity;


class RNBugsnagModule extends ReactContextBaseJavaModule {
    private Context context;

    public RNBugsnagModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.context = reactContext;
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
    public void init(Callback onSuccess, Callback onFailure) {
        //Run code that initializes BugSnag here
        onSuccess.invoke("Hello World!");
    }


    @ReactMethod
    public void setIdentifier(String userId, String email, String fullName, Callback onSuccess, Callback onFailure) {
        //This gets called whenever setIdentifier is invoked from javascript
        
        // Bugsnag.setUser(userId, email, fullName);

        onSuccess.invoke("User identified!");
    }

    @ReactMethod
    public void reportException(String errorMessage, ReadableArray stacktrace, Integer exceptionId, Boolean isFatal, Callback onSuccess, Callback onFailure) {
        //This gets called whenever a js error gets thrown


        Error error = new Error(title);
        error.setStackTrace(stackTraceToStackTraceElement(stacktrace));

        MetaData metaData = new MetaData();
        metaData.addToTab("Custom", "Stacktrace", stackTraceToString(stacktrace));


        if(isFatal){
            Bugsnag.notify(error, Severity.ERROR, metaData);
        }else{
            Bugsnag.notify(error, Severity.WARNING, metaData);
        }
        



        onSuccess.invoke("Error!");
    }










    private StackTraceElement[] stackTraceToStackTraceElement(ReadableArray stack) {
        StackTraceElement[] stackTraceElements = new StackTraceElement[stack.size()];
        for (int i = 0; i < stack.size(); i++) {
            ReadableMap frame = stack.getMap(i);
            stackTraceElements[i] = new StackTraceElement(
                    "ReactJS",
                    frame.getString("methodName"),
                    new File(frame.getString("file")).getName(),
                    frame.getInt("lineNumber")
            );
        }
        return stackTraceElements;
    }

     private String stackTraceToString(ReadableArray stack) {
        StringBuilder stringBuilder = new StringBuilder();
        for (int i = 0; i < stack.size(); i++) {
            ReadableMap frame = stack.getMap(i);
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
        return stringBuilder.toString();
    }

}
