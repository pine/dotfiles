require! {
  async
  '../lib/apt'
}


module.exports = (config, cb) ->
  async.each-series config.packages, (pkg, cb) ->
    apt.is-installed pkg, (installed) ->
      if installed then cb() else apt.install-pkg(pkg, cb)
  , cb

