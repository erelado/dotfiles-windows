# $VSCodeConfig = @{
#     InstallExtensions = @{
#         FormattingAndRules = false
#         HTMLandCSS = false
#         Markdown = false
#         PowerShell = false
#         Terraform = false
#         Themes = false
#         Tools = false
#         YAML = false
#     }
# }
$Applications = @(
    [WingetConfiguredApp]::New(
        'Espanso',
        [ordered]@{ winget = 'Espanso.Espanso'; },
        @{ SetConfigs = $FALSE; }
    )

    [WingetConfiguredApp]::New(
        'Git',
        [ordered]@{ winget = 'Git.Git' }, 
        @{ Globals = @{User_Name = ""; User_Email = ""; } }
    )

    [WingetConfiguredApp]::New(
        'Visual Studio Code',
        [ordered]@{ msstore = 'XP9KHM4BK9FZ7Q'; winget = 'Microsoft.VisualStudioCode'; },
        @{ InstallExtensions = $FALSE; SetCustomSettings = $FALSE; }
    )

    [WingetConfiguredApp]::New(
        'Windows Terminal',
        [ordered]@{ msstore = '9N0DX20HK701'; winget = 'Microsoft.WindowsTerminal'; },
        @{ SetCustomSettings = $FALSE; }
    )
)
