################################################################################
# Auxiliary variables                                                          #
################################################################################
$GitHubRepositoryUri = "https://github.com/$($GitHubRepositoryAuthor)/$($GitHubRepositoryName)/archive/refs/heads/main.zip"
$DotfilesDirectory = Join-Path -Path ${HOME} -ChildPath ".dotfiles"
$DirFullPath = Join-Path -Path $DotfilesDirectory -ChildPath "$($GitHubRepositoryName)-main"
$ZipFullPath = "${DirFullPath}.zip"


################################################################################
# Existing .dotfiles directory                                                 #
################################################################################
if (Test-Path $DotfilesDirectory) {
    Write-Host "There is an existing directory under $($DotfilesDirectory)." -ForegroundColor "Yellow"
    do {
        Write-Host "Do you wish to replace the existing directory? "
        Write-Host "[Y] Yes " -NoNewline
        Write-Host "[N] No " -Foregroundcolor "Yellow" -NoNewline
        Write-Host "(default is 'N'): " -Foregroundcolor "DarkGray" -NoNewline
        $Reply = Read-Host
        if (-not ($Reply -match "^(?:y|yes|n|no|)$")) {
            Write-Host "'${Reply}' is not a valid answer.`n" -ForegroundColor "Red"
        }
    }
    while (-not ($Reply -match "^(?:y|yes|n|no|)$"))

    if ($Reply -match "^(?:n|no|)$") { break }

    Get-ChildItem -Path $DotfilesDirectory -Recurse | Remove-Item -Force -Recurse
    Remove-Item -Path $DotfilesDirectory
}
New-Item $DotfilesDirectory -ItemType directory


################################################################################
# Download                                                                     #
################################################################################
$IsDownloaded = $FALSE

Try {
    Invoke-WebRequest $GitHubRepositoryUri -OutFile $ZipFullPath
    $IsDownloaded = $TRUE
}
catch [System.Net.WebException] {
    Write-Host "Error connecting to GitHub, please check your internet connection or the repository url." -ForegroundColor "Red"
}

if ($IsDownloaded) {
    # Extract
    Expand-Archive $ZipFullPath -DestinationPath $DotfilesDirectory -Force

    # Clean up
    Get-ChildItem –Path $DirFullPath -Recurse -Force | Move-Item -Destination $DotfilesDirectory -Force
    Remove-Item -Path $ZipFullPath -Force
    Remove-Item -Path $DirFullPath -Force
    
    # Invoke setup
    Invoke-Expression (Join-Path -Path $DotfilesDirectory -ChildPath "Setup.ps1")
}
