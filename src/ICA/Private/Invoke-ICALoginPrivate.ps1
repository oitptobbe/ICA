function Invoke-ICALoginPrivate {
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
        $credentialPair = "$($credential.UserName):$($credential.GetNetworkCredential().Password)"
        $base64 = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($credentialPair))
        $properties = @{
            Uri                     = "https://handla.api.ica.se/api/login"
            headers                 = @{
                "Authorization" = "Basic $base64"
            }
            Method                  = "GET"
            ResponseHeadersVariable = "resheaders"
        }
        if ($null -ne $proxy -and $proxy.Length -gt 0) {
            $properties.Add("Proxy", $proxy)
        }
        if ($null -ne $ProxyCredential -and $ProxyCredential.UserName.Length -gt 0) {
            $properties.Add("ProxyCredential", $ProxyCredential)
        }
        $icadata = Invoke-RestMethod @properties
        if ($null -ne $icadata -and [string]::IsNullOrEmpty($resheaders.AuthenticationTicket)) {
            $Script:AuthenticationTicket = $resheaders.AuthenticationTicket
        }
        Write-Debug -Message "Auth Ticket is $($resheaders.AuthenticationTicket)"
    }

    end {
        $Script:AuthenticationTicket = $resheaders.AuthenticationTicket
    }
}