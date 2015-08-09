'use strict';

var fs = require('fs');
var path = require('path');

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
  fs.mkdir(dir, function (err) {
    if (err){
      if (err.errno === 34) {
        return mkdir_impl(path.dirname(dir), function (err) {
          if (err) { return cb(err); }
          mkdir_impl(dir, cb);
        });
      }

      return cb(err);
    }
    return cb();
  });
}

module.exports = {
  mkdir_p: mkdir_p
};
