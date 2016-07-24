require! {
  child_process: {exec}
  async
}


install-env = (env, cb) ->
  cmd = "anyenv install -s #{env}"
  console.log "> #{cmd}"
  child = exec cmd, cb
  child.stdout.on 'data', (data) -> process.stdout.write(data)
  child.stderr.on 'data', (data) -> process.stderr.write(data)


module.exports = (config, cb) ->
  async.each config.envs, install-env, cb
