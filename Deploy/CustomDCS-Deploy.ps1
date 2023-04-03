



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
  
  if(Test-Path -Path $path)
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

function AutoStartSelection ($airframes, $installPath) {
  [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
  [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
  
  $macroSequenciesRelPath = "Mods\aircraft\{0}\Cockpit\Scripts\Macro_sequencies.lua"

  # Set the size of your form
  $Form = New-Object System.Windows.Forms.Form
  #$Form.width = 500
  #$Form.height = (200 + (50 * ($airframes.Count - 1)))  # should expand this depending on how many lines we need, based on number of items in $aircraft list
  $Form.width = 360
  $Form.height = 310
  $Form.Text = "Choose your Auto-Starts below"

  # Set the font of the text to be used within the form
  $Font = New-Object System.Drawing.Font("Arial",10)
  $Form.Font = $Font

  #$aircraft = $airframes[0]
  #$checkboxes = @()
  
  $checkedlistbox=New-Object System.Windows.Forms.CheckedListBox
  $checkedlistbox.Location = '10,10'
  $checkedlistbox.Size = '320,200'

  $Form.Controls.Add($checkedlistbox)
  $checkedListBox.DataSource = [collections.arraylist]$airframes

  $checkedListBox.DisplayMember = 'Name'
  $checkedlistbox.CheckOnClick = $true
  $checkedlistbox.Add_ItemCheck({

    param($sender,$e)
    Write-Host $e.CurrentValue
    if($e.CurrentValue -eq "unchecked") # Changed to unchecked
    {
      Write-Host ([string]::Format($macroSequenciesRelPath, $airframes[$e.Index]))

      Write-Host "Taking a backup of your current auto start..."
      $installPath = Get-DCSInstallPath
      $relPath = ([string]::Format($macroSequenciesRelPath,$airframes[$e.Index])) # $aircraft
      #Write-Host $installPath
      $destPath = ($installPath + $relPath)
      #Write-Host $destPath
      $backupPath = $destPath + "." + (get-date -Format "yy-MM-dd") + ".bak"
      $backupPath = Get-BackupPath $backupPath
      #Write-Host $macroSequenciesPath
      Rename-Item $destPath -NewName $backupPath
      Write-Host "Backup saved to: " $backupPath

      Write-Host "Deploying new auto start..." -NoNewline

      Copy-Item $relPath -Destination $destPath

      Write-Host "success!"
      Write-Host "Happy fast start-up!  (You can now close the dialog)"

    } else {
     Write-Host "Not implemented yet, sorry!"
    }
  })

  # foreach($aircraft in $airframes)
  # {
  #     # create your checkbox 
  #     $checkbox1 = new-object System.Windows.Forms.checkbox
  #     $checkbox1.Location = new-object System.Drawing.Size(30,30)
  #     $checkbox1.Size = new-object System.Drawing.Size(250,50)
  #     $checkbox1.Text = $aircraft  # this should come from the names of aircraft
  #     $checkbox1.Checked = $false

  #     $checkbox1.Add_CheckStateChanged({

  #     })
  #     #$Form.Controls.Add($checkbox1) #remove this

  #     $checkboxes += $checkbox1   
  # }

  # foreach($checkbox in $checkboxes)
  # {
  #   $Form.Controls.Add($checkbox)
  # }

  # Add a close button
   $OKButton = new-object System.Windows.Forms.Button
   $OKButton.Location = new-object System.Drawing.Size(130,210)
   $OKButton.Size = new-object System.Drawing.Size(80,30)
   $OKButton.Text = "Close"
   $OKButton.Add_Click({$Form.Close()})
   $form.Controls.Add($OKButton)
  
  # Activate the form
  $Form.Add_Shown({$Form.Activate()})
  [void] $Form.ShowDialog() 
}

$installPath = Get-DCSInstallPath
Write-Host "Current DCS install path: " $installPath

Write-Host "Checking that we can find your install folder..." -NoNewline
if(!(Test-Path $installPath))
{
  Write-Error -Message "Folder doesn't seem to be at this path: $installPath" -ErrorAction Continue
  $response = Read-Host -Prompt "Would you like to select your DCS install folder manually? (Y/N)"
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

# $checkedlistbox_ItemCheck = [System.Windows.Forms.ItemCheckEventHandler]{
# #Event Argument: $_ = [System.Windows.Forms.ItemCheckEventArgs]
#   if($checkedlistbox.Items[$_.Index] -eq 'MyValue'){
#     if ($_.NewValue -eq 'Checked'){
#       $button.Enabled = $true
#     }else{
#       $button.Enabled = $false
#     }
#   }
# }

# get list of airframes
$airframes = (Get-ChildItem -Path "Mods\aircraft" -Directory).Name
#$airframes = @("Mi-8MTV2")
Write-Host $airframes
AutoStartSelection -airframes $airframes #, $installPath