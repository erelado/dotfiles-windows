function Remove-DesktopShortcuts {
    
    <#
    .SYNOPSIS
    Removes any existing desktop shortcuts.

    .DESCRIPTION
    Removes any '*.lnk' or '*.url' files found on the desktop.

    .INPUTS
    None. You cannot pipe objects to Remove-DesktopShortcuts.

    .OUTPUTS
    None.
    #>
    
    $UserDesktopPath = "${env:USERPROFILE}\Desktop"
    $PublicDesktopPath = "${env:PUBLIC}\Desktop"

    Write-Host "Deleting shorcuts in desktop:" -ForegroundColor "Yellow"

    Get-ChildItem -Path "${UserDesktopPath}\*" -Include "*.lnk", "*.url" -Recurse | Remove-Item
    Get-ChildItem -Path "${PublicDesktopPath}\*" -Include "*.lnk", "*.url" -Recurse | Remove-Item

    Write-Host "Shorcuts in desktop successfully deleted.`n" -ForegroundColor "Green"
}
