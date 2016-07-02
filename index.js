'use strict';
import RNBugsnag from './lib/RNBugsnag';


module.exports = function (initData) {
  return new RNBugsnag(initData);
}