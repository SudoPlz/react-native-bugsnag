# React Native Bugsnag [![npm version](https://badge.fury.io/js/react-native-bugsnag.svg)](https://badge.fury.io/js/react-native-bugsnag)

Easily add **[Bugsnag](https://bugsnag.com/)** exception monitoring support to your React Native application.


This is a third party library and we are NOT affiliated with Bugsnag.._

>This library works with iOS and Android, and what it actually does is, it helps you poor folk get reports from crashes/exceptions right into the bugsnag dashboard. You can then go ahead and repair the bug yourself without having to ask your team members or your client a zillion questions just to be able to reproduce the error. Now you know *where* the crash happened and *why* remotely and instantaneously. Isn't that neat? You're so cool!

## Installation 


Start with:

 `rnpm install react-native-bugsnag`

Theres a quick guide [over to our wiki.](https://github.com/SudoPlz/react-native-bugsnag/wiki)

### Look ma, theres an working example too:
[Check it out](https://github.com/SudoPlz/react-native-bugsnag/tree/master/Example)


### Enjoy!

![](https://media.giphy.com/media/10Y2YMUNmQa9a0/giphy.gif)



##Sample code:
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


### Breaking changes to version 1.0.0

We now use `new Bugsnag()` instead of directly calling `Bugsnag()`.
Note that even though we use the `new` keyword we're still receiving a singleton instance and thus it will only be used as a constructor the first time you call it.


Checklist:
- [x] Supports iOS.
- [x] Supports Android.
- [x] Configure Bugsnag from JS.
- [x] Handle different handled exceptions in JS.
- [x] Show line numbers (and method names?) in JS errors.
- [x] Test RNPM installation process and confirm its working.



[android-installation]: http://docs.bugsnag.com/platforms/android/#installation
[ios-installation]:     http://docs.bugsnag.com/platforms/ios-objc/#installation
