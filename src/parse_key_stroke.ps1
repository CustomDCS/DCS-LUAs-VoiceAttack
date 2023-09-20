[XML]$vap = Get-Content 'VoiceAttack\Gazelle (RH)\Gazelle (Rotorheads) 0002-Profile.vap'

# prints 220
#$vap.Profile.Commands.Command[0].ActionSequence.CommandAction[0].KeyCodes.unsignedShort
$commandCount = 0
foreach ($command in $vap.Profile.Commands.Command)
{

  Write-Host "Checking "$command.CommandString
  $codes = @()
  foreach ($commandAction in $command.ActionSequence.CommandAction)
  {
    # make a list of all command actions
    $codes += $commandAction.KeyCodes.unsignedShort
  }
  if($codes[0] -eq 220) { # \
    if($codes[1] -eq 121){ # F10
      if($codes[2] -eq 112){ #F1
        # change to 114
        Write-Host "Updating F1 to F3"
        $codes[2] = 114
      }elseif ($codes[2] -eq 113) { #F2
        # change to 112
        Write-Host "Updating F2 to F1"
        $codes[2] = 112
      }elseif ($codes[2] -eq 114) { #F3
        # change to 115
        Write-Host "Updating F3 to F2"
        $codes[2] = 113
      }
    }
  }
  #$codes
  #$vap.Profile.Commands.Command[0].ActionSequence.CommandAction[2].KeyCodes.unsignedShort
  # save back to main $vap
  #$command.ActionSequence.CommandAction
  $vap.Profile.Commands.Command[$commandCount].ActionSequence.CommandAction[2].KeyCodes.unsignedShort = $codes[2].ToString()
  $commandCount++
}

# save the new file
$vap.Save('.\src\out.vap')