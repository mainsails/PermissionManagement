Function Test-PSCredential {
    <#
    .SYNOPSIS
        Takes a PSCredential object and validates it
    .DESCRIPTION
        Takes a PSCredential object and validates it against a domain or local machine
    .PARAMETER Credential
        A PScredential object with the username/password you wish to test. Typically this is generated using the Get-Credential cmdlet
    .PARAMETER Context
        An optional parameter specifying what type of credential this is. Possible values are 'Domain' and 'Machine'. The default is 'Domain'
    .PARAMETER ComputerName
        If Context is machine, test the credential against this computer
    .PARAMETER Domain
        If context is 'Domain' (default), test the credential against this domain
    .OUTPUTS
        System.Boolean
    .EXAMPLE
        Test-PSCredential -Credential $(Get-Credential)
        Test credential for an active directory account
    .EXAMPLE
        Test-PSCredential -ComputerName Computer1 -Credential $Cred
        Test credential for a local account
    .EXAMPLE
        Test-PSCredential -Credential $Cred -Domain DOMAIN
        Test credential for an active directory account on 'DOMAIN'
    #>

    [CmdletBinding(DefaultParameterSetName = 'Domain')]
    Param(
        [Parameter(ValueFromPipeline=$true)]
        [System.Management.Automation.PSCredential]$Credential = $(Get-Credential),
        [ValidateSet('Domain','Machine')]
        [string]$Context = 'Domain',
        [Parameter(ParameterSetName = 'Machine')]
        [string]$ComputerName,
        [Parameter(ParameterSetName = 'Domain')]
        [string]$Domain = $null
    )

    Begin {
        Try   {
            Add-Type -AssemblyName System.DirectoryServices.AccountManagement
        }
        Catch {
            Throw
        }

        # Create principal context
        If ($PSCmdlet.ParameterSetName -eq 'Domain') {
            $Context = $PSCmdlet.ParameterSetName
            $PC = New-Object -TypeName System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::$Context,$Domain)
        }
        If ($PSCmdlet.ParameterSetName -eq 'Machine') {
            $Context = $PSCmdlet.ParameterSetName
            $PC = New-Object -TypeName System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::$Context,$ComputerName)
        }
    }
    Process {
        # Validate provided credential
        $PC.ValidateCredentials($Credential.UserName,$Credential.GetNetworkCredential().Password)
    }
    End {
        $PC.Dispose()
    }
}