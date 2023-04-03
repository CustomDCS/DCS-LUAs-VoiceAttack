Add-Type -AssemblyName System.Windows.Forms

$Form = New-Object System.Windows.Forms.Form
$Form.width = 500
$Form.height = 600
$Form.Text = 'OU Picker v0.01'

$checkedlistbox=New-Object System.Windows.Forms.CheckedListBox
$checkedlistbox.Location = '10,10'
$checkedlistbox.Size = '200,300'

$form.Controls.Add($checkedlistbox)

$ous = (Get-ChildItem -Path "Mods\aircraft" -Directory).Name
$checkedListBox.DataSource = [collections.arraylist]$ous
$checkedListBox.DisplayMember = 'Name'
$checkedlistbox.CheckOnClick = $true
#$checkedlistbox.Sorted = $true

$ApplyButton = new-object System.Windows.Forms.Button
$ApplyButton.Location = '130, 400'
$ApplyButton.Size = '100, 40'
$ApplyButton.Text = 'OK'
$ApplyButton.DialogResult = 'Ok'
$form.Controls.Add($ApplyButton)

[void]$Form.ShowDialog()
$checkedlistbox.CheckedItems | select name, distinguishedname