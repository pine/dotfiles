require! {
  child_process: {exec}
  async
}


is-installed = (pkg, cb) ->
  cmd = "dpkg -s #{pkg}"
  console.log "> #{cmd}"
  child = exec "#{cmd}", (err, stdout, stderr) ->
    process.stderr.write(stderr) if stderr
    cb(!err)


install-pkg = (pkg, cb) ->
  cmd = "sudo apt-get install #{pkg} -y -qq"
  console.log "> #{cmd}"
  child = exec "#{cmd} || true", cb
  child.stdout.on 'data', (data) -> process.stdout.write(data)
  child.stderr.on 'data', (data) -> process.stderr.write(data)


install-pkgs = (pkgs, cb) ->
  async.each-series pkgs, (pkg, cb) ->
    is-installed pkg, (installed) ->
      if installed then cb() else install-pkg(pkg, cb)
  , cb


module.exports =
  is-installed: is-installed
  install-pkg: install-pkg
  install-pkgs: install-pkgs
