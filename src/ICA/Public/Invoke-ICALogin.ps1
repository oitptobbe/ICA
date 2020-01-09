function Invoke-ICALogin {
    [CmdletBinding()]
    param (
        # User credentials to connect to ICA
        [Parameter(Mandatory = $true, Position = 0)]
        [pscredential]
        $credential,
        # Possible proxy to use
        [Parameter(Position = 1)]
        [string]
        $Proxy,
        # Possible proxy user to use
        [Parameter(Position = 2)]
        [pscredential]
        $ProxyCredential
    )

    begin {

    }

    process {

    }

    end {
        Invoke-ICALoginPrivate -credential $credential -proxy $proxy -proxycredential $ProxyCredential
        if ($null -eq $Script:AuthenticationTicket -or $Script:AuthenticationTicket.length -eq 0) {
            Throw "Failed to login to ICA"
        }
        $Global:AuthenticationTicket = $Script:AuthenticationTicket
    }
}