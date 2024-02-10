########################################################################
#                           Initial Commands                           #
########################################################################


function Write-ProcessingAnimation {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [ScriptBlock]
        $ScriptBlock
    )

    $CursorTop = [Console]::CursorTop
    
    try {
        [Console]::CursorVisible = $FALSE
        
        $Counter = 0
        $Frames = '|', '/', '-', '\' 
        $JobName = Start-Job -ScriptBlock $ScriptBlock
    
        while ($JobName.JobStateInfo.State -eq "Running") {
            $Frame = $Frames[$Counter % $Frames.Length]
            
            Write-Host "$Frame" -NoNewLine
            [Console]::SetCursorPosition(0, $CursorTop)
            
            $Counter += 1
            Start-Sleep -Milliseconds 125
        }
        
        # # Only needed if you use a multiline Frames
        # Write-Host ($Frames[0] -replace '[^\s+]', ' ')
    }
    finally {
        [Console]::SetCursorPosition(0, $CursorTop)
        [Console]::CursorVisible = $TRUE
    }
}

Clear-Host


########################################################################
#                            Import Modules                            #
########################################################################


$ImportModules = @(
    "posh-git"
    "Terminal-Icons"
    "PSReadLine"
)

$ImportModules | ForEach-Object {
    Write-Host "Importing $($_)"
    Write-ProcessingAnimation { Import-Module $_ }
}


########################################################################
#                            System Aliases                            #
########################################################################


function Get-CommandPath {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [Alias('c', 'cmd')]
        [String]
        $CommandName
    )

    $Command = Get-Command -Name $CommandName -ErrorAction SilentlyContinue
    if (($null -ne $Command) -and ($Command.CommandType -eq "alias")) {
        $Command = Get-Command -Name (Get-Alias $Command).Definition -ErrorAction SilentlyContinue
    }
    
    if ($null -ne $Command) {
        $Command | Select-Object -ExpandProperty Source -ErrorAction SilentlyContinue
    }
    else {
        Write-Host "Could not locate the source of '$($CommandName)'."
    }
}
Set-Alias -Name "locate" -Value "Get-CommandPath"

function Connect-RemoteDesktop {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [Alias('s')]
        [String]
        $Server
    )

    Start-Process mstsc -ArgumentList "/v:$Server"
}
Set-Alias -Name "rdp" -Value "Connect-RemoteDesktop"

function Get-Uptime {
    Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object CSName, LastBootUpTime
}
Set-Alias -Name "uptime" -Value "Get-Uptime"

function Invoke-RepeatCommand {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $TRUE)]
        [Alias('a', 'times')]
        [int]$Amount,

        [Parameter(Mandatory = $TRUE)]
        [Alias('c', 'cmd')]
        $Command,

        [Parameter(ValueFromRemainingArguments = $TRUE)]
        [Alias('p', 'param')]
        $Params
    )

    begin {
        $Params = $Params -join ' '
    }

    process {
        for ($i = 1; $i -le $Amount; $i++) {
            &$Command $Params
        }
    }
}
Set-Alias -Name "repeat" -Value Invoke-RepeatCommand


########################################################################
#                      File Management Aliases                         #
########################################################################


function Edit-Hosts {
    Invoke-Expression "$(if($null -ne $env:EDITOR) { $env:EDITOR } else { 'notepad' }) $(Join-Path $env:WINDIR -ChildPath "system32" | `
    Join-Path -ChildPath "drivers" | Join-Path -ChildPath "etc" | Join-Path -ChildPath "hosts")"
}
Set-Alias -Name "hosts" -Value "Edit-Hosts"

function Edit-Profile { Invoke-Expression "$(if ($null -ne $env:EDITOR) { $env:EDITOR } else { 'notepad' }) ${PROFILE}" }
Set-Alias -Name "profile" -Value "Edit-Profile"

function Restart-Profile {
    & ${PROFILE}
}
Set-Alias -Name "loadp" -Value "Restart-Profile"
Set-Alias -Name "lprofile" -Value "Restart-Profile"
Set-Alias -Name "loadprofile" -Value "Restart-Profile"

function Remove-ToRecycleBin {

    if ($Args.Count -eq 0) {
        explorer.exe Shell:RecycleBinFolder
        break
    }

    Add-Type -AssemblyName Microsoft.VisualBasic
    foreach ($Path in $Args) {
        $Item = Get-Item -Path $Path -ErrorAction SilentlyContinue
        if ($null -eq $Item) {
            Write-Error "'$($Path)' not found"
            continue
        }

        $FullPath = $Item.FullName
        Write-Host "Moving '$($FullPath)' to the Recycle Bin" -NoNewline
        if (Test-Path -Path $FullPath -PathType Container) {
            [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory($FullPath, 'OnlyErrorDialogs', 'SendToRecycleBin')
        }
        else {
            [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($FullPath, 'OnlyErrorDialogs', 'SendToRecycleBin')
        }

        if (-not (Test-Path -Path $FullPath)) {
            Write-Host " ==> Success."
        }
        else {
            Write-Host " ==> Failed."
        }
    }
}
Set-Alias -Name "trash" -Value "Remove-ToRecycleBin"

function Remove-FromRecycleBin {
    $RecBin = (New-Object -ComObject Shell.Application).Namespace(0xA)
    $RecBin.Items() | ForEach-Object { Remove-Item $_.Path -Recurse -Confirm:$FALSE }
}
Set-Alias -Name "cls-trash" -Value "Remove-FromRecycleBin"

function New-DirectoryCreateAndSet { 
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [String]
        $SubPath
    )
    New-Item "$($PWD.Path)\$SubPath" -ItemType Directory -ErrorAction SilentlyContinue; Set-Location "$($PWD.Path)\$SubPath"
}
Set-Alias -Name "mkcd" -Value "New-DirectoryCreateAndSet"

function Expand-ZipFile {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
	[Alias('f', 'file')]
        [String]
        $FileName,

        [Parameter(Position = 1, Mandatory = $FALSE)]
        [bool]
        $Found = $FALSE
    )
    
    if ('.' -eq $FileName) {
        $Files = Get-ChildItem .\* -include ('*.zip', '*.rar')
        Write-Host "Found $(($Files | Measure-Object).Count) files in total.`n"

        if ((($Files | Measure-Object).Count) -gt 0) {
            $Found = $TRUE
            $DirName = Split-Path -Path (Get-Location) -Leaf
            if (-not (Test-Path($DirName))) { New-Item -Force -ItemType Directory -Path $DirName | Out-Null }
        
            ForEach ($File in $Files) {
                Write-Output "> Extracting $(Split-Path -Path ($File) -Leaf)"
                Expand-Archive $file -DestinationPath $DirName
            }
        }
    }
    else {
        $FilePath = Get-ChildItem -Filter $FileName -File -ErrorAction SilentlyContinue | `
            Select-Object -First 1 -ExpandProperty FullName
        
        if ([string]::IsNullOrEmpty($FilePath)) { Write-Error "Cound not find '$FileName'"; break }
        else {
            $Found = $TRUE
            $DirName = (Get-Item $FilePath).Basename
            Write-Output "> Extracting $FileName"
            if (-not (Test-Path($DirName))) { New-Item -Force -ItemType Directory -Path $DirName | Out-Null }
            Expand-Archive $FilePath -DestinationPath $DirName
        }
    }
    if ($Found) { Write-Output "`nExtracted all files to '$DirName' subdirectory." }
}
Set-Alias -Name "unzip" -Value "Expand-ZipFile"

function Write-Path {
	($env:Path).Split(";")
}
Set-Alias -Name "path" -Value "Write-Path"


function Copy-ItemSecured {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $TRUE,
            ValueFromPipeline = $TRUE
        )]
        [Alias('s')]
        [string]$Source,

        [Parameter(Mandatory = $TRUE)]
        [Alias('d')]
        [string]$Destination
    )

    $SourcePath = Split-Path -Path $Source
    if (!$SourcePath) { $SourcePath = '.' }
    $File = Split-Path -Path $Source -Leaf

    robocopy /COPY:DAT /DCOPY:DAT /LEV:0 $SourcePath $Destination $File
}
Set-Alias -Name "cps" -Value Copy-ItemSecured

function Find-Directory {
    Get-ChildItem -Path . -Directory -Name -Recurse -ErrorAction SilentlyContinue -Include @args
}
Set-Alias -Name "fd" -Value Find-Directory

function Find-File {
    Get-ChildItem -Path . -File -Name -Recurse -ErrorAction SilentlyContinue -Include @args
}
Set-Alias -Name "ff" -Value Find-File


########################################################################
#                            Time Aliases                              #
########################################################################


function Get-DateExtended {
    param(
        [Parameter(Mandatory = $FALSE)]
        [Alias('d')]
        [String]
        $Date
    )
    
    # Local date and time in ISO-8601 format
    $RequiredDateTime = if (-not [String]::IsNullOrEmpty($Date)) { Get-Date $Date } else { Get-Date }
    Get-Date $RequiredDateTime -Format "yyyy-MM-ddTHH:mm:ss"
}
Set-Alias -Name "date" -Value Get-DateExtended

function Get-DateExtendedUTC {
    param(
        [Parameter(Mandatory = $FALSE)]
        [Alias('d')]
        [String]
        $Date
    )
    
    # UTC date and time in ISO-8601 format
    $RequiredDateTime = if (-not [String]::IsNullOrEmpty($Date)) { Get-Date $Date } else { Get-Date }
    ($RequiredDateTime).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss")
}
Set-Alias -Name "udate" -Value Get-DateExtendedUTC

function Get-Timestamp {
    param(
        [Parameter(Mandatory = $FALSE)]
        [Alias('d')]
        [String]
        $Date
    )
    
    # Unix time stamp
    $RequiredDateTime = if (-not [String]::IsNullOrEmpty($Date)) { Get-Date $Date } else { Get-Date }
    Get-Date $RequiredDateTime -UFormat %s -Millisecond 0
}
Set-Alias -Name "timestamp" -Value Get-Timestamp

function Get-WeekDate {
    param(
        [Parameter(Mandatory = $FALSE)]
        [Alias('d')]
        [String]
        $Date
    )

    # Week number in ISO-9601 format ('YYYY-Www')
    $RequiredDateTime = if (-not [String]::IsNullOrEmpty($Date)) { Get-Date $Date } else { Get-Date }
    (Get-Date $RequiredDateTime -UFormat %Y-W) + (Get-Date $RequiredDateTime -UFormat %W).PadLeft(2, '0')
}
Set-Alias -Name "week" -Value Get-WeekDate


########################################################################
#                           Network Aliases                            #
########################################################################


function Get-IPs {
    Get-NetIPAddress | Where-Object { $_.AddressState -eq "Preferred" } | `
        Sort-object IPAddress | Format-Table -Wrap -AutoSize
}
Set-Alias -Name "ips" -Value Get-IPS

function Get-LocalIP {
    $IPAddress = Get-CimInstance Win32_NetworkAdapterConfiguration | `
        Where-Object { $_.Ipaddress.length -gt 1 }
    Write-Host $IPAddress.ipaddress[0]
}
Set-Alias -Name "localip" -Value Get-LocalIP

function Get-PublicIP {
    Invoke-RestMethod http://ipinfo.io/json | Select-Object -exp ip
}
Set-Alias -Name "publicip" -Value Get-PublicIP


########################################################################
#                          Unixlike Aliases                            #
########################################################################


function sudo {
    $FilePath, [string]$Arguments = $Args
    $PSI = New-Object System.Diagnostics.ProcessStartInfo $FilePath
    $PSI.Arguments = $Arguments
    $PSI.Verb = "runas"
    $PSI.WorkingDirectory = Get-Location
    [System.Diagnostics.Process]::Start($PSI) >> $null
}

function sed {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [Alias('p')]
        [String]
        $FilePath,

        [Parameter(Position = 1, Mandatory = $TRUE)]
        [Alias('f')]
        [String]
        $Find,

        [Parameter(Position = 2, Mandatory = $TRUE)]
        [Alias('r')]
        [String]
        $Replacement
    )

	(Get-Content $FilePath).replace("$Find", $Replacement) | Set-Content $FilePath
}

function sed-recursive {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [Alias('p')]
        [String]
        $FilePath,

        [Parameter(Position = 1, Mandatory = $TRUE)]
        [Alias('f')]
        [String]
        $Find,

        [Parameter(Position = 2, Mandatory = $TRUE)]
        [Alias('r')]
        [String]
        $Replacement
    )

    $Files = Get-ChildItem . "$FilePattern" -rec
    foreach ($FilePath in $Files) {
		(Get-Content $FilePath.PSPath) |
        Foreach-Object { $_ -replace "$Find", "$Replacement" } |
        Set-Content $FilePath.PSPath
    }
}

Set-Alias -Name "grep" -Value "Select-String"

function which {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [String]
        $FileName
    )

    Get-Command $FileName | Select-Object -ExpandProperty Definition
}

function export {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [String]
        $FileName,

        [Parameter(Position = 1, Mandatory = $TRUE)]
        [String]
        $Value
    )

    Set-Item -Force -Path "env:$FileName" -Value $Value
}

function pkill {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [String]
        $FileName
    )

    Get-Process $FileName -ErrorAction SilentlyContinue | Stop-Process
}

function pgrep {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [String]
        $FileName
    )

    Get-Process $FileName
}

function touch {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [String]
        $FilePath
    )

    "" | Out-File $FilePath -Encoding ASCII
}


########################################################################
#                          Explorer Aliases                            #
########################################################################


function goto {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [Alias('l')]
        [String]
        $Location
    )

    Switch ($Location) {
        "dl" {
            Set-Location -Path (Join-Path ${HOME} -ChildPath "Downloads")
        }
        "doc" {
            Set-Location -Path (Join-Path ${HOME} -ChildPath "Documents")
        }
        "home" {
            Set-Location -Path "${HOME}"
        }
        default {
            try {
                Set-Location -Path $Location
            }
            catch {
                Write-Host "Invalid Location" -ForegroundColor "Red"
            }  
        }
    }
}
Set-Alias -Name "g" -Value "goto"

${function:~} = { Set-Location ~ }

# PowerShell might not allow ${function:..} because of an invalid Path error
${function:Set-ParentLocation} = { Set-Location .. }
Set-Alias -Name ".." -Value "Set-ParentLocation"

${function:...} = { Set-Location ..\.. }
${function:....} = { Set-Location ..\..\.. }
${function:.....} = { Set-Location ..\..\..\.. }


########################################################################
#                              Git Aliases                             #
########################################################################


function Invoke-GitSuperClone {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [Alias('r', 'repo')]
        [String]
        $RepositoryName
    )

    $DirectoryName = $RepositoryName.Split("/")[-1].Replace(".git", "")
    & git clone $RepositoryName $DirectoryName | Out-Null
    Set-Location $DirectoryName
    git submodule init
    git submodule update
}
Set-Alias -Name "gsc" -Value "Invoke-GitSuperClone"

function Invoke-GitCheckoutBranch {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [Alias('b', 'branch')]
        [String]
        $BranchName
    )

    git checkout -b $BranchName
}
Set-Alias -Name "gcb" -Value "Invoke-GitCheckoutBranch"

function Invoke-GitAdd {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [Alias('f', 'file')]
        [String]
        $FileToAdd
    )

    git add $FileToAdd
}
Set-Alias -Name "ga" -Value "Invoke-GitAdd"

function Invoke-GitAddAll {
    git add --all
}
Set-Alias -Name "gaa" -Value "Invoke-GitAddAll"

function Invoke-GitStatus {
    git status
}
Set-Alias -Name "gst" -Value "Invoke-GitStatus"

function Invoke-GitCommitMessage {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [Alias('m', 'msg')]
        [String]
        $Message
    )

    git commit -m $Message
}
Set-Alias -Name "gcmsg" -Value "Invoke-GitCommitMessage"

function Invoke-GitPushOriginCurrentBranch {
    git push origin HEAD
}
Set-Alias -Name "ggp" -Value "Invoke-GitPushOriginCurrentBranch"

function Invoke-GitLogStat {
    git log --stat
}
Set-Alias -Name "glg" -Value "Invoke-GitLogStat"

function Invoke-GitSoftResetLastCommit {
    git reset --soft HEAD^1
}
Set-Alias -Name "gsrlc" -Value "Invoke-GitSoftResetLastCommit"

function Invoke-GitHardResetLastCommit {
    git reset --hard HEAD~1
}
Set-Alias -Name "ghrlc" -Value "Invoke-GitHardResetLastCommit"


########################################################################
#                            Docker Aliases                            #
########################################################################


function Invoke-DockerPull {
    docker pull
}
Set-Alias -Name "dpl" -Value "Invoke-DockerPull"

function Invoke-DockerListWorkingContainers {
    docker container ls
}
Set-Alias -Name "dlc" -Value "Invoke-DockerListWorkingContainers"

function Invoke-DockerListContainers {
    docker container ls -a
}
Set-Alias -Name "dlca" -Value "Invoke-DockerListContainers"

function Invoke-DockerImages {
    docker images
}
Set-Alias -Name "dli" -Value "Invoke-DockerImages"

function Invoke-DockerStopContainer {
    docker container stop
}
Set-Alias -Name "dsc" -Value "Invoke-DockerStopContainer"

function Invoke-DockerDeleteContainer {
    docker container rm
}
Set-Alias -Name "drc" -Value "Invoke-DockerDeleteContainer"

function Invoke-DockerDeleteImage {
    docker image rm
}
Set-Alias -Name "dri" -Value "Invoke-DockerDeleteImage"

function Remove-DockerUnused {
    param (
        [Parameter(Position = 0, Mandatory = $FALSE)]
        [Alias('v')]
        [switch]
        $Volumes
    )

    # Containers
    $Trash = $(docker ps -q -f "status=exited")
    if ($null -eq $Trash) { Write-Host "No stopped containers" -ForegroundColor DarkYellow }
    else {
        Write-Host "Removing $($Trash.Count) stopped containers..." -ForegroundColor DarkYellow
        docker container prune -f
    }
    Write-Host ""

    # Images
    $Trash = $(docker images --filter "dangling=true" -q --no-trunc)
    if ($null -eq $Trash) { Write-Host "No dangling images" -ForegroundColor DarkYellow }
    else {
        Write-Host "Removing $($Trash.Count) dangling images..." -ForegroundColor DarkYellow
        docker rmi $Trash
    }

    # Volumes
    if ($Volumes) {
        Write-Host ""
        $Trash = $(docker volume ls --filter "dangling=true" -q)
        if ($null -eq $Trash) { Write-Host "No dangling volumes" -ForegroundColor DarkYellow }
        else {
            Write-Host "Removing $($Trash.Count) dangling volumes..." -ForegroundColor DarkYellow
            docker volume prune -f
        }
    }
}
Set-Alias -Name "dclean" -Value "Remove-DockerUnused"


########################################################################
#                          Kubernetes Aliases                          #
########################################################################


Set-Alias -Name "k" -Value "kubectl"

function Invoke-K8sGetPod {
    kubectl get pod
}
Set-Alias -Name "kgp" -Value "Invoke-K8sGetPod"

function Invoke-K8sListPods {
    kubectl get pods --all-namespaces
}
Set-Alias -Name "kgpa" -Value "Invoke-K8sGetPod"

function Invoke-K8sWatchPodLogs {
    kubectl logs --follow
}
Set-Alias -Name "klp" -Value "Invoke-K8sWatchPodLogs"

function Invoke-K8sApply {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [Alias('f', 'file')]
        [String]
        $FileName
    )
  
    kubectl apply -f $FileName
}
Set-Alias -Name "ka" -Value "Invoke-K8sApply"

function Invoke-K8sDelete {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [Alias('f', 'file')]
        [String]
        $FileName
    )

    kubectl delete -f $FileName
}
Set-Alias -Name "kd" -Value "Invoke-K8sDelete"

function Invoke-K8sReapply {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [Alias('f', 'file')]
        [String]
        $FileName
    )

    kubectl delete -f $FileName
    kubectl apply -f $FileName
}
Set-Alias -Name "kda" -Value "Invoke-K8sReapply"

function Invoke-K8sInteractive {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [Alias('p', 'pod')]
        [String]
        $PodName
    )

    kubectl exec --stdin --tty $PodName -- /bin/sh
}
Set-Alias -Name "ki" -Value "Invoke-K8sReapply"


########################################################################
#                              PSReadLine                              #
########################################################################


# Prediction functions
Set-PSReadLineOption -PredictionSource "History"
Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadLineOption -PredictionViewStyle "ListView"
Set-PSReadLineOption -Colors @{ "InlinePrediction" = [ConsoleColor]::DarkGray }

# Attempt to perform completion on the text surrounding the cursor.
Set-PSReadLineKeyHandler -Key "Tab" -Function "Complete"

# Start interactive screen capture - up/down arrows select Lines,
# enter copies selected text to clipboard as text and HTML.
Set-PSReadLineKeyHandler -Chord 'Ctrl+d,Ctrl+c' -Function "CaptureScreen"

# Token based word movement
Set-PSReadLineKeyHandler -Key Alt+d -Function ShellKillWord
Set-PSReadLineKeyHandler -Key Alt+Backspace -Function ShellBackwardKillWord
Set-PSReadLineKeyHandler -Key Alt+b -Function ShellBackwardWord
Set-PSReadLineKeyHandler -Key Alt+f -Function ShellForwardWord
Set-PSReadLineKeyHandler -Key Alt+B -Function SelectShellBackwardWord
Set-PSReadLineKeyHandler -Key Alt+F -Function SelectShellForwardWord

# Shows the entire or filtered History using Out-GridView.
Set-PSReadLineKeyHandler -Key "F7" `
    -BriefDescription "History" `
    -LongDescription "Show Command History" `
    -ScriptBlock {
    $Pattern = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$Pattern, [ref]$null)
    if ($Pattern) {
        $Pattern = [Regex]::Escape($Pattern)
    }

    $History = [System.Collections.ArrayList]@(
        $Last = ''
        $Lines = ''
        foreach ($Line in [System.IO.FilePath]::ReadLines((Get-PSReadLineOption).HistorySavePath)) {
            if ($Line.EndsWith('`')) {
                $Line = $Line.Substring(0, $Line.Length - 1)
                $Lines = if ($Lines) {
                    "$Lines`n$Line"
                }
                else {
                    $Line
                }
                continue
            }

            if ($Lines) {
                $Line = "$Lines`n$Line"
                $Lines = ''
            }

            if (($Line -cne $Last) -and (-not ($Pattern -or ($Line -match $Pattern)))) {
                $Last = $Line
                $Line
            }
        }
    )
    $History.Reverse()

    $Command = $History | Out-GridView -Title History -PassThru
    if ($Command) {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert(($Command -join "`n"))
    }
}


########################################################################
#                            Winget Aliases                            #
########################################################################


function Use-WingetUpgradeAllRemoveGeneratedShortcuts {
    $DesktopPath = "${HOME}\Desktop"
    $PreUpgrade = Get-ChildItem -Path $DesktopPath -Include "*.lnk", "*.url" -File -Recurse

    winget upgrade --all

    $PostUpgrade = Get-ChildItem -Path $DesktopPath -Include "*.lnk", "*.url" -File -Recurse

    $DesktopShortcutsToDelete = $PostUpgrade | `
        Where-Object { $PreUpgrade -NotContains $_ }

    $DesktopShortcutsToDelete | ForEach-Object { Remove-Item $_ }
    
    if ($null -ne $DesktopShortcutsToDelete) {
        $PostDeletion = Get-ChildItem -Path $DesktopPath -Include "*.lnk", "*.url" -File -Recurse
        if ($PreUpgrade -eq $PostDeletion) { Write-Host "Deleted newly generated shortcuts successfully" -ForegroundColor "Green" }
        else { Write-Host "Could not delete all newly generated shortcuts" -ForegroundColor "Red" }
    }
}
Set-Alias -Name "winget-ua" -Value "Use-WingetUpgradeAllRemoveGeneratedShortcuts"

# Registers argument completer
# src: https://github.com/microsoft/winget-cli/blob/master/doc/Completion.md
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
    $Local:word = $wordToComplete.Replace('"', '""')
    $Local:ast = $commandAst.ToString().Replace('"', '""')
    winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}


########################################################################
#                              Oh My Posh                              #
########################################################################


oh-my-posh init pwsh --config "${env:POSH_THEMES_PATH}\powerlevel10k_classic.omp.json" | Invoke-Expression
