$node_bin = ''

$cwd = Split-Path -Parent $MyInvocation.MyCommand.Definition

if ($node_cmd = Get-Command 'node' -ErrorAction SilentlyContinue) {
  $node_bin = $node_cmd.Definition
}

if ($node_bin -eq '') {
  Write "Can't find Node.js (in PATH)"
  return
}

Write "> ""$node_bin"" ""$cwd\install.js"""
Start-Process "$node_bin" "$cwd\install.js" -NoNewWindow -Wait