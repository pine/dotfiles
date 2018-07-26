require! {
  child_process: {exec}
  fs
  path
  rimraf
}


git-clone = (url, dir, cb) ->
  fs.lstat path.join(dir, '.git'), (err, stat) ->
    return cb() if !err and stat.is-directory!
    return git-clone-impl(url, dir, cb) if err
    git-clone-force(url, dir, cb)


git-clone-force = (url, dir, cb) ->
  rimraf dir, (err) ->
    return cb(err) if err
    git-clone-impl(url, dir, cb)


git-clone-impl = (url, dir, cb) ->
  cmd = "git clone #{url} #{dir}"
  console.log "> #{cmd}"
  child = exec cmd, cb
  child.stdout.on 'data', (data) -> process.stdout.write(data)
  child.stderr.on 'data', (data) -> process.stderr.write(data)


module.exports =
  git-clone: git-clone
  git-clone-force: git-clone-force
