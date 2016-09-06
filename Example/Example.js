/**
 * Example
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  Platform
} from 'react-native';


import RNBugsnag from "react-native-bugsnag";



export default class Example extends Component {

  constructor(props){
    super(props);
    // console.log(parseErrorStack());
    RNBugsnag();  //init so that we start listening to js errors

    RNBugsnag().setReleaseStage("staging");
    RNBugsnag().setContext("examplePage");

    const codepushBundleVersion = "42";
    RNBugsnag().setAppVersion(`1.0.1(${codepushBundleVersion})`)
  }

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to RNBugsnag example!
        </Text>

        <Text style={styles.instructions}>
          iOS: Go to the Info.plist within the iOS native project and add your ApiKey,{'\n\n'}
          Android: Then go to the manifest.xml within the Android native project and add your ApiKey.
        </Text>

        <Button onPress={() => { throw new Error("Javascript error test successful!"); } }
            text={`Test crash ${Platform.OS}`} />

        <Button onPress={() => { RNBugsnag().leaveBreadcrumb(`Breadcrumb button pressed!`); } }
            text={"Leave breadcrumb"} />

      </View>
    );
  }
}

const Button = props => {
  const { onPress, text } = props;
  return (
    <TouchableOpacity style={styles.button} onPress={onPress}>
      <Text style={styles.buttonText}> { text } </Text>
    </TouchableOpacity>
  );
};


const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    fontWeight: 'bold',
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginVertical: 25,
    fontSize: 12,
  },
  button:{
    backgroundColor: '#5856D6',
    marginVertical: 5,
    paddingVertical: 15,
    paddingHorizontal: 10,
    borderRadius:3
  },
  buttonText:{
    fontSize: 14,
    fontWeight: 'bold',
    color: 'white'
  }
});
