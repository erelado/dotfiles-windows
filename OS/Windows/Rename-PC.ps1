function Rename-PC {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [String]
        $Name
    )

    <#
    .SYNOPSIS
    Renames the machine.

    .PARAMETER Name
    Specifies the required machine's name.

    .OUTPUTS
    None.
    #>

    if ($env:COMPUTERNAME -ne $Config.ComputerName) {
        Write-Host "Renaming PC:" -ForegroundColor "Yellow";
  
        Rename-Computer -NewName $Name -Force
  
        Write-Host "PC has been successfully renamed to ${Name} (a restart is required to see changes).`n" -ForegroundColor "Green"
    }
    else {
        Write-Host "The PC name is '${Name}' already. This step is skipped.`n" -ForegroundColor "Yellow"
    }
}
