'use strict';

var fs = require('fs');
var path = require('path');

var files = {
  linux: [
    'gitconfig',
    'screenrc',
    'vimrc',
    'zshrc'
  ],
  windows: [
    'nyagos'
  ]
};

function getUserHome() {
  return process.env.HOME || process.env.HOMEPATH || process.env.USERPROFILE;
}

function getOS() {
  if (/^win/.test(process.platform)) {
    return 'windows';
  }
  
  return 'linux';
}

function install() {
  var os = getOS();
  var home = getUserHome();
  
  var length = files[os].length;
  var created = 0;
  
  files[os].forEach(function (file) {
    fs.unlink(
      path.join(home, '.' + file),
      function (err) {
        fs.symlink(
          path.join(__dirname, '_' + file),
          path.join(home, '.' + file),
          function (err) {
            if (err) {
              console.error(err);
              process.exit(1);
            }
            
            if (++created === length) {
              console.log('Create ' + length + ' symbolic link' + (length > 1 ? 's' : ''));
            }
          });
      });
  });
}

install();