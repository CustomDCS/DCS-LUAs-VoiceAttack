# clean up existing files
Remove-Item .\Output\* -Force -Recurse
# zip all the files in Mods\
Compress-Archive -Path .\Mods "CustomDCS.zip"
# exe latest deploy script
Invoke-PS2EXE .\Deploy\CustomDCS-Deploy.ps1 -outputFile "CustomDCS.exe"
# copy to output folder
Move-Item "CustomDCS.*" .\Output\.