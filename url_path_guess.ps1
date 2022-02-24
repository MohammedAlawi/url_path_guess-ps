Param(
  [String]$url,
  [String]$path,
  [int16]$timeout = 1
)

if ([string]::IsNullOrEmpty($url)) {
  Write-Error "URL not define. (Ex: -url http://127.0.0.1/#PATH_G#)"
  exit
}

if ([string]::IsNullOrEmpty($path)) {
  Write-Error "Path not define. (Ex: -path c:\admin\public\path.txt)"
  exit
}

if(![System.IO.File]::Exists($path)){
  Write-Error "Path ($path) not Exist!"
  exit
}

$paths = Get-Content $path

foreach($path in $paths) {
  try{
    $req = Invoke-WebRequest -Uri $url.replace("#PATH_G#", $path) -UseBasicParsing -TimeoutSec $timeout
    $code = $req.StatusCode
    $body = $req.Content
  } catch {
    $code = $_.Exception.Response.StatusCode.value__
  }
  if(@(200, 403).Contains($code)) {
    "URL`t:`t$($url.replace("#PATH_G#", $path))`nBody`t:`t$($body)`n================================================"| Out-File -FilePath $PSScriptRoot\found.txt -Append
  }
}
