require! {
  child_process: {exec}
  async
}


exec-apt = (sub, cb) ->
  cmd = "sudo apt-get #{sub} -y --force-yes"
  console.log "> #{cmd}"
  child = exec cmd, cb
  child.stdout.on 'data', (data) -> process.stdout.write(data)
  child.stderr.on 'data', (data) -> process.stderr.write(data)


module.exports = (config, cb) ->
  async.series [
    (cb) -> if config.update  then exec-apt('update', cb)  else cb()
    (cb) -> if config.upgrade then exec-apt('upgrade', cb) else cb()
  ], cb
