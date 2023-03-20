## Script to backup the current Mi8 auto start script and replace with our custom one from the current repo
$ErrorActionPreference = "Stop" # this is a debug setting, will stop on any error so that we can figure out what went wrong
$macroSequenciesRelPath = "Mods\aircraft\{0}\Cockpit\Scripts\Macro_sequencies.lua"
$Mi8MTV2 = "Mi-8MTV2"

Write-Host "`n** Custom DCS deployment script **`n"

function Get-Folder()
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "DCS Install Location (not Saved Games folder)"
    $foldername.rootfolder = "MyComputer"

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}

function Get-DCSInstallPath {
  # Check that we know where the ED install location is:
  ##$installPath = $env:DCS_INSTALL_PATH # the environment variables don't seem to persist, so let's use the registry instead
  $installPath = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\DCS World OpenBeta_is1' -Name InstallLocation).InstallLocation
  if(!$installPath)
  {
    Write-Host "Where is your DCS install path?"
    $installPath = Get-Folder
    Write-Host "If this keeps happening, please reach out to FlamerNZ..."
  }
  return $installPath
}

function Get-BackupPath ($path, $i = 0) {
  if(Test-Path $path)
  {
    #increment by 1
    $path = $path + "_" + $i
    if(Test-Path $path)
    {
      $path = Get-BackupPath $path $i++
    }
  }
  return $path
}


$installPath = Get-DCSInstallPath
Write-Host "Current DCS install path: " $installPath

$macroSequenciesPath = $installPath + "\" + ([string]::Format($macroSequenciesRelPath,$Mi8MTV2))
Write-Host "Checking that we can find your autostart file..."
if(!(Test-Path $macroSequenciesPath))
{
  Write-Error -Message "File doesn't seem to be at this path: $macroSequenciesPath"
  $response = Read-Host -Prompt "Would you like to select your DCS install path manually? (Y/N)"
  if($response -eq "Y")
  {
    $installPath = Get-DCSInstallPath
  } else {
    Write-Host "Installer Exiting"
    exit 1
  }
}
Write-Host "Taking a backup of your current auto start..."
$backupPath = $macroSequenciesPath + "." + (get-date -Format "yy-MM-dd") + ".bak"
$backupPath = Get-BackupPath $backupPath
#Write-Host $macroSequenciesPath
Rename-Item $macroSequenciesPath -NewName $backupPath
Write-Host "Backup saved to: " $backupPath

Write-Host "Deploying new auto start..."
Copy-Item "Startup\Mi-8\Macro_sequencies.lua" -Destination $macroSequenciesPath

Write-Host "Auto Start Script updated from current branch.  Enjoy!"