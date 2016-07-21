require! {
  child_process: {exec}
  async
}


install-pkg = (pkg, cb) ->
  cmd = "sudo apt-get install #{pkg} -y -qq"
  console.log "> #{cmd}"
  child = exec "#{cmd} || true", cb
  child.stdout.on 'data', (data) -> process.stdout.write(data)
  child.stderr.on 'data', (data) -> process.stderr.write(data)


module.exports = (config, cb) ->
  async.each-series config.packages, (pkg, cb) ->
    install-pkg(pkg, cb)
  , cb

