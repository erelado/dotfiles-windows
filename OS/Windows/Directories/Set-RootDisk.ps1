function Set-RootDisk {
    param ()
    
    <#
    .SYNOPSIS
    Sets the location required by the user for their created directory, 
    which will be installed later.

    .DESCRIPTION
    Sets the root disk as one of the given options for the user.
    The options to select from are PSProvider of type "FileSystem" on the 
    local machine.

    .INPUTS
    None. You cannot pipe objects to function Set-RootDisk.

    .OUTPUTS
    System.String. Set-RootDisk returns a string of the required disk.
    #>

    $ValidDisks = Get-PSDrive -PSProvider "FileSystem" | Select-Object -ExpandProperty "Root"
    return Select-FromArrayOptions -Array $ValidDisks
}
