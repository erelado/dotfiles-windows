function New-WorkspaceDirectory {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [String]
        $ParentDirectory
    )

    <#
    .SYNOPSIS
    Creates the 'workspace' directory in the location selected by the user.

    .PARAMETER ParentDirectory
    The parent directory on which the 'workspace' directory should be placed.

    .OUTPUTS
    None.
    #>

    $WorkspaceDirectory = Join-Path -Path $ParentDirectory -ChildPath "Workspace"

    if (-not (Test-Path $WorkspaceDirectory)) {
        Write-Host "Creating your development workspace directory:" -ForegroundColor "Yellow" -NoNewline
        New-Item $WorkspaceDirectory -ItemType directory
    
        if (-not (Test-Path $WorkspaceDirectory)) {
            Write-Host "Could not create the 'Workspace' directory" -ForegroundColor "Red"
            break
        }

        Write-Host "The 'Workspace' directory has been created successfully.`n" -ForegroundColor "Green"
        break
    }

    Write-Host "The 'Workspace' directory exists already. This step is skipped.`n" -ForegroundColor "Yellow"
}
