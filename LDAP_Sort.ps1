param (
    [Parameter(Mandatory = $true)]
    [string]
    $srcLDAPFile = $args[0],
    [Parameter(Mandatory = $true)]
    [string]
    $resultLDAPFile = $args[1],
    [Parameter(Mandatory = $true)]
    [string]
    $order = $args[2]
)