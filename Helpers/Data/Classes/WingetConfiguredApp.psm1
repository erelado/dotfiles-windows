Using module .\WingetApp.psm1

class WingetConfiguredApp : WingetApp {
    [hashtable]$Configurations

    WingetConfiguredApp(
        [string]$Name,
        [hashtable]$Sources,
        [hashtable]$Configurations
    ) : base($Name, $Sources) {
        $this.Configurations = $Configurations
    }

    # [string] GetName() {
    #     return ([BaseClass]$this).Name
    # }

    # [string] GetConfigurations() {
    #     return $this.Configurations
    # }

    # [void] SetConfigurations([hashtable]$Configurations) {
    #     $this.Configurations = $Configurations
    # }


}
