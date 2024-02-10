function Set-Configurations {

    <#
    .SYNOPSIS
    Acts based on the configuration file settings and operates accordingly.

    .INPUTS
    None. You cannot pipe objects to Set-Configurations.

    .OUTPUTS
    None.
    #>

    $ConfigurationData = Get-Content -Raw -Path "${DotfilesDirectory}\config.json" | ConvertFrom-Json

    Clear-Host
    Write-AsTypeWriter -Content "Please do not use your device while the script is running." -ForegroundColor "Yellow"
    Write-AsTypeWriter "[!] Note: upon completion, the script will restart the computer." -ForegroundColor "Yellow"
    Write-ProcessingAnimation { Start-Sleep 5 }
    Write-Host $("*" * 72) -ForegroundColor "Yellow"

    Set-ApplicationConfigurations -JSON_Data $ConfigurationData

    Set-OSConfigurations -JSON_Data $ConfigurationData

    Set-ShellConfigurations -JSON_Data $ConfigurationData
    
}
