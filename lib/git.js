'use strict';

var fs = require('fs');
var path = require('path');
var exec = require('child_process').exec;

var async = require('./simple/async');
var git_clone = require('./cmd/git').git_clone;
var mkdir_p = require('./cmd/mkdir').mkdir_p;

var repos = require('../conf/repo.json');

function install(src, dest, options, cb) {
  var dirs = Object.keys(repos);
  async.each(dirs, function (dir, done) {
    var url = repos[dir];
    var dir = path.join(dest, dir);
    var parent_dir = path.resolve(dir, '..');

    mkdir_p(parent_dir, function (err) {
      if (err) { return done(err); }
      git_clone(url, dir, done);
    });
  }, cb);
}

module.exports = install;
