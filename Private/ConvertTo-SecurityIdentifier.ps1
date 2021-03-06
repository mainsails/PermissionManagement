Function ConvertTo-SecurityIdentifier {
    <#
    .SYNOPSIS
        Converts a string or byte array security identifier into a 'System.Security.Principal.SecurityIdentifier' object
    .DESCRIPTION
        'ConvertTo-SecurityIdentifier' converts a SID in SDDL form (as a string), in binary form (as a byte array) into a 'System.Security.Principal.SecurityIdentifier' object
        It also accepts 'System.Security.Principal.SecurityIdentifier' objects, and returns them back to you
        If the string or byte array don't represent a SID, an error is written and nothing is returned
    .PARAMETER SID
        The SID to convert to a 'System.Security.Principal.SecurityIdentifier'
        Accepts a SID in SDDL form as a 'string', a 'System.Security.Principal.SecurityIdentifier' object or a SID in binary form as an array of bytes
    .EXAMPLE
        ConvertTo-SecurityIdentifier -SID 'S-1-5-32-544'
        Demonstrates how to convert a SID in SDDL form into a 'System.Security.Principal.SecurityIdentifier' object
    .EXAMPLE
        ConvertTo-SecurityIdentifier -SID (New-Object 'Security.Principal.SecurityIdentifier' 'S-1-5-32-544')
        Demonstrates that you can pass a 'SecurityIdentifier' object as the value of the SID parameter
        The SID you passed in will be returned to you unchanged
    .EXAMPLE
        ConvertTo-SecurityIdentifier -SID $SIDBytes
        Demonstrates that you can use a byte array that represents a SID as the value of the 'SID' parameter.
    .LINK
        Resolve-Identity
    .LINK
        Resolve-IdentityName
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        $SID
    )

    Try {
        If ($SID -is [string]) {
            New-Object -TypeName 'Security.Principal.SecurityIdentifier' $SID
        }
        Elseif ($SID -is [byte[]]) {
            New-Object -TypeName 'Security.Principal.SecurityIdentifier' $SID,0
        }
        Elseif ($SID -is [Security.Principal.SecurityIdentifier]) {
            $SID
        }
        Else {
            Write-Error -Message ('Invalid SID. The `SID` parameter accepts a `System.Security.Principal.SecurityIdentifier` object, a SID in SDDL form as a `string`, or a SID in binary form as byte array. You passed a ''{0}''.' -f $SID.GetType())
            return
        }
    }
    Catch {
        Write-Error -Message ('Exception converting SID parameter to a `SecurityIdentifier` object. This usually means you passed an invalid SID in SDDL form (as a string) or an invalid SID in binary form (as a byte array): {0}' -f $_.Exception.Message)
        return
    }
}