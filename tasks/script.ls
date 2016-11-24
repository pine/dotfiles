require! {
  async
  child_process: {exec}
  fs
  path
  'prelude-ls': {flatten,map}
}


script-files = (src, extensions, scripts) ->
  scripts |> map (script) ->
    extensions |> map -> "#{script}.#{it}"
  |> flatten
  |> map -> path.join(src, it)


run-scripts-if-exists = (files, cb) ->
  async.each files, (file, cb) ->
    run-script-if-exists file, cb
  , cb


run-script-if-exists = (file, cb) -->
  fs.lstat file, (err, stats) ->
    if err or !stats.is-file! then cb() else run-script(file, cb)


run-script = (file, cb) -->
  console.log "> #{file}"
  child = exec file, cb
  child.stdout.on 'data', (data) -> process.stdout.write(data)
  child.stderr.on 'data', (data) -> process.stderr.write(data)


module.exports = (config, cb) ->
  src = path.join(__dirname, '../resources/script')
  async.each-series config.scripts, (scripts, cb) ->
    files = script-files src, config.extensions, scripts
    run-scripts-if-exists files, cb
  , cb
