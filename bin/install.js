'use strict';

var env = require('../lib/env');
var runas = require('../lib/runas');

var symlink = require('../lib/symlink');
var neobundle = require('../lib/neobundle');

!function() {
  var cwd = env.getWorkingDirectory();
  var home = env.getUserHome();
  var os = env.getOS();
  var options = env.getOptions();

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
  
  symlink(cwd, home, options, function () {
    neobundle(cwd, home, options, function () {
      console.log('\nPress any key wait ...');
      runas.pressAnyKeyWait();
    });
  });
}();

// vim: se et ts=2 sw=2 sts=2 ft=javascript :
