require! {
  fs
  path
}


private-path =
  path.join(__dirname, '../../dotfiles.private')


private-require = (file) ->
  file-full = try require.resolve(path.join(private-path, file))
  try
    fs.accessSync file-full
  catch
    return
  require(file-full)


module.exports =
  private-path: private-path
  private-require: private-require
