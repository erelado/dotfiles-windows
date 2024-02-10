$BasicTools = @(
    [WingetApp]::New(
        '7-Zip',
        [ordered]@{ 'winget' = '7zip.7zip'; }
    ),
    [WingetApp]::New(
        'Fluent Search',
        [ordered]@{ 'msstore' = '9NK1HLWHNP8S'; 'winget' = 'BlastApps.FluentSearch'; }
    ),
    [WingetApp]::New(
        'PowerToys',
        [ordered]@{ 'msstore' = 'XP89DCGQ3K6VLD'; 'winget' = 'Microsoft.PowerToys'; }
    ),
    [WingetApp]::New(
        'ShareX',
        [ordered]@{ 'msstore' = '9NBLGGH4Z1SP'; 'winget' = 'ShareX.ShareX'; }
    ),
    [WingetApp]::New(
        'SnipDo',
        [ordered]@{ 'msstore' = '9NPZ2TVKJVT7'; }
    ),
    [WingetApp]::New(
        'SumatraPDF',
        [ordered]@{ 'winget' = 'SumatraPDF.SumatraPDF'; }
    ),
    [WingetApp]::New(
        'Sysinternals',
        [ordered]@{ 'msstore' = '9P7KNL5RWT25'; }
    ),
    [WingetApp]::New(
        'VideoLAN (VLC)',
        [ordered]@{ 'msstore' = 'XPDM1ZW6815MQM'; 'winget' = 'VideoLAN.VLC'; }
    ),
    [WingetApp]::New(
        'WinSCP',
        [ordered]@{ 'winget' = 'WinSCP.WinSCP'; }
    )
)
