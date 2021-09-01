#Requires -RunAsAdministrator
<#
.SYNOPSIS

Bootstrap a Windows Server for Agri-Marché.

.DESCRIPTION

Install chocolatey and some default packages.

.INPUTS

None.

.EXAMPLE

PS> DeploymentScript.ps1

.LINK

https://github.com/agri-marche/windows-arm-template

#>

# To install more packages, simple add them to this array
$Packages = @('edr-sensor', 'bigfix-agent')

# In case chocolatey was installed in a different path, change this variable
$ChocolateyInstallPath = "$env:ProgramData\Chocolatey"


function Install-Chocolatey {
    <#
        .SYNOPSIS
        Install chocolatey.

        .DESCRIPTION
        Set execution policy and install chocolaty using Invoke-Expression and the official installation script
    #>    
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

}

function Install-RequiredPackages {
    <#
        .SYNOPSIS
        Install required chocolatey packages.

        .DESCRIPTION
        Check if chocolatey is installed and then call the Install-Chocolatey function if not.
        Forcefully install all packages in the $Packages array.
    #>  

    If(!(Test-Path -Path $ChocolateyInstallPath)) {
        Install-Chocolatey
    }

    foreach ($PackageName in $Packages) {
        Write-Host("Installing $PackageName")
        choco install -y $PackageName --force
    }

}


Install-RequiredPackages

