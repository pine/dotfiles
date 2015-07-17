'use strict';

exports.getOptions = function () {
  var deps = false;

  for (var i = 0; i < process.argv.length; ++i) {
    switch (process.argv[i]){
      case '--deps':
        deps = true;
        break;
    }
  }

  return {
    deps: deps
  };
};

// vim: se et ts=2 sw=2 sts=2 ft=javascript :
