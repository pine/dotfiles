'use strict';

var fs = require('fs');
var path = require('path');

var files = require('../conf/symlink.json');


function install(src, dest, options, cb) {
  var os = options.os;
  var length = files[os].length;
  var created = 0;

  files[os].forEach(function (file) {
    fs.unlink(
      path.join(dest, '.' + file),
      function (err) {
        fs.symlink(
          path.join(src, '_' + file),
          path.join(dest, '.' + file),
          function (err) {
            if (err) {
              console.error(err);
              process.exit(1);
            }

            console.log('Created .' + file);

            if (++created === length) {
              console.log('Created ' + length + ' symbolic link' + (length > 1 ? 's' : ''));
              cb();
            }
          });
      });
  });
}

module.exports = install;
