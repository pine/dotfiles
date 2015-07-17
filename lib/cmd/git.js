'use strict';

var fs = require('fs');
var path = require('path');
var exec = require('child_process').exec;

var rm_rf = require('./rm').rm_rf;

function git_clone(url, dir, cb) {
  fs.stat(path.join(dir, '.git'), function (err, stat) {
    if (!err && stat.isDirectory()) { return cb(); }

    if (err) {
      return git_clone_impl(url, dir, function (err) {
        cb(err);
      });
    }

    git_clone_force(url, dir, cb);
  });
}

function git_clone_force(url, dir, cb) {
  rm_rf(dir, function (err) {
    if (err) { return cb(err); }

    git_clone_impl(url, dir, function (err) {
      cb(err);
    });
  });
}

function git_clone_impl(url, dir, cb) {
  var cmd = 'git clone ' + url + ' ' + dir;

  console.log('> ' + cmd);
  exec(cmd, function (err, stdout, stderr) {
    if (stdout) { process.stdout.write(stdout); }
    if (stderr) { process.stdout.write(stderr); }

    cb(err);
  });
}

module.exports = {
  git_clone: git_clone,
  git_clone_force: git_clone_force
};
