require! {
  async
  'fs-extra': fs
  'fs-symlink': link
  path
  'prelude-ls': {}
  'user-home'
}


link-file = (src, dest, file, cb) ->
  src-full  = path.join(src, file)
  dest-full = path.join(dest, file)
  console.log "> ln -s #{src-full} #{dest-full}"
  link(src-full, dest-full).then(cb, cb)


link-files = (src, dest, files, cb) ->
  async.each files, (file, cb) ->
    fs.lstat path.join(src, file), (err, stats) ->
      if err then cb(err) else link-file(src, dest, file, cb)
  , cb


module.exports = (config, cb) ->
  src  = path.join(__dirname, '../resources/home')
  dest = user-home
  link-files src, dest, config.files, cb
