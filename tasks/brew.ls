require! {
  child_process: {exec}
  'prelude-ls': {compact,find,split}
  async
}


pkg-list = (cb) ->
  cmd = "brew list"
  console.log "> #{cmd}"
  exec cmd, (err, stdout, stderr) ->
    pkgs = split /\n/ stdout |> compact
    cb(err, pkgs)


install-pkg = (pkg, cb) ->
  cmd = "brew install #{pkg}"
  console.log "> #{cmd}"
  child = exec cmd, cb
  child.stdout.on 'data', (data) -> process.stdout.write(data)
  child.stderr.on 'data', (data) -> process.stderr.write(data)


module.exports = (config, cb) ->
  pkg-list (err, pkgs) ->
    return cb(err) if err
    async.each-series config.packages, (pkg, cb) ->
      if find (== pkg), pkgs then cb() else install-pkg(pkg, cb)
    , cb

