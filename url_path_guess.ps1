Param(
  [String]$url,
  [String]$path,
  [int16]$timeout = 1
)

if ([string]::IsNullOrEmpty($url)) {
  Write-Host "URL not define. (Ex: -url http://127.0.0.1/#PATH_G#)"
  exit
}

if ([string]::IsNullOrEmpty($path)) {
  Write-Host "Path not define. (Ex: -path c:\admin\public\path.txt)"
  exit
}

if(![System.IO.File]::Exists($path)){
  Write-Host "Path ($path) not Exist!"
  exit
}

$paths = Get-Content $path

try{
  foreach($path in $paths) {
    try{
      $req = Invoke-WebRequest -Uri $url.replace("#PATH_G#", $path) -TimeoutSec $timeout
      $req.AllowAutoRedirect = $false
    } catch {
      $code = $_.Exception.Response.StatusCode.value__
    }

    $code = $req.StatusCode
    $body = $req.Content

    if(@(200, 403).Contains($code)) {
      "URL`t:`t$($url.replace("#PATH_G#", $path))`nCode`t:`t$code`nBody`t:`t$($body)`n================================================"| Out-File -FilePath $PSScriptRoot\found.txt -Append
    }
  }

} catch {
  $_ | Out-File -FilePath $PSScriptRoot\error_ups.txt -Append
}