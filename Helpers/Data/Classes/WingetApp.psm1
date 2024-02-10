class WingetApp {
    [string]$Name
    [bool]$Install
    [hashtable]$Sources
    [string]$SelectedSource

    WingetApp(
        [string]$Name,
        [hashtable]$Sources
    ) {
        $this.Name = $Name
        $this.Sources = $Sources
    }

    # [string] GetName() {
    #     return $this.Name
    # }

    # [string] GetInstall() {
    #     return $this.Install
    # }

    # [string] GetSources() {
    #     return $this.Sources
    # }

    # [void] SetInstall([bool]$Boolean) {
    #     $this.Install = $Boolean
    # }

    # [void] SetSelectedSource([bool]$Source) {
    #     $this.SelectedSource = $Source
    # }
}
