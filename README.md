# React Native Bugsnag

Easily add **[Bugsnag](https://bugsnag.com/)** exception monitoring support to your React Native application.

_Although this is not affiliated with Bugsnag directly, we do have [their support](https://twitter.com/bugsnag/status/749027008085045252)._

### Installation (TODO)

```bash
npm install -s react-native-bugsnag
```


### Usage

```js
import RNBugsnag from 'react-native-bugsnag'

RNBugsnag({ApiKey: "YOUR_API_KEY_FROM_BUGSNAG"})
```


### API

| method | parameters (body) | Description | Returns|
|---------------|-------------------------------------------------|--------------------------------------------------------------|-----|
| **setIdentifier** | {`userId`:string, `userEmail`: string, `userFullname`: string} |  This function sets the id of the user that we will be logging.| Promise |



### Bugsnag Symbolication

This is an important part of the process in order to get the actual method names and line numbers of the exceptions.

http://docs.bugsnag.com/platforms/ios-objc/symbolication-guide/
