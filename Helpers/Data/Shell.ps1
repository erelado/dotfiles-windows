$PowerShellConfig = @{
    Profile  = [ordered]@{ Set = $FALSE; RemoveNonInstalledSections = $FALSE; }
    Modules  = @(
        @{
            Name       = "posh-git"
            Install    = $FALSE
            Repository = "PSGallery"
            Force      = $FALSE
        }
        @{
            Name       = "PSWebSearch"
            Install    = $FALSE
            Repository = "PSGallery"
            Force      = $FALSE
        }
        @{
            Name       = "PSReadLine"
            Install    = $FALSE
            Repository = "PSGallery"
            Force      = $TRUE
        }
        @{
            Name       = "Terminal-Icons"
            Install    = $FALSE
            Repository = "PSGallery"
            Force      = $FALSE
        }
        @{
            Name       = "z"
            Install    = $FALSE
            Repository = "PSGallery"
            Force      = $FALSE
        }
    )
    OhMyPosh = [WingetApp]::New(
        'OhMyPosh',
        [ordered]@{ winget = 'JanDeDobbeleer.OhMyPosh'; }
    )
}

$PowerShell = [WingetConfiguredApp]::New(
    'PowerShell',
    [ordered]@{ msstore = '9MZ1SNWT0N5D'; winget = 'Microsoft.PowerShell'; },
    $PowerShellConfig
)
