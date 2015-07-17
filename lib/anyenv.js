'use strict';

var fs = require('fs');
var path = require('path');
var exec = require('child_process').exec;

var async = require('./simple/async');
var git_clone = require('./cmd/git').git_clone;

var envs = [
  'rbenv',
  'ndenv',
  'plenv',
  'pyenv',
  'goenv',
  'crenv'
];

var anyenv_repo = 'https://github.com/riywo/anyenv.git';

function install(src, dest, options, cb) {
  var anyenv_dir = path.join(dest, '.anyenv');

  git_clone(anyenv_repo, anyenv_dir, function (err) {
    if (err) { return cb(err); }

    anyenv_init(function (err) {
      if (err) { return cb(err); }

      async.each(envs, function (env, done) {
        anyenv_install(env, done);
      }, function (err) {
        cb(err);
      });
    });
  });
}

function anyenv_init(cb) {
  exec('anyenv init - ', function (err, stdout, stderr) {
    if (stdout) { console.log(stdout); }
    if (stderr) { console.error(stderr); }
    cb(err);
  });
}

function anyenv_install(name, cb) {
  console.log('> anyenv install -s ' + name);
  exec('anyenv install -s ' + name, function (err, stdout, stderr) {
    if (stdout) { console.log(stdout); }
    if (stderr) { console.error(stderr); }
    cb(err);
  });
}

module.exports = install;
