# React Native Bugsnag

Easily add **[Bugsnag](https://bugsnag.com/)** exception monitoring support to your React Native application.

_Although this is not affiliated with Bugsnag directly, we do have [their support](https://twitter.com/bugsnag/status/749027008085045252)._

## Installation

### iOS

1. Install Bugsnag into your app according to their **[iOS][ios-installation]** instructions.

   Ensure that [Symbolication](#symbolication) is properly setup in your project as well.

2. In your AppDelegate.m file, add the following code changes:

  a. Import the Bugsnag library:

  ```objective-c
  #import <Bugsnag/Bugsnag.h>  // Add this line.

  @implementation AppDelegate
  ```

  b. Initialize Bugsnag with your API key inside of `didFinishLaunchingWithOptions`:

  ```objective-c
  - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

  // ... other code

  [Bugsnag startBugsnagWithApiKey:@"your-api-key-goes-here"]; // Add this line.

  // ... other code

  }
  ```

3. Install the React Native Bugsnag package:

  ```bash
  npm install --save react-native-bugsnag
  ```

  _(Make sure to restart your package manager afterwards.)_


### Android

1. Install Bugsnag into your app according to their **[Android][android-installation]** instructions.

2. _TODO_


## Usage

1. Include React Native Bugsnag in your React Native app:

  ```js
  var Bugsnag = require('react-native-bugsnag');
  ```

2. Test out manually creating an exception with the following:

  ```js
  Bugsnag.notify("TestExceptionName", "TestExceptionReason", null);
  ```


## API

<!-- | method | parameters (body) | Description | Returns|
|---------------|-------------------------------------------------|--------------------------------------------------------------|-----|
| **setIdentifier** | {`userId`:string, `userEmail`: string, `userFullname`: string} |  This function sets the id of the user that we will be logging.| Promise | -->



## Symbolication

This is an important part of the process in order to get the actual method names and line numbers of the exceptions.

http://docs.bugsnag.com/platforms/ios-objc/symbolication-guide/

[android-installation]: http://docs.bugsnag.com/platforms/android/#installation
[ios-installation]:     http://docs.bugsnag.com/platforms/ios-objc/#installation
