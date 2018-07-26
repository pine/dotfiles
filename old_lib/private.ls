require! {
  fs
  path
}


private-path = do ->
  name = process.env.PRIVATE_REPOSITORY
  path.join(__dirname, "../../#{name}")


private-require = (file) ->
  file-full     = path.join(private-path, file)
  resolved-full = try require.resolve(file-full)
  try
    fs.access-sync resolved-full
  catch
    return
  require(resolved-full)


module.exports =
  private-path: private-path
  private-require: private-require
