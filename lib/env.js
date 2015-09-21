'use strict';

var path = require('path');
var wrap = require('./simple/wrapple');

wrap('process');

exports.getWorkingDirectory = function () {
  return path.join(__dirname, '..');
};

exports.getUserHome = function () {
  if (getOS() === 'windows') {
    return wrap('process').env.USERPROFILE;
  }

  return wrap('process').env.HOME;
};

var getOS = exports.getOS = function () {
  if (/^win/.test(wrap('process').platform)) {
    return 'windows';
  }

  if (/^darwin/.test(wrap('process').platform)) {
    return 'darwin';
  }

  return 'linux';
};

exports.getOptions = function () {
  return {
    os: getOS()
  };
};

// vim: se et ts=2 sw=2 sts=2 ft=javascript :
