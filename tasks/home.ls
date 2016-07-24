require! {
  async
  fs
  path
  'user-home'
}


link-file = (src, dest, file, cb) ->
  src-full  = path.join(src, file)
  dest-full = path.join(dest, file)
  console.log "> ln -s #{src-full} #{dest-full}"
  fs.unlink dest-full, ->
    fs.symlink src-full, dest-full, cb


link-files = (src, dest, files, cb) ->
  async.each files, (file, cb) ->
    fs.lstat path.join(src, file), (err, stats) ->
      if err then cb(err) else link-file(src, dest, file, cb)
  , cb


module.exports = (config, cb) ->
  src = path.join(__dirname, '../resources/home')
  link-files src, user-home, config.files, cb
