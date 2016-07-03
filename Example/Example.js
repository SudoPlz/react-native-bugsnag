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
  TouchableOpacity
} from 'react-native';


import RNBugsnag from "react-native-bugsnag";



export default class Example extends Component {
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

        <TouchableOpacity style={styles.button} onPress={()=>{
          // alert("On crash")
          throw new Error("Javascript error test successful!")
        }}>
          <Text style={styles.buttonText}>
            Test crash
          </Text>
        </TouchableOpacity>

      </View>
    );
  }
}




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

