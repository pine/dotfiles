'use strict';

var fs = require('fs');
var path = require('path');
var exec = require('child_process').exec;

var repo = 'https://github.com/Shougo/neobundle.vim.git';

function git_clone(url, dir, cb) {
  var cmd = 'git clone ' + url + ' ' + dir;
  
  console.log('> ' + cmd);
  exec(cmd, function (err, stdout, stderr) {
    if (stdout) { process.stdout.write(stdout); }
    if (stderr) { process.stdout.write(stderr); }
    
    cb(err);
  });
}

function rm_rf(dir, cb) {
  var cmd = 'rm -rf ' + dir;
  
  console.log('> ' + cmd);
  exec(cmd, function (err, stdout, stderr) {
    cb(err);
  });
}

function install(src, dest, options) {
  var clone_dir = path.join(dest, '.vim/bundle/neobundle.vim');
  
  fs.stat(path.join(clone_dir, '.git'), function (err, stat) {
    if (!err && stat.isDirectory()) { return; }
    
    rm_rf(path.join(dest, '.vim'), function (err) {
      if (err) { return console.error(err); }
      
      git_clone(repo, clone_dir, function (err) {
        if (err) { return console.error(err); }
      });
    });
  });
}

module.exports = install;

// vim: se et ts=2 sw=2 sts=2 ft=javascript :
