require! {
  child_process: {exec}
  async
}


clean-brew = (cb) ->
  cmd = 'brew cleanup -s'
  console.log "> #{cmd}"
  child = exec "#{cmd} || #{cmd}", cb
  child.stdout.on 'data', (data) -> process.stdout.write(data)
  child.stderr.on 'data', (data) -> process.stderr.write(data)


module.exports = (config, cb) ->
  if config.clean then clean-brew(cb) else cb()
