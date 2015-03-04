'use strict';

var env = require('../lib/env');

var cwd = env.getWorkingDirectory();
var home = env.getUserHome();
var options = env.getOptions();

require('../lib/symlink')(cwd, home, options);

// vim: se et ts=2 sw=2 sts=2 ft=javascript :
