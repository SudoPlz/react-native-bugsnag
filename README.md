# React Native Bugsnag

Easily add **[Bugsnag](https://bugsnag.com/)** exception monitoring support to your React Native application.

_Although this is not affiliated with Bugsnag directly, we do have [(some of) their support](https://twitter.com/bugsnag/status/749027008085045252)._

## Installation

First of all install RNBugsnag:

  ```bash
  rnpm install --save react-native-bugsnag
  ```

### iOS

1. Install the official iOS Bugsnag sdk into your app according to their **[iOS instructions][ios-installation]**.
   
   I chose the `Cocoapods` way meaning I just created a podfile and added `pod 'Bugsnag'` in it.
  
2. In your `AppDelegate.m` file, add the following code changes:

  a. Import our RNBugsnag library:

  ```objective-c
  #import <RNBugsnag/RNBugsnag.h>  // Add this line.

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
  
  



  
  


### Android

1. Go to your settings.gradle and add the following lines after 
 	
 	```java
 	//somewhere after include ':app' add the following 2 lines
 	
	include ':react-native-bugsnag'
	project(':react-native-bugsnag').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-bugsnag/android')
	```

2. Go to your app.gradle and add the following line in the end:
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
	
4. Go to your `MainActivity.java` and add the following code:

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


## Usage


#### Unhandled errors (Automatic dispatch):
1. Include React Native Bugsnag in your React Native app:  

  ```js
  import Bugsnag from 'react-native-bugsnag';
  ```
 

2. Anywhere in the code:


  ```js
  Bugsnag();   //This initializes the singleton (CAUTION: The new keyword is never used with Bugsnag). 
  ```

Congratulations!! You just initialized RNBugsnag. Note that we never used the `new` keyword anywhere. Thats because Bugsnag() returns the same instance of the singleton no matter how many times you call it like so.

At that point you have basic native error reporting functionality working. Any unhandled javascript or native errors thrown will be reported to Bugsnag without any more lines of code.



### API

#### Things you can pass to the constructor:

  - You can suppress all the outgoing Error reports to bugsnag by setting `suppressDevErrors` to true and passing it to the constructor, like so:

  ```js
    Bugsnag({suppressDevErrors:true});
  ```
  
  - You can set identification data for the current user while initiating BugSnag by passing the `identifier` object to the constructor, like so:
  
  ```js
    Bugsnag({identifier:{userId: "aUserId", userEmail:"anEmail@domain.com", userFullname:"aFullName"}})
  ```
  

After you've passed options to the constructor once, those options remain unchanged no matter how many times you call the constructor after that (`Bugsnag` is a singleton). The only way to change those options from that point on is using setter methods.


#### Setting the identifier for the user at some other point in code:

This will let you know more details about the person that got the crash.

```js
  Bugsnag().setIdentifier("aUserId", "aUserEmail", "userFullname");
  ```

#### Handled errors (Manual dispatch):

You can manually create an exception using the following command:

  ```js
  Bugsnag().notify("TestExceptionName", "TestExceptionReason", "error");
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

    RNBugsnag({suppressDevErrors:false, identifier:{userId: "aUserId", userEmail:"anEmail@domain.com", userFullname:"aFullName"}});

    setTimeout(function(){
      RNBugsnag().notify("WhateverError", "This error was just meant to be.", "error"); 
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
- [ ] Create some nice graphics for this README.
- [ ] Test RNPM installation process.
- [ ] Submit to js.coach and Bugsnag.



[android-installation]: http://docs.bugsnag.com/platforms/android/#installation
[ios-installation]:     http://docs.bugsnag.com/platforms/ios-objc/#installation
