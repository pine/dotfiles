'use strict';

var exec = require('child_process').exec;

function toArgumentList(args) {
  return args.map(function (arg) {
    return '\\"' + arg + '\\"';
  }).join(',');
}

exports.isRunas = function() {
  return process.argv.length > 2;
};

exports.run = function (src, dest) {
  var nodeCmd = '\\"' + process.argv[0] + '\\"' +
    ' ' + toArgumentList([process.argv[1], src, dest]);
  var psCmd = 'Start-Process ' + nodeCmd + ' -Verb runas';
  var cmd = 'powershell -NoProfile -ExecutionPolicy unrestricted -Command "' + psCmd + '"';
  
  exec(cmd, function (err, stdout, stderr) {
    if (err) { console.error(err); }
  });
};

exports.pressAnyKeyWait = function() {
  process.stdin.setRawMode(true);
  process.stdin.resume();
  process.stdin.on('data', process.exit.bind(process, 0));
};

exports.getWorkingDirectory = function() {
  return process.argv[2];
};

exports.getUserHome = function() {
  return process.argv[3];
};