@{
    PSDependOptions  = @{
        Target = 'CurrentUser'
    }

    BuildHelpers     = 'latest'
    Pester           = @{
        Version    = 'latest'
        Parameters = @{
            SkipPublisherCheck = $true
        }
    }
    platyPS          = 'latest'
    psake            = 'latest'
    #InvokeBuild      = 'latest'
    PSScriptAnalyzer = 'latest'
    PWBuild          = @{
        Parameters = @{
            Repository = 'LocalRepo'
        }
    }
}
