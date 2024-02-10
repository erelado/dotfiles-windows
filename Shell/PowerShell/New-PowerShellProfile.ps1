function New-PowerShellProfile {
    param (     
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [PSCustomObject]
        $JSON_Data
    )

    <#
    .SYNOPSIS
    Updates the powershell profile to include only relevant parts, and copies
    it to the specified location.

    .DESCRIPTION
    Examines the configuration file and removes parts that are not
    relevant from the powershell profile. After that, copy the final file
    to the desired location.

    .PARAMETER JSON_Data
    Specifies the PSCustomObject of the configuration file.

    .OUTPUTS
    None.
    #>

    $PSProfileTemplateFilePath = Join-Path $DotfilesDirectory -ChildPath "Shell" | `
        Join-Path -ChildPath "PowerShell" | Join-Path -ChildPath "Profile" | `
        Join-Path -ChildPath "Template.ps1"

    $PSProfileCandidateFilePath = Join-Path $DotfilesDirectory -ChildPath "Shell" | `
        Join-Path -ChildPath "PowerShell" | Join-Path -ChildPath "Profile" | `
        Join-Path -ChildPath "Profile.ps1"

    # Start by creating a replica of the template file
    Copy-Item $PSProfileTemplateFilePath -Destination $PSProfileCandidateFilePath

    
    if (-not $JSON_Data.Shell.PowerShell.Configurations.Profile.RemoveNonInstalledSections) {
        Set-PowerShellProfile -FilePath $PSProfileCandidateFilePath
        return
    }

    # Otherwise, exclude irrelevant parts
    foreach ($DevOpsTool in $JSON_Data.Applications.DevOpsTools) {
        switch ($DevOpsTool.Name.ToLower()) {
            "Docker Desktop" {
                if (-not $DevOpsTool.Install) {
                    Remove-PowerShellProfileSection -ProfileFilePath $PSProfileCandidateFilePath `
                        -SectionName "Docker Aliases"
                }

                break
            }
            "kubectl" {
                if (-not $DevOpsTool.Install) {
                    Remove-PowerShellProfileSection -ProfileFilePath $PSProfileCandidateFilePath `
                        -SectionName "Kubernetes Aliases"
                }
                
                break
            }
            Default {
                break
            }
        }
    }

    if (-not $JSON_Data.Shell.PowerShell.Configurations.OhMyPosh.Install) {
        Remove-PowerShellProfileSection -ProfileFilePath $PSProfileCandidateFilePath `
            -SectionName "Oh My Posh"
    }

    foreach ($PowerShellModule in $JSON_Data.Shell.PowerShell.Configurations.Modules) {
        switch ($PowerShellModule.Name.ToLower()) {
            "posh-git" {
                if (-not $PowerShellModule.Install) {
                    Get-Content $PSProfileCandidateFilePath | Select-String -pattern $PowerShellModule.Name -notmatch | Out-File "temp.ps1"
                    Move-Item -Force "temp.ps1" $PSProfileCandidateFilePath
                }
            }
            "Terminal-Icons" {
                if (-not $PowerShellModule.Install) {
                    Get-Content $PSProfileCandidateFilePath | Select-String -pattern $PowerShellModule.Name -notmatch | Out-File "temp.ps1"
                    Move-Item -Force "temp.ps1" $PSProfileCandidateFilePath
                }
            }
            "PSReadLine" {
                if (-not $PowerShellModule.Install) {
                    Get-Content $PSProfileCandidateFilePath | Select-String -pattern $PowerShellModule.Name -notmatch | Out-File "temp.ps1"
                    Move-Item -Force "temp.ps1" $PSProfileCandidateFilePath
                }
            }
            Default {
                break
            }
        }
    }

    Set-PowerShellProfile -FilePath $PSProfileCandidateFilePath
}
