require! {
  child_process: {exec}
  async
}


exec-brew = (sub, cb) ->
  cmd = "brew #{sub}"
  console.log "> #{cmd}"
  child = exec "#{cmd} || #{cmd}", cb
  child.stdout.on 'data', (data) -> process.stdout.write(data)
  child.stderr.on 'data', (data) -> process.stderr.write(data)


module.exports = (config, cb) ->
  async.series [
    (cb) -> if config.update  then exec-brew('update', cb)  else cb()
    (cb) -> if config.upgrade then exec-brew('upgrade', cb) else cb()
  ], cb
