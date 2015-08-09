'use strict';

var async = require('../lib/simple/async');
var env = require('../lib/env');
var runas = require('../lib/runas');
var execArgs = require('../lib/exec_args');

var symlink = require('../lib/symlink');
var anyenv = require('../lib/anyenv');
var git = require('../lib/git');

!function() {
  var cwd = env.getWorkingDirectory();
  var home = env.getUserHome();
  var os = env.getOS();
  var options = env.getOptions();
  var args = execArgs.getOptions();

  if (os === 'windows') {
    if (runas.isRunas()) {
      cwd = runas.getWorkingDirectory();
      home = runas.getUserHome();
    } else {
      console.log('Run as administrator');
      runas.run(cwd, home);
      return;
    }
  }

  console.log('src = ' + cwd);
  console.log('dest = ' + home + '\n');

  if (os !== 'windows') {
    if (args.deps) {
      var tasks = [ anyenv, git ];

      async.each(tasks, function (task, done) {
        task(cwd, home, options, done);
      }, function (err) {
        if (err) { console.error(err); }
      });
      return;
    }
  }

  symlink(cwd, home, options, function () {
    if (runas.isRunas()) {
      console.log('\nPress any key wait ...');
      runas.pressAnyKeyWait();
    }
  });
}();

// vim: se et ts=2 sw=2 sts=2 ft=javascript :
