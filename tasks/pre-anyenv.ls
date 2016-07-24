require! {
  child_process: {exec}
  path
  'user-home'
  '../lib/git': {git-clone}
}


init-anyenv = (cb) ->
  cmd = 'anyenv init -'
  console.log "> #{cmd}"
  child = exec cmd, cb
  child.stderr.on 'data', (data) -> process.stderr.write(data)


module.exports = (config, cb) ->
  root-dir = path.join(user-home, '.anyenv')
  bin-dir  = path.join(root-dir, 'bin')
  git-clone config.repository-url, root-dir, (err) ->
    process.env.PATH = "#{bin-dir}:" + process.env.PATH
    if err then cb(err) else init-anyenv(cb)
