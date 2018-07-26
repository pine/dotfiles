require! {
  async
  child_process: {exec}
  'prelude-ls': {compact,find,split}
}


exec-brew = (sub-cmd, cb) -->
  cmd = "brew #{sub-cmd}"
  console.log "> #{cmd}"
  child = exec "#{cmd} || #{cmd}", cb
  child.stdout.on 'data', (data) -> process.stdout.write(data)
  child.stderr.on 'data', (data) -> process.stderr.write(data)


tap-list = (cb) ->
  cmd = 'brew tap'
  console.log "> #{cmd}"
  exec cmd, (err, stdout, stderr) ->
    pkgs = split /\n/ stdout |> compact
    cb(err, pkgs)


install-taps = (taps, cb) -->
  tap-list (err, tapped-taps) ->
    return cb(err) if err
    async.each taps, (tap, cb) ->
      if find (== tap), tapped-taps then cb() else install-tap(tap, cb)
    , cb


install-tap = (tap, cb) ->
  exec-brew("tap #{tap}", cb)


module.exports = (config, cb) ->
  async.series [
    if config.update  then exec-brew('update')  else ->
    install-taps(config.taps)
    exec-brew('tap --repair')
    if config.update  then exec-brew('update')  else ->
    if config.upgrade then exec-brew('upgrade') else ->
  ], cb
