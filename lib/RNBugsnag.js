import React from 'react-native';
// import _ from 'underscore';


const NativeBugsnag = React.NativeModules.RNBugsnag;
import parseErrorStack from 'parseErrorStack';




/* 
  * The instance of our singleton
  * Setting up block level variable to store class state
  * , set's to null by default.
*/
let instance = null;
let exceptionID = 0;

//exception report timeout
const timeoutPromise = new Promise((resolve) => {
  setTimeout(() => {
    resolve();
  }, 1000);
});








export default class RNBugsnag {


  /**
   * ## Constructor
   */
  async constructor( props ) {

    //Singleton pattern, see here(http://amanvirk.me/singleton-classes-in-es6/)
    if(!instance){
      instance = this;
    }

    //intercept react-native error handling
    if (NativeBugsnag && ErrorUtils._globalHandler) {
      instance.defaultHandler = ErrorUtils.getGlobalHandler && ErrorUtils.getGlobalHandler() || ErrorUtils._globalHandler;
      ErrorUtils.setGlobalHandler(this.wrapGlobalHandler);  //feed errors directly to our wrapGlobalHandler function
    }

    //if there's a key, save it
    if(!!props && !!props.ApiKey){
      instance.apiKey = props.ApiKey;
    }else{
      throw new Error("RNBugsnag :: Did you forget to pass an `ApiKey` within the RNBugsnag first parameter? i.e RNBugsnag({ApiKey: 'YOUR_KEY'})");
    }

    await NativeBugsnag.init(instance.apiKey); //init our native part 
    return instance;
  }




  //TODO: Implement this in the native part of setIdentifier
  async wrapGlobalHandler(error, isFatal){
    let currentExceptionID = ++exceptionID;
    const stack = parseErrorStack(error);

    
    const reportExceptionPromise = NativeBugsnag.reportException(error.message, stack, currentExceptionID, isFatal);   //submit the exception to our native part

    return Promise.race([reportExceptionPromise, timeoutPromise])   //whatever finishes first
    .then(() => {  //afterwards call the default error handler
      instance.defaultHandler(error, isFatal);
    });
  }



  //TODO: Implement this in the native part of setIdentifier
  async setIdentifier(userId, userEmail, userFullname){
  	return await NativeBugsnag.setIdentifier(userId, userEmail, userFullname);
  }


}