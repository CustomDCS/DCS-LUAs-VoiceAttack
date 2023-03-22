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
  $path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\DCS World OpenBeta_is1'
  if (!(Test-Path -Path $path)) {
    # for some reason, even though he's on the beta, Zebra's path is different, might have to handle more weird cases?  
    # Hopefully the folder selection dialog should help here
    $path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\DCS World_is1'
  }
  
  if(Test-Path -Path $installPath)
  {
    $installPath = (Get-ItemProperty -Path $path -Name InstallLocation).InstallLocation
  }
  else {
    Write-Host "Where is your DCS install path?"
    $installPath = Get-Folder
    Write-Host "If this keeps happening, please reach out to FlamerNZ..."
  }
  
  return $installPath
}

function Get-BackupPath ($path, [int] $i = 0) {
  if(Test-Path $path)
  {
    #increment by 1
    $origPath = $path
    $path = $path + "_" + $i
    if(Test-Path $path)
    {
      $i++
      $path = Get-BackupPath $origPath $i
    }
  }
  return $path
}


$installPath = Get-DCSInstallPath
Write-Host "Current DCS install path: " $installPath

$macroSequenciesPath = $installPath + "\" + ([string]::Format($macroSequenciesRelPath,$Mi8MTV2))
Write-Host "Checking that we can find your autostart file..." -NoNewline
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
else {
  Write-Host "success!"
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