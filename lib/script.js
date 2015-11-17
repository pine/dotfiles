'use strict';

var fs = require('fs');
var path = require('path');
var spawn = require('child_process').spawn;

var async = require('./simple/async');
var files = require('../conf/script.json');

var exts = {
  'darwin': ['bash'],
  'linux': ['bash']
};

function install(src, dest, options, cb) {
  var os = options.os;
  var length = 0;

  async.each(files[os], function (name, done) {
    async.each(exts[os], function (ext, done) {
      var file = path.join(src, 'script', name + '.' + ext);
      fs.stat(file, function (err, stat) {
        if (!stat.isFile()) { return done(); }

        ++length;
        execScript(file, ext, options, done);
      });
    }, done);
  }, function (err) {
    if (err) { return cb(err); }
    console.log('Executed ' + length + ' script' + (length > 1 ? 's' : ''));
    cb();
  });
}

function execScript(file, ext, options, cb) {
  switch (ext) {
    case 'bash':
      console.log('> bash ' + file);
      var bash = spawn('bash', [ file ], { stdio: 'inherit' });
      bash.on('close', cb);
      break;

    default:
      cb('Not supported extension `' + ext + '`');
  }
}

module.exports = install;
