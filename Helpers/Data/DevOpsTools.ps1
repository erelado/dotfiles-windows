$DevOpsTools = @(
    [WingetApp]::New(
        'AWS CLI',
        [ordered]@{ winget = 'Amazon.AWSCLI'; }
    ),
    [WingetApp]::New(
        'Azure CLI',
        [ordered]@{ winget = 'Microsoft.AzureCLI'; }
    ),
    [WingetApp]::New(
        'Docker Desktop',
        [ordered]@{ winget = 'Docker.DockerDesktop'; }
    ),
    [WingetApp]::New(
        'kubectl',
        [ordered]@{ winget = 'Kubernetes.kubectl'; }
    ),
    [WingetApp]::New(
        'MobaXterm',
        [ordered]@{ winget = 'Mobatek.MobaXterm'; }
    )
)
