function Install-NerdFont {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [String]
        $FontName
    )

    <#
    .SYNOPSIS
    Installs the 'NerdFont' required by the user.

    .PARAMETER FontName
    The Nerd Font name to install.

    .INPUTS
    None. You cannot pipe objects to Set-NerdFont.

    .OUTPUTS
    System.String. Set-NerdFont returns the zip fileName that needs to be 
    downloaded from NerdFont's repository.
    #>

    $ExistingFonts = 0

    Write-Host "Installing $($FontName) Nerd-Font:" -ForegroundColor "Yellow"

    $Repo = "ryanoasis/nerd-fonts"
    $Releases = "https://api.github.com/repos/${Repo}/releases/latest"

    Write-Host "Determining latest release: " -ForegroundColor "Yellow" -NoNewline
    $Tag = (Invoke-WebRequest $Releases | ConvertFrom-Json)[0].tag_name
    Write-Host $Tag

    $Download = "https://github.com/${Repo}/releases/download/${Tag}/${FontName}.zip"

    $Dir = "$FontName-$Tag"
    $DirFullPath = Join-Path ${HOME} -ChildPath "Downloads" | Join-Path -ChildPath $Dir

    $Zip = "${Dir}.zip"
    $ZipFullPath = Join-Path ${HOME} -ChildPath "Downloads" | Join-Path -ChildPath $Zip

    # Download
    Write-Host "Dowloading latest release: " -ForegroundColor "Yellow" -NoNewline
    Invoke-WebRequest $Download -Out $ZipFullPath
    Write-Host "Done."

    Write-Host "Extracting release files: " -ForegroundColor "Yellow" -NoNewline
    Expand-Archive $ZipFullPath -DestinationPath $DirFullPath -Force
    Write-Host "Done."

    $Fonts = 0x14
    $ObjShell = New-Object -ComObject Shell.Application
    $ObjFontsDirectory = $ObjShell.Namespace($Fonts)

    # Install
    Write-Host "Installing the font-family: " -ForegroundColor "Yellow"
    $Fonts = Get-ChildItem -Path $DirFullPath | Where-Object { $_.Extension -eq ".ttf" }
    $InstalledFonts = @(Get-ChildItem (Join-Path "C:\" -ChildPath "Windows" | Join-Path -ChildPath "Fonts") | `
            Where-Object { $_.PSIsContainer -eq $FALSE } | Select-Object BaseName)

    $FontNumber = 0
    foreach ($Font in $Fonts) {
        $Copy = $TRUE
        $CurrentFontName = $Font.BaseName -replace "_", ""
        $FontNumber++

        foreach ($InstalledFont in $InstalledFonts) {
            $InstalledFontName = $InstalledFont.BaseName -replace "_", ""
            
            if ($InstalledFontName -match $CurrentFontName) { $Copy = $FALSE }
        }

        if ($Copy) {
            # Font number
            Write-Host "($(([string]$FontNumber).PadLeft(2,'0'))/$($Fonts.Length)) " -ForegroundColor "Yellow" -NoNewline
            # Font name
            Write-Host "Installing '$CurrentFontName'..."
            $ObjFontsDirectory.CopyHere($Font.FullName)
        }
        else { $ExistingFonts++ }
    }
    if ($ExistingFonts -gt 0) { Write-Host "$($ExistingFonts)/$($Fonts.Length) fonts were already installed ==> " -NoNewLine }
    Write-Host "Done."

    # Clean
    Write-Host "Removing temporary files: " -ForegroundColor "Yellow" -NoNewline
    Remove-Item $ZipFullPath -Force
    Remove-Item $DirFullPath -Recurse -Force
    Write-Host "Done."

    Write-Host "$($FontName) Nerd-Font has been successfully installed.`n" -ForegroundColor "Green"
}
