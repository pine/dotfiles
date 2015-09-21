'use strict';

var names = [];

function wrap(name) {
  if (names.indexOf(name) < 0) {
    names.push(name);
    wrap[name] = function () {
      return global[names];
    };
  }

  return wrap[name]();
}

wrap.clear = function () {
  names.length = 0;
};

module.exports = wrap;
