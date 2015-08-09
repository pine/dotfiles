dotfiles
--------

[![wercker status](https://img.shields.io/wercker/ci/54f5f52d1afdc9f97c000564.svg?style=flat-square)](https://app.wercker.com/project/bykey/0f3a3fac65929edc8fd6e53818d5aba6)
[![Coverage Status](https://img.shields.io/coveralls/pine613/dotfiles/master.svg?style=flat-square)](https://coveralls.io/r/pine613/dotfiles)
[![Code Climate](https://img.shields.io/codeclimate/github/pine613/dotfiles.svg?style=flat-square)](https://codeclimate.com/github/pine613/dotfiles)
[![devDependency Status](https://img.shields.io/david/dev/pine613/dotfiles.svg?style=flat-square)](https://david-dm.org/pine613/dotfiles#info=devDependencies)

## Getting started
First, you must clone the repository in your development computer.

```sh
$ git clone https://github.com/pine613/dotfiles.git
```

### Linux

```sh
$ ./bin/install.bash # install .files
$ ./bin/install.bash --deps # install anyenv, NeoBundle, etc ...
```

### Windows

```sh
$ bin\install.bat
```

## Test
You must install vim, bash, and zsh when you execute tests in *nix.

```sh
$ npm install
$ npm test
```


## License
MIT License<br />
Copyright (c) 2014-2015 Pine Mizune
