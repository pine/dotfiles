require! {
  async
  mkdirp
  path
  'user-home'
}


mkdirp-dirs = (dest, dirs, cb) ->
  async.each dirs, (dir, cb) ->
    dir-full = path.join(dest, dir)
    console.log "> mkdir -p #{dir-full}"
    mkdirp dir-full, cb
  , cb


module.exports = (config, cb) ->
  mkdirp-dirs user-home, config.mkdirp, cb
