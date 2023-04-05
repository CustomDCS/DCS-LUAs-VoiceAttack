



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

  # Set the size of your form
  $Form = New-Object System.Windows.Forms.Form
  #$Form.width = 500
  #$Form.height = (200 + (50 * ($airframes.Count - 1)))  # should expand this depending on how many lines we need, based on number of items in $aircraft list
  $Form.width = 300
  $Form.height = 430
  $Form.Text = "CustomDCS.com"

  $label = New-Object System.Windows.Forms.Label
  $label.Location = '29,7'
  $label.Size = '280,20'
  $label.Text = 'Custom Auto Start Installer'
  $form.Controls.Add($label)

  $label1 = New-Object System.Windows.Forms.Label
  $label1.Location = '30,38'
  $label1.Size = '280,20'
  $label1.Text = 'Select One Or More'
  $form.Controls.Add($label1)



  $label2 = New-Object System.Windows.Forms.Label
  $label2.Location = '95,250'
  $label2.Size = '280,20'
  $label2.Text = '- Select All Auto Starts'
  $form.Controls.Add($label2)

  $label3 = New-Object System.Windows.Forms.Label
  $label3.Location = '95,281'
  $label3.Size = '280,20'
  $label3.Text = '- Install All Selected Auto Starts'
  $form.Controls.Add($label3)

  $label4 = New-Object System.Windows.Forms.Label
  $label4.Location = '95,331'
  $label4.Size = '280,20'
  $label4.Text = '- Uninstall All Auto Starts'
  $form.Controls.Add($label4)

  $label5 = New-Object System.Windows.Forms.Label
  $label5.Location = '95,358'
  $label5.Size = '280,20'
  $label5.Text = '- Exit The Application'
  $form.Controls.Add($label5)

  # Set the font of the text to be used within the form

  $Font = New-Object System.Drawing.Font("Arial",12)
 
  $LabelFont = New-Object System.Drawing.Font("Arial",11)
  $LabelFont1 = New-Object System.Drawing.Font("Arial",10)
  $LabelFont2 = New-Object System.Drawing.Font("Arial",9)
  $LabelFont3 = New-Object System.Drawing.Font("Arial",9)
  $LabelFont4 = New-Object System.Drawing.Font("Arial",9)
  $LabelFont5 = New-Object System.Drawing.Font("Arial",9)

  

  $Form.Font = $Font
  $Label.font = $LabelFont
  $Label1.font = $LabelFont1
  $Label2.font = $LabelFont2
  $Label3.font = $LabelFont3
  $Label4.font = $LabelFont4
  $Label5.font = $LabelFont5
  
  $checkedlistbox = New-Object System.Windows.Forms.CheckedListBox
  $checkedlistbox.Location = '30,63'
  $checkedlistbox.Size = '186,180'

  $Form.Controls.Add($checkedlistbox)
  $checkedListBox.DataSource = [collections.arraylist]$airframes

  $checkedListBox.DisplayMember = 'Name'
  $checkedlistbox.CheckOnClick = $true
  # $checkedlistbox.Add_ItemCheck({
  #   if($sender.CurrentValue -eq "Checked")
  #   {
  #     Write-Host ([string]::Format($macroSequenciesRelPath, $airframes[$e.Index]))

     

  #     $wsh = New-Object -ComObject Wscript.Shell
  #     $wsh.Popup([string]::Format("New script for {0} deployed successfully!",$airframes[$e.Index]))

  #   } else {
  #    Write-Host "Not implemented yet, sorry!"
  #   }
  # })

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
  # $OKButton = new-object System.Windows.Forms.Button
  # $OKButton.Location = new-object System.Drawing.Size(130,100)
  # $OKButton.Size = new-object System.Drawing.Size(100,40)
  # $OKButton.Text = "Close"
  # $OKButton.Add_Click({$Form.Close()})
  # $form.Controls.Add($OKButton)
  

  $SelectAllButton = New-Object System.Windows.Forms.Button
  $UninstallButton = New-Object System.Windows.Forms.Button
  $InstallButton = New-Object System.Windows.Forms.Button
  $CancelButton = New-Object System.Windows.Forms.Button

  $SelectAllButton.Text = 'Select All'
  $SelectAllButton.Location = '15,245'
  $SelectAllButton.Add_Click({
    For ($i=0; $i -lt $CheckedListBox.Items.count;$i++) {
      $CheckedListBox.SetItemchecked($i,$True) 
    }
  })

  $InstallButton.Text = 'Install'
  $InstallButton.Location = '15,276'
  $InstallButton.Add_Click({
    $macroSequenciesRelPath = "Mods\aircraft\{0}\Cockpit\Scripts\Macro_sequencies.lua"
    # install each selected script
    $i = 0    
    foreach($aircraftToInstall in $checkedlistbox.checkeditems) {
      # intstall logic goes here, name of aircraft (path) will be in $aircraftToInstall
      Write-Host $aircraftToInstall
      
      Write-Host "Taking a backup of your current auto start..."
      $installPath = Get-DCSInstallPath
      $relPath = ([string]::Format($macroSequenciesRelPath,$aircraftToInstall)) # $aircraft
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
      $i++
    }
    $wsh = New-Object -ComObject Wscript.Shell
    $wsh.Popup([string]::Format("{0} new scripts deployed successfully`nHappy Hunting!",$i))
  })

  $uninstallButton.Text = 'Uninstall'
  $UninstallButton.Location = '15,327'
  $UninstallButton.Add_Click({
    # uninstall logic goes here
    $macroSequenciesRelPath = "Mods\aircraft\{0}\Cockpit\Scripts\Macro_sequencies.lua"
    $macroSequenciesOrigRelPath = "Mods\aircraft\{0}\Cockpit\Scripts\Macro_sequencies-orig.lua"
    # install each selected script
    $i = 0    
    foreach($aircraftToInstall in $checkedlistbox.checkeditems) {
      # intstall logic goes here, name of aircraft (path) will be in $aircraftToInstall
      Write-Host $aircraftToInstall
      
      $installPath = Get-DCSInstallPath
      $relPath = ([string]::Format($macroSequenciesRelPath,$aircraftToInstall)) # $aircraft
      #Write-Host $installPath
      $destPath = ($installPath + $relPath)

      Remove-Item $destPath

      $origRelPath = ([string]::Format($macroSequenciesOrigRelPath,$aircraftToInstall)) # $aircraft
      #Write-Host $installPath
      #$destPath = ($installPath + $relPath)

      Write-Host "Restoring ED auto start..." -NoNewline
      Copy-Item $origRelPath -Destination $destPath

      Write-Host "success!"
      $i++
    }
    $wsh = New-Object -ComObject Wscript.Shell
    $wsh.Popup([string]::Format("{0} new scripts deployed successfully`nHappy Hunting!",$i))
  })

  $CancelButton.Text = 'Cancel'
  $CancelButton.Location = '15,354'

  $ButtonFont = New-Object System.Drawing.Font("Arial",10)

  $InstallButton.Font = $ButtonFont
  $CancelButton.Font = $ButtonFont
  $UninstallButton.font = $ButtonFont
  $SelectAllButton.Font = $ButtonFont

  #$Form.AcceptButton = $SelectAllButton  #these three aren't needed
  #$Form.CancelButton = $UninstallButton
  #$Form.AcceptButton = $InstallButton
  $Form.CancelButton = $CancelButton

  $Form.Controls.Add($SelectAllButton)
  $Form.Controls.Add($UninstallButton)
  $Form.Controls.Add($InstallButton)
  $Form.Controls.Add($CancelButton)



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