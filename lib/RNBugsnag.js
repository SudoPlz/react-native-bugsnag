import React from 'react-native';
import stacktraceParser from 'stacktrace-parser';
// import _ from 'underscore';


const NativeBugsnag = React.NativeModules.RNBugsnag;





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

const parseErrorStack = (error)=>{
  if (!error || !error.stack) {
    return [];
  }
  return Array.isArray(error.stack) ? error.stack :
    stacktraceParser.parse(error.stack);
}






export default class RNBugsnag {


  /**
   * ## Constructor
   */
  constructor( props ) {


    //Singleton pattern, see here(http://amanvirk.me/singleton-classes-in-es6/)
    if(!instance){
      instance = this;
      // console.log("Initializing instance!! ");
    }



    //intercept react-native error handling
    if (NativeBugsnag && ErrorUtils._globalHandler) {
      this.defaultHandler = ErrorUtils.getGlobalHandler && ErrorUtils.getGlobalHandler() || ErrorUtils._globalHandler;
      ErrorUtils.setGlobalHandler(this.wrapGlobalHandler.bind(this));  //feed errors directly to our wrapGlobalHandler function
    }
    

    if(!!props && !!props.identifier){
      this.setIdentifier(props.identifier.userId, props.identifier.userEmail, props.identifier.userFullname);
    }

    if(!!props && props.suppressDevErrors===true){
      this.setSuppressDebugOnDev(true);
    }

    return instance;
  }


  async setSuppressDebugOnDev(suppress){
    return await NativeBugsnag.setSuppressDebug(suppress);  
  }

  async wrapGlobalHandler(error, isFatal){
    let currentExceptionID = ++exceptionID;
    const stack = parseErrorStack(error);
    const reportExceptionPromise = NativeBugsnag.reportException(error.message, stack, currentExceptionID, {}, isFatal);   //submit the exception to our native part
    return Promise.race([reportExceptionPromise, timeoutPromise])   //whatever finishes first
    .then(() => {  //afterwards call the default error handler
      this.defaultHandler(error, isFatal);
    });
  }


  async notify(exceptionTitle, exceptionReason, severity, otherData){
    return await NativeBugsnag.notify(exceptionTitle, exceptionReason, severity, otherData);  
  }


  async setIdentifier(userId, userEmail, userFullname){
    return await NativeBugsnag.setIdentifier(userId, userEmail, userFullname);
  }


};
