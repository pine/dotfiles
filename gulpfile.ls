require! {
  gulp
  'gulp-util': gutil
  'run-sequence'
  'yamljs': YAML
  './lib/private': {private-path,private-require}
}

is-darwin = /darwin/i.test process.platform
is-ubuntu = process.env.IS_UBUNTU == '1'


# ---------------------------------------------------------
# anyenv
# ---------------------------------------------------------

gulp.task \anyenv, (cb)->
  run-sequence(\pre-anyenv \anyenv-impl, cb)

gulp.task \pre-anyenv, (cb) ->
  YAML.load './config/pre-anyenv.yaml' (config) ->
    require('./tasks/pre-anyenv')(config, cb)

gulp.task \anyenv-impl, (cb) ->
  YAML.load './config/anyenv.yaml' (config) ->
    require('./tasks/anyenv')(config, cb)


# ---------------------------------------------------------
# package
# ---------------------------------------------------------

gulp.task \apt, (cb)->
  run-sequence(\pre-apt \apt-impl, cb)

gulp.task \pre-apt, (cb) ->
  YAML.load './config/pre-apt.yaml' (config) ->
    require('./tasks/pre-apt')(config, cb)

gulp.task \apt-impl, (cb) ->
  YAML.load './config/apt.yaml' (config) ->
    require('./tasks/apt')(config, cb)

# ---------------------------------------------------------

gulp.task \brew (cb)->
  run-sequence(\pre-brew, \brew-impl, \post-brew, cb)

gulp.task \pre-brew, (cb) ->
  YAML.load './config/pre-brew.yaml' (config) ->
    require('./tasks/pre-brew')(config, cb)

gulp.task \brew-impl, (cb) ->
  YAML.load './config/brew.yaml' (config) ->
    require('./tasks/brew')(config, cb)

gulp.task \post-brew, (cb) ->
  YAML.load './config/post-brew.yaml' (config) ->
    require('./tasks/post-brew')(config, cb)

# ---------------------------------------------------------

do ->
  tasks = []
  tasks.push \apt  if is-ubuntu
  tasks.push \brew if is-darwin
  gulp.task \package tasks


# ---------------------------------------------------------
# home
# ---------------------------------------------------------

gulp.task \pre-home, (cb) ->
  YAML.load './config/pre-home.yaml' (config) ->
    require('./tasks/pre-home')(config, cb)

gulp.task \home, [\pre-home], (cb) ->
  YAML.load './config/home.yaml' (config) ->
    require('./tasks/home')(config, cb)


# ---------------------------------------------------------
# script
# ---------------------------------------------------------

gulp.task \pre-script, (cb) ->
  YAML.load './config/pre-script.yaml' (config) ->
    require('./tasks/pre-script')(config, cb)

gulp.task \script, [\pre-script], (cb) ->
  YAML.load './config/script.yaml' (config) ->
    require('./tasks/script')(config, cb)


# ---------------------------------------------------------
# ssh
# ---------------------------------------------------------

gulp.task \ssh, (cb) ->
  run-sequence(\pre-ssh, \ssh-impl, \post-ssh, cb)

gulp.task \pre-ssh, (cb) ->
  YAML.load "#{private-path}/config/pre-ssh.yaml" (config) ->
    (private-require('tasks/pre-ssh') ? -> cb())(config, cb)

gulp.task \ssh-impl, (cb) ->
  YAML.load "#{private-path}/config/ssh.yaml" (config) ->
    (private-require('tasks/ssh-impl') ? -> cb())(config, cb)

gulp.task \post-ssh, private-require('tasks/post-ssh') ? []


# ---------------------------------------------------------
# entry point
# ---------------------------------------------------------

gulp.task \test, []

gulp.task \default (cb)->
  run-sequence(
    \ssh
    \package
    \home
    \anyenv
    \script
    cb
  )
