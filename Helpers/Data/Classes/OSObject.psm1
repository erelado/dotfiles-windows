class OSObject {
    [string]$Name
    [hashtable]$Configurations
    [hashtable]$Directories
    [hashtable]$Fonts

    OSObject(
        [string]$Name,
        [hashtable]$Configurations,
        [hashtable]$Directories,
        [hashtable]$Fonts
    ) {
        $this.Name = $Name
        $this.Configurations = $Configurations
        $this.Directories = $Directories
        $this.Fonts = $Fonts
    }

    # [string] GetName() {
    #     return $this.Name
    # }
}
