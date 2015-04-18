$node_bin = ''
$node_version = 'v0.10.38'
$node_arch = 'x64'
$node_sha256 = 'e82b7c6a102ae3266149b3af48ccb1d15c7438ff30a3109735148b38ed271fc1'
$node_repo = 'https://nodejs.org/dist/'


$cwd = Split-Path -Parent $MyInvocation.MyCommand.Definition

if ($node_cmd = Get-Command 'node' -ErrorAction SilentlyContinue) {
  $node_bin = $node_cmd.Definition
}

if ($node_bin -eq '') {
  Write "Can't find Node.js (in PATH)"
  
  $node_bin_url = "$node_repo/$node_version/$node_arch/node.exe"
  $node_bin = "$cwd\node.exe"
  
  
  if (-not(Test-Path "$node_bin")) {
    Write "Downloading Node.js using HTTPS"
    Write "Downloading from: $node_bin_url"
    
    Invoke-WebRequest -OutFile "$node_bin" -Uri "$node_bin_url"
    $hash = (Get-FileHash -LiteralPath "$node_bin" -Algorithm SHA256).Hash
    
    if ($node_sha256 -ne $hash) {
      Write-Error "Hash mismatch"
      return
    }
  }
}

Write "> ""$node_bin"" ""$cwd\install.js"""
Start-Process "$node_bin" "$cwd\install.js" -NoNewWindow -Wait