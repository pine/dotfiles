require! {
  child_process: {exec}
  'prelude-ls': {compact,find,split}
  async
}


cask-cmd = (is-cask) ->
  if is-cask then 'cask ' else ''


pkg-list = (is-cask, cb) ->
  cmd = "brew #{cask-cmd(is-cask)}list"
  console.log "> #{cmd}"
  exec cmd, (err, stdout, stderr) ->
    pkgs = split /\n/ stdout |> compact
    cb(err, pkgs)


install-pkg = (is-cask, pkg, cb) ->
  cmd = "brew #{cask-cmd(is-cask)}install #{pkg}"
  console.log "> #{cmd}"
  child = exec cmd, cb
  child.stdout.on 'data', (data) -> process.stdout.write(data)
  child.stderr.on 'data', (data) -> process.stderr.write(data)


install-pkgs = (is-cask, pkgs, cb) -->
  pkg-list is-cask, (err, installed-pkgs) ->
    return cb(err) if err
    async.each-series pkgs, (pkg, cb) ->
      return cb() if find (== pkg), installed-pkgs
      install-pkg(is-cask, pkg, cb)
    , cb


module.exports = (config, cb) ->
  async.series [
    install-pkgs no, config.packages
    install-pkgs yes, config.cask-packages
  ], cb

