'use strict';

function each(items, func, done) {
  var runs = 0;
  var err;

  for (var i = 0; i < items.length; ++i) {
   func(items[i], function(err_) {
     err = err || err_;
     if (++runs === items.length) { done(err); }
   });
  }
}

function eachSeries(items, func, done) {
  if (items.length == 0) { return done(); }

  var first = items.pop();
  func(first, function (err) {
    if (err) { return done(err); }
    eachSeries(items, func, done);
  });
}

function parallel(funcs, done) {
  var runs = 0;
  var err;

  for (var i = 0; i < funcs.length; ++i) {
   funcs[i](function(err_) {
     err = err || err_;
     if (++runs === funcs.length) { done(err); }
   });
  }
}

module.exports = {
  each: each,
  eachSeries: eachSeries,
  parallel: parallel
};
