'use strict';

var fs = require('fs');

function mkdir_p(dir, cb) {
  console.log('> mkdir -p ' + dir);
  fs.stat(dir, function (err, stat) {
    if (!err && stat.isDirectory()) { return cb(); }

    if (err) {
      return mkdir_impl(dir, function (err) {
        cb(err);
      });
    }

    cb(dir + ' is not directory');
  });
}

function mkdir_impl(dir, cb) {
  fs.mkdir(dir, cb);
}

module.exports = {
  mkdir_p: mkdir_p
};
