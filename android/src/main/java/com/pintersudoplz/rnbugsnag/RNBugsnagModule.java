package com.pintersudoplz.rnbugsnag;

import android.content.Context;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

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
        onSuccess.invoke("User identified!");
    }

    @ReactMethod
    public void reportException(String errorMessage, ReadableArray stacktrace, Integer exceptionId, Boolean isFatal, Callback onSuccess, Callback onFailure) {
        //This gets called whenever a js error gets thrown
        onSuccess.invoke("Error!");
    }

}
