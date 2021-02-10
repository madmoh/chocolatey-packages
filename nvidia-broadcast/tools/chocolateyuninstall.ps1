$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'NVIDIA Broadcast*'
  fileType      = 'exe'
  validExitCodes= @(0)
}

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $key | % {
    Write-Output (Get-UninstallRegistryKey $packageArgs['softwareName']).UninstallString
    $packageArgs['file'] = (Get-UninstallRegistryKey $packageArgs['softwareName']).UninstallString -replace "\s.*$"
    $packageArgs['silentArgs'] = (Get-UninstallRegistryKey $packageArgs['softwareName']).UninstallString -replace "^.*?\s" -replace "$"," -silent"
    Uninstall-ChocolateyPackage @packageArgs
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $($_.DisplayName)"}
}