require! {
  async
  fs
  path
  rimraf
  'user-home'
}


link-file = (src, dest, file, cb) ->
  src-full  = path.join(src, file)
  dest-full = path.join(dest, file)
  console.log "> ln -s #{src-full} #{dest-full}"
  fs.unlink dest-full, -> # failsafe
    fs.symlink src-full, dest-full, cb


link-files = (src, dest, files, cb) -->
  async.each files, (file, cb) ->
    fs.lstat path.join(src, file), (err, stats) ->
      if err then cb(err) else link-file(src, dest, file, cb)
  , cb


link-directory = (src, dest, dir, cb) ->
  src-full  = path.join(src, dir)
  dest-full = path.join(dest, dir)
  console.log "> ln -s #{src-full} #{dest-full}"
  rimraf dest-full, (err) ->
    fs.symlink src-full, dest-full, 'dir', cb


link-directories = (src, dest, dirs, cb) -->
  async.each dirs, (dir, cb) ->
    fs.lstat path.join(src, dir), (err, stats) ->
      if !err and stats.is-directory! then link-directory(src, dest, dir, cb) else cb(err)
  , cb


module.exports = (config, cb) ->
  src = path.join(__dirname, '../resources/home')
  async.series [
    link-files src, user-home, config.files
    link-directories src, user-home, config.directories
  ], cb
