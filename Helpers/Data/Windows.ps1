$Windows = [OSObject]::New(
    'Windows',
    @{
        RenameComputer   = @{ Set = $FALSE; ComputerName = ""; }
        DarkMode         = $FALSE
        ExplorerSettings = $FALSE
        PowerPlan        = $FALSE
        PrivacySettings  = $FALSE
        RegionalFormat   = $FALSE
    },
    @{Workspace = @{ Set = $FALSE; ParentDirectory = ""; } },
    @{NerdFont = @{ Install = $FALSE; FontName = ""; } }
)
