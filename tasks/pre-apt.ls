require! {
  async
  child_process: {exec}
  glob
  path
  'prelude-ls': {each,map,or-list}
  '../lib/apt'
}


exec-apt = (sub, cb) ->
  cmd = "sudo apt-get #{sub} -y --force-yes -qq"
  console.log "> #{cmd}"
  child = exec cmd, cb
  child.stdout.on 'data', (data) -> process.stdout.write(data)
  child.stderr.on 'data', (data) -> process.stderr.write(data)


exec-add-apt-repository = (repository, cb) ->
  cmd = "sudo add-apt-repository #{repository} --yes"
  console.log "> #{cmd}"
  child = exec cmd, cb
  child.stdout.on 'data', (data) -> process.stdout.write(data)
  child.stderr.on 'data', (data) -> process.stderr.write(data)


update-apt-if-required = (required, cb) -->
  if required then exec-apt('update', cb) else cb()


upgrade-apt-if-required = (required, cb) -->
  if required then exec-apt('upgrade', cb) else cb()


is-repository-added = (repository, cb) ->
  regexp = new RegExp(repository.match)
  glob '/etc/apt/sources.list.d/*.list', (err, paths) ->
    return cb(err) if err
    paths
      |> map -> path.basename(it, '.list')
      |> map -> regexp.test(it)
      |> or-list
      |> -> cb(null, it)

add-repository = (repository, cb) ->
  is-repository-added repository, (err, is-added) ->
    return cb(err) if err or is-added
    exec-add-apt-repository(repository.name, cb)


add-repositories = (repositories, cb) -->
  async.each-series repositories, add-repository, cb


module.exports = (config, cb) ->
  async.series [
    update-apt-if-required(yes)
    (cb) -> apt.install-pkgs(config.packages, cb)
    add-repositories(config.repositories)
    update-apt-if-required(config.update)
    upgrade-apt-if-required(config.update)
  ], cb
