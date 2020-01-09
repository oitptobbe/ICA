function Get-RecipeCategories {
    [CmdletBinding()]
    param (
        # Possible proxy to use
        [Parameter(Position = 0)]
        [string]
        $Proxy,
        # Possible proxy user to use
        [Parameter(Position = 1)]
        [pscredential]
        $ProxyCredential
    )

    begin {
        if ($null -eq $Script:AuthenticationTicket -or $Script:AuthenticationTicket.Length -eq 0) {
            Throw "You are not logged in yet, run Invoke-ICALogin first"
        }
    }

    process {
        $properties = @{
            Uri                     = "https://handla.api.ica.se/api/recipes/categories/general"
            headers                 = @{
                "AuthenticationTicket" = $Script:AuthenticationTicket
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
        $icadata.Categories
    }

    end {

    }
}