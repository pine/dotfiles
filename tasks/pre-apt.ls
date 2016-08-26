require! {
  child_process: {exec}
  async
  '../lib/apt'
}


exec-apt = (sub, cb) ->
  cmd = "sudo apt-get #{sub} -y --force-yes"
  console.log "> #{cmd}"
  child = exec cmd, cb
  child.stdout.on 'data', (data) -> process.stdout.write(data)
  child.stderr.on 'data', (data) -> process.stderr.write(data)


update-apt-if-required = (required, cb) -->
  if required then exec-apt('update', cb) else cb()


upgrade-apt-if-required = (required, cb) -->
  if required then exec-apt('upgrade', cb) else cb()


module.exports = (config, cb) ->
  async.series [
    (cb) -> apt.install-pkgs(config.packages, cb)
    update-apt-if-required(config.update)
    upgrade-apt-if-required(config.update)
  ], cb
