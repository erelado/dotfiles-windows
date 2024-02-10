function Set-NerdFont {
    param ()
    
    <#
    .SYNOPSIS
    Sets the 'NerdFont' required by the user, which will be installed later.

    .DESCRIPTION
    Sets the 'NerdFont' required by the user, which will be installed later.
    The options to select from are taken from the latest release of 
    https://github.com/ryanoasis/nerd-fonts

    .INPUTS
    None. You cannot pipe objects to Set-NerdFont.

    .OUTPUTS
    System.String. Set-NerdFont returns the zip fileName that needs to be 
    downloaded from NerdFont's repository.
    #>

    $NerdFonts = @()
    $Repo = "ryanoasis/nerd-fonts"
    $Releases = "https://api.github.com/repos/$Repo/releases/latest"

    Write-Host "Determining available Nerd Fonts: " -ForegroundColor "Yellow" -NoNewLine
    (Invoke-WebRequest $Releases | ConvertFrom-Json).assets | ForEach-Object {
        $NerdFonts += $_.Name.Split(".zip")[0]
    }
    Write-Host "Done."

    $Reply = Select-FromArrayOptions $NerdFonts
    return "$($NerdFonts | Select-String $Reply)"
}
