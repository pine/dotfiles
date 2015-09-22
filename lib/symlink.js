'use strict';

var fs = require('fs');
var path = require('path');

var async = require('./simple/async');
var files = require('../conf/symlink.json');

function install(src, dest, options, cb) {
  var os = options.os;
  var length = files[os].length;

  async.each(files[os], function (file, done) {
    fs.unlink(
      path.join(dest, '.' + file),
      function (err) {
        // err - failsafe
        fs.symlink(
          path.join(src, 'rc/.' + file),
          path.join(dest, '.' + file),
          function (err) {
            if (err) { return done(err); }
            console.log('Created .' + file);
          }
        );
      });
  }, function (err) {
    if (err) { return cb(err); }

    console.log('Created ' + length + ' symbolic link' + (length > 1 ? 's' : ''));
    cb();
  });
}

module.exports = install;
