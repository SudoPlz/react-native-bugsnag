# React Native Bugsnag [![npm version](https://badge.fury.io/js/react-native-bugsnag.svg)](https://badge.fury.io/js/react-native-bugsnag)

Easily add **[Bugsnag](https://bugsnag.com/)** exception monitoring support to your React Native application.

_Although this is not affiliated with Bugsnag directly, we do have [(some of) their support](https://twitter.com/bugsnag/status/749027008085045252)._

## Installation 
###Step 1

First of all go to the [Busnag Dashboard](https://app.bugsnag.com/) and create one or more projects (read on to decide how many you need). 
You can:
 - either create a single project (of type javascript) that handles errors from every source (all iOS, Android, and react-native). (This is my preferred method)
 - or you can use two separate projects (of types ios and java) to logically separate the stack traces generated on each platform respectively.


p.s: One of the guys from Bugsnag told me that in time they plan to add a project of type `hybrid`, that would have several benefits.

####More details about the lines above - if not interested move to Step 2

Below you can see how each error is handled based on what kind of project you setup in the Bugsnag dashboard.

ProjectTypes / Platform error | iOS native induced error | Android native induced error  | React-Native javascript induced error
| ------------- | :-------------: | :-------------: | :-------------: |
| Bugsnag iOS project type  | :white_check_mark:   | :x:   | :x: |
| Bugsnag Android project  | :x:   | :white_check_mark:   | :x:  |
| Bugsnag javascript project  (one project for all errors) | :white_check_mark:   | :white_check_mark:   | :white_check_mark:  |


p.s: Bugsnag claims to be working on a hybrid project type that can detect different types of stack traces better.

###Step 2

Install RNBugsnag (the javascript part of our library):

  ```bash
  npm install react-native-bugsnag --save
  ```
  
  or you could try to install it using `rnpm` but I've never tested it.

### Step 3 - iOS (If needed)

1. Install the official iOS Bugsnag sdk into your app according to their **[iOS instructions][ios-installation]**.
   
   I chose the `Cocoapods` way meaning I just created a podfile in my projects iOS dir, added `pod 'Bugsnag'` in the podfile, and ran `pod install`.
  
2. In your `AppDelegate.m` file, add the following code changes:

  a. Import our RNBugsnag library within your `AppDelegate.m` file:

  ```objective-c
  // Add just ONE of the following lines:
  
  #import "RNBugsnag.h" // if installed by using Cocoapods
  //OR
  #import <RNBugsnag/RNBugsnag.h>  // if installed by using Carthage

  @implementation AppDelegate
    
    // ... other code
  ```

  b. Initialize RNBugsnag inside of `didFinishLaunchingWithOptions`:
  

  ```objective-c
  - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
  {

    // ... other code

    [RNBugsnag init];	//initialize it

  }
  ```
  
  c. Add your BUSNAG Api Key inside the Info.Plist like so:
  
  	Add a new entry with a key of: `BUGSNAG_API_KEY` and a value of your Bugsnag API KEY ([Usually found within your project here](https://bugsnag.com/settings/)).
  	Opening the `Info.Plist` with a texBt editor your addition should look like this:
  	
  	```
  	<key>BUGSNAG_API_KEY</key>
	<string>whatever_your_api_key_is</string>
	```
  
  d. (Do this step ONLY if you installed using **Carthage**.) Add `Bugsnag` to the RNBugsnag library. I did this by dragging the `Bugsnag.framework` I made in step 1 to my RNBugsnag module target.
  
  



  
  


### Step 4 - Android (If needed)

1. Go to your settings.gradle and add the following lines after 
 	
 	```java
 	//somewhere after include ':app' add the following 2 lines
 	
	include ':react-native-bugsnag'
	project(':react-native-bugsnag').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-bugsnag/android')
	```

2. Go to your app/settings.gradle and add the following line in the end:
	```java
	dependencies {
	    compile fileTree(dir: 'libs', include: ['*.jar'])
	    compile 'com.android.support:appcompat-v7:23.0.1'
	    compile 'com.facebook.react:react-native:+'
	    //...whatever code
	
	    compile project(':react-native-bugsnag')	//<--Add this line
	}
	```
3. Go to your `manifest.xml` and add the following line within the application tag replacing `YOUR_API_KEY`:

	```
	<meta-data android:name="com.bugsnag.android.API_KEY" android:value="YOUR_API_KEY"/>
	```
	
4. Go to your `MainApplication.java` and add the following code:

	```
	import com.pintersudoplz.rnbugsnag.RNBugsnagPackage;
	```
	and then within your `getPackages` add the line with the comment
	
	```java
	@Override
    protected List<ReactPackage> getPackages() {
	    // ...whatever code
	    return Arrays.<ReactPackage>asList(
            new MainReactPackage(),            
            new RNBugsnagPackage()  //add this line
        );
    }
	```

### Congrats you're ready! 

![](https://media.giphy.com/media/10Y2YMUNmQa9a0/giphy.gif)

## Usage


#### Unhandled errors (Automatic dispatch):
1. Include React Native Bugsnag in your React Native app:  

  ```js
  import Bugsnag from 'react-native-bugsnag';
  ```
 

2. Anywhere in the code:


  ```js
let bugsnag = new Bugsnag({suppressDevErrors:false});   //This initializes the singleton
  ```

Congratulations!! You just initialized RNBugsnag. Thats because Bugsnag() returns the same instance of the singleton no matter how many times you call it like so.

At that point you have basic native error reporting functionality working. Any unhandled javascript or native errors thrown will be reported to Bugsnag without any more lines of code.



### API

#### Things you can pass to the constructor:

  - You can suppress all the outgoing Error reports to bugsnag by setting `suppressDevErrors` to true and passing it to the constructor, like so:

  ```js
    let bugsnag = new Bugsnag({suppressDevErrors:true});
  ```
  
  - You can set identification data for the current user while initiating BugSnag by passing the `identifier` object to the constructor, like so:
  
  ```js
    let bugsnag = new Bugsnag({identifier:{userId: "aUserId", userEmail:"anEmail@domain.com", userFullname:"aFullName"}, suppressDevErrors:true})
  ```


After you've passed options to the constructor once, those options remain unchanged no matter how many times you call the constructor after that (`Bugsnag` is a singleton). The only way to change those options from that point on is using setter methods.


#### Setting the identifier for the user at some other point in code:

This will let you know more details about the person that got the crash.

```js
    bugsnag.setIdentifier("aUserId", "aUserEmail", "userFullname");
```

#### Logging breadcrumbs

> In order to understand what happened in your application before each crash, it can be helpful to leave short log statements that we call breadcrumbs. The last several breadcrumbs are attached to a crash to help diagnose what events lead to the error. – Bugsnag

```js
  bugsnag.leaveBreadcrumb("some actions were done")
```

#### Setting Release Stage

> In order to distinguish between errors that occur in different stages of the application release process a release stage is sent to Bugsnag when an error occurs – Bugsnag

```js
  bugsnag.setReleaseStage("staging");
```

#### Setting Context

> Bugsnag uses the concept of “contexts” to help display and group your errors. Contexts represent what was happening in your application at the time an error occurs. – Bugsnag

```js
  bugsnag.setContext("loginPage");
```

#### Setting AppVersion

> If you want to manually track in which versions of your application each exception happens, you can set appVersion. – Bugsnag

This will be useful when using OTA updates.

```js
  bugsnag.setAppVersion(`${appBinaryVersion}(${codepushBundleVersion})`);
```

#### Handled errors (Manual dispatch):

You can manually create an exception using the following command:

  ```js
  bugsnag.notify("TestExceptionName", "TestExceptionReason", "error");
  ```

The third parameter is the severity of the notification, it can be one of the following:

- "error"
- "warning"
- "info"

<!-- | method | parameters (body) | Description | Returns|
|---------------|-------------------------------------------------|--------------------------------------------------------------|-----|
| **setIdentifier** | {`userId`:string, `userEmail`: string, `userFullname`: string} |  This function sets the id of the user that we will be logging.| Promise | -->



## Source maps

In order to get a readable stacktrace with the exact place the error took place all you need to do is  [create sourcemaps for your app](http://stackoverflow.com/questions/34715106/how-to-added-sourcemap-in-react-native-for-production), then [upload them to bugsnag](http://docs.bugsnag.com/api/js-source-map-upload/#uploading-source-maps)  and then make your project of **type Javascript** in the bugsnag dashboard, (you do that from their Settings screen). I did that and now I get a translated stacktrace I can read.




##Example code:
```js

import RNBugsnag from 'react-native-bugsnag';

class AnExampleClass {
  /**
   * ## Constructor
   */
  constructor( props ) {

    let bugsnag = new RNBugsnag({suppressDevErrors:false, identifier:{userId: "aUserId", userEmail:"anEmail@domain.com", userFullname:"aFullName"}});

    setTimeout(function(){
      bugsnag.notify("WhateverError", "This error was just meant to be.", "error"); 
    }, 3000);

  }
};

```


## TODO
- [x] Support iOS.
- [x] Support Android.
- [x] Configure Bugsnag from JS.
- [x] Handle different handled exceptions in JS.
- [x] Show line numbers (and method names?) in JS errors.
- [ ] Test RNPM installation process.
- [ ] Submit to js.coach and Bugsnag.



[android-installation]: http://docs.bugsnag.com/platforms/android/#installation
[ios-installation]:     http://docs.bugsnag.com/platforms/ios-objc/#installation
