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

Add-Type -AssemblyName PresentationFramework
$curDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$tempCSVFile = $curDir + "\" + "temp.csv"
$tempSortedCSVFile = $curDir + "\" + "temp_sort.csv"
$dnRegex = "^dn:.*"
$linebreak = "`r`n"

# Delete temp and old files
try {
    $ErrorActionPreference = "Stop"
    if (Test-Path $tempCSVFile) {
        Remove-Item -Path $tempCSVFile -Force
    }
    if (Test-Path $tempSortedCSVFile) {
        Remove-Item -Path $tempSortedCSVFile -Force
    }
    if (Test-Path $resultLDAPFile) {
        Remove-Item -Path $resultLDAPFile -Force
    }
} catch {
    [System.Windows.MessageBox]::Show("Deletion Error!")
    exit 1
} finally {
    $ErrorActionPreference = "Continue"
}

# Exit if ldif file is empty
if ((Get-Item $srcLDAPFile).Length -eq 0) {
    [System.Windows.MessageBox]::Show("Source file is empty!")
    exit 0
}

# Convert ldif file to csv file
try {
    $ErrorActionPreference = "Stop"
    Get-Content $srcLDAPFile | ForEach-Object {
        if ($_ -eq "") {
            $line = $line.Substring(0, $line.Length - 1)
            Out-File -FilePath $tempCSVFile -InputObject $line -Encoding default -Append
            $line = ""
        } else {
            $line = $line + '"' + $_ + '"' + ","
        }
    }

    # Output final row
    if ($line -ne "") {
        $line = $line.Substring(0, $line.Length - 1)
        Out-File -FilePath $tempCSVFile -InputObject $line -Encoding default -Append
        $line = ""
    }
} catch {
    [System.Windows.MessageBox]::Show("Conversion to csv Error!")
    exit 1
} finally {
    $ErrorActionPreference = "Continue"
}

# Sort csv file
try{
    $ErrorActionPreference = "Stop"

    if ($order -eq "0") {
        Get-Content $tempCSVFile | Sort-Object { [string]$_.Split(",")[0].Substring(9)} | Out-File -FilePath $tempSortedCSVFile -Encoding default
    } else {
        Get-Content $tempCSVFile | Sort-Object { [string]$_.Split(",")[0].Substring(9)} -Descending | Out-File -FilePath $tempSortedCSVFile -Encoding default
    }
} catch {
    [System.Windows.MessageBox]::Show("Sorting Error!")
    exit 1
} finally {
    $ErrorActionPreference = "Continue"
}

# Convert csv file back to ldif file
try{
    $ErrorActionPreference = "Stop"
    $isFirstRow = $true
    Get-Content $tempSortedCSVFile | ForEach-Object {
        $entryInfo = $_.Split('"').where({ ($_ -ne "") -and ($_ -ne ",") })
        foreach ($info in $entryInfo) {
            if (($info -match $dnRegex) -and ($isFirstRow -eq $true)) {
                $line = $info
                $isFirstRow = $false
            } elseif ($info -match $dnRegex) {
                $line = $linebreak + $info
            } else {
                $line = $info
            }
            Out-File -FilePath $resultLDAPFile -InputObject $line -Encoding default -Append
        }
    }
} catch {
    [System.Windows.MessageBox]::Show("Conversion to ldif Error!")
    exit 1
} finally {
    $ErrorActionPreference = "Continue"
}

[System.Windows.MessageBox]::Show("Sort Complete!")
exit 0