import React from 'react-native';
// import _ from 'underscore';


const RNBugsnag = React.NativeModules.RNBugsnag;





/* 
  * The instance of our singleton
  * Setting up block level variable to store class state
  * , set's to null by default.
*/
let instance = null;




export default class PAVBackend {


  /**
   * ## Constructor
   */
  async constructor( props ) {

    //Singleton pattern, see here(http://amanvirk.me/singleton-classes-in-es6/)
    if(!instance){
      instance = this;
    }

    await RNBugsnag.init();

    return instance;
  }



  //TODO: Implement this in the native part
  async setIdentifier(userId, userEmail, userFullname){
  	return await RNBugsnag.setIdentifier(userId, userEmail, userFullname);
  }


  //TODO: Implement this in the native part
  async reportException(error, errorData){

  	if (error instanceof Error) {
    	console.log('notifyError', error, errorData);
    	// const stack = parseErrorStack(error);

	  	return await RNBugsnag.reportException(
	  		error.message,
			// stack,
			// Make all values string
			// _.mapObject(errorData || {}, (val, key) => (val || 'NULL').toString())
		);
	}else {
	    console.warn('attempt to call reportException without an Error', error, errorData);
  	}
  }












}