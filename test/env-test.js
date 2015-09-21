'use strict';

/*jshint node: true */
/*globals describe, it */

var _ = require('lodash');
var chai = require('chai');
var sinon = require('sinon');

var env = require('../lib/env');
var wrap = require('../lib/simple/wrapple');

var expect = chai.expect;

describe('Infra Unit test for env', function () {
  var sandbox;

  beforeEach(function () {
    sandbox = sinon.sandbox.create();
  });

  afterEach(function () {
    sandbox.restore();
  });

  describe('getWorkingDirectory()', function () {
    it('should return working directory', function () {
      expect(env.getWorkingDirectory()).to.equal(process.cwd());
    });
  });

  describe('getOS()', function () {
    it('should return windows', function () {
      sandbox.stub(wrap, 'process', function () { return { platform: 'win32' }; });
      expect(env.getOS()).to.equal('windows');
    });

    it('should return mac', function () {
      sandbox.stub(wrap, 'process', function () { return { platform: 'darwin' }; });
      expect(env.getOS()).to.equal('darwin');
    });

    it('should return linux', function () {
      sandbox.stub(wrap, 'process', function () { return { platform: 'linux' }; });
      expect(env.getOS()).to.equal('linux');
    });
  });

  describe('getUserHome()', function () {
    it('should return windows home path', function () {
      sandbox.stub(wrap, 'process', function () {
        return {
          platform: 'win32',
          env: _.extend(process.env, {
            USERPROFILE: 'home_directory'
          })
        };
      });
      expect(env.getUserHome()).to.equal('home_directory');
    });

    it('should return linux home path', function () {
      sandbox.stub(wrap, 'process', function () {
        return {
          platform: 'linux',
          env: _.extend(process.env, {
            HOME: 'home_directory'
          })
        };
      });
      expect(env.getUserHome()).to.equal('home_directory');
    });
  });

  describe('getOptions()', function () {
    it('should return an os option', function () {
      expect(env.getOptions()).to.have.property('os').that.equal(env.getOS())
    });
  });
});
