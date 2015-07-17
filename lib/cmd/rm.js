'use strict';

var exec = require('child_process').exec;

function rm_rf(dir, cb) {
  var cmd = 'rm -rf ' + dir;

  console.log('> ' + cmd);
  exec(cmd, function (err, stdout, stderr) {
    cb(err);
  });
}

module.exports = {
  rm_rf: rm_rf
};
