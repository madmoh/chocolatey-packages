$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64        = 'https://international.download.nvidia.com/Windows/broadcast/1.1.0.21/nvidia-broadcast-v1.1.0.21.exe'
$checksum     = '4BFD31CC732D90FCE78D11937D1572B0EACFACCF2FBA755DA7D74EB0BD841515'
$checksumType = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url64bit      = $url64
  checksum64    = $checksum
  checksumType64= $checksumType
  softwareName  = 'NVIDIA Broadcast*'
  silentArgs   = '-s'
}

$WindowsVersionMajor = [Environment]::OSVersion.Version.Major
if ($WindowsVersionMajor -ne "10") {
  Write-Error "NVIDIA Broadcast requires Windows 10."
}

$WindowsArchitecture = [Environment]::Is64BitOperatingSystem
if ($WindowsArchitecture -ne $true) {
  Write-Error "NVIDIA Broadcast requires a 64-bit Windows architecture."
}

Install-ChocolateyPackage @packageArgs

Get-Process -Name "*NVIDIA Broadcast*" | Stop-Process