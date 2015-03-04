'use strict';

var path = require('path');

exports.getWorkingDirectory = function () {
  return path.join(__dirname, '..');
};

exports.getUserHome = function () {
  return process.env.HOME || process.env.HOMEPATH || process.env.USERPROFILE;
};

var getOS = exports.getOS = function () {
  if (/^win/.test(process.platform)) {
    return 'windows';
  }
  
  return 'linux';
};

exports.getOptions = function () {
  return {
    os: getOS()
  };
};

// vim: se et ts=2 sw=2 sts=2 ft=javascript :
