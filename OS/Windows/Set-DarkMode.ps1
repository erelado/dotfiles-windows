function Set-DarkMode {

    <#
    .SYNOPSIS
    Updates the theme (color and cursor) to 'dark'.

    .INPUTS
    None. You cannot pipe objects to Set-DarkMode.

    .OUTPUTS
    None.
    #>

    Write-Host "Changing colors to dark mode:" -ForegroundColor "Yellow"

    # Enable dark theme
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" `
        -Name "AppsUseLightTheme" -Value 0 -Type "Dword"

    Write-Host "Theme update: $TRUE"

    # Enable dark cursor
    Set-DarkCursor

    Write-Host "Dark mode has been successfully updated.`n" -ForegroundColor "Green"
}

function Set-DarkCursor {
    <#
    .SYNOPSIS
    Updates the cursor to 'dark'.

    .INPUTS
    None. You cannot pipe objects to Set-DarkCursor.

    .OUTPUTS
    None.
    #>

    # Registry
    $RegConnect = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]"CurrentUser", "${env:COMPUTERNAME}")

    $RegCursors = $RegConnect.OpenSubKey("Control Panel\Cursors", $TRUE)
    $RegCursors.SetValue("", "Windows Black")
    $RegCursors.SetValue("AppStarting", "%SystemRoot%\cursors\wait_r.cur")
    $RegCursors.SetValue("Arrow", "%SystemRoot%\cursors\arrow_r.cur")
    $RegCursors.SetValue("Crosshair", "%SystemRoot%\cursors\cross_r.cur")
    $RegCursors.SetValue("Hand", "")
    $RegCursors.SetValue("Help", "%SystemRoot%\cursors\help_r.cur")
    $RegCursors.SetValue("IBeam", "%SystemRoot%\cursors\beam_r.cur")
    $RegCursors.SetValue("No", "%SystemRoot%\cursors\no_r.cur")
    $RegCursors.SetValue("NWPen", "%SystemRoot%\cursors\pen_r.cur")
    $RegCursors.SetValue("SizeAll", "%SystemRoot%\cursors\move_r.cur")
    $RegCursors.SetValue("SizeNESW", "%SystemRoot%\cursors\size1_r.cur")
    $RegCursors.SetValue("SizeNS", "%SystemRoot%\cursors\size4_r.cur")
    $RegCursors.SetValue("SizeNWSE", "%SystemRoot%\cursors\size2_r.cur")
    $RegCursors.SetValue("SizeWE", "%SystemRoot%\cursors\size3_r.cur")
    $RegCursors.SetValue("UpArrow", "%SystemRoot%\cursors\up_r.cur")
    $RegCursors.SetValue("Wait", "%SystemRoot%\cursors\busy_r.cur")
    $RegCursors.Close()
    $RegConnect.Close()

    # Update using WinAPICall
    $CSharpSig = @'
[DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
public static extern bool SystemParametersInfo(
    uint uiAction,
    uint uiParam,
    uint pvParam,
    uint fWinIni);
'@
    $CursorRefresh = Add-Type -MemberDefinition $CSharpSig -Name WinAPICall -Namespace SystemParamInfo -PassThru
    Write-Host "Cursor update: $($CursorRefresh::SystemParametersInfo(0x0057, 0, $null, 0))"
}
