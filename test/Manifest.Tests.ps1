#Requires -Modules BuildHelpers, Pester

[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
$SuppressImportModule = $true
. $PSScriptRoot\Shared.ps1

$manifestData = Import-PowerShellDataFile -Path $manifestPath

Describe "Module $moduleName" -Tags @('MetaTest') {
    BeforeAll {
        . $PSScriptRoot\Shared.ps1
        #$manifestContent = Import-PowerShellDataFile -Path $manifestPath
        $manifest = Test-ModuleManifest -Path $manifestPath -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }
    Context 'Manifest file' {
        It 'is a valid manifest' {
            {
                $null = Test-ModuleManifest -Path $manifestPath -Verbose:$false -ErrorAction Stop -WarningAction SilentlyContinue
            } | Should -Not -Throw
        }

        Context 'Required by Publish-Module' {
            It 'has a valid author' {
                $manifest.Author | Should -Not -BeNullOrEmpty
            }
            It 'has a valid description' {
                $manifest.Description | Should -Not -BeNullOrEmpty
            }
        }
        It 'has a valid name in the manifest' {
            $manifest.Name | Should -Be $moduleName
        }

        It 'has a valid root module' {
            $manifest.RootModule | Should -Be ('{0}.psm1' -f $moduleName)
        }

        It 'has valid root module for PowerShell 2.0' -Skip:($manifest.PowerShellVersion.Major -ne 2) {
            $manifestContent = Import-PowerShellDataFile -Path $manifestPath
            $manifestContent.ModuleToProcess | Should -Not -BeNullOrEmpty
        }

        It 'has a valid guid' {
            {
                [guid]::Parse($manifest.Guid)
            } | Should -Not -Throw
        }

        It 'has a valid copyright' {
            $manifest.CopyRight | Should -Not -BeNullOrEmpty
        }

        # Only for DSC modules
        # It 'exports DSC resources' {
        #     $dscResources = $Manifest.ExportedDscResources
        #     @($dscResources).Count | Should -Not -Be 0
        # }

        Context 'Manifest version' -Tag Version {
            It 'has a valid version in the manifest' {
                $manifest.Version <# -as [Version] #> | Should -Not -BeNullOrEmpty
            }
            It 'version follows SemVer guidelines' {
                $manifest.Version.Revision |
                    Should -Be -1 -Because 'module should follow SemVer guidelines'
            }
            It "Prerelease tag follows PSGallery requirements" -Skip:(
                $manifestData.PrivateData.PSData.Keys -notcontains 'Prerelease'
            ) {
                $manifestContent = Import-PowerShellDataFile -Path $manifestPath
                $manifestContent.PrivateData.PSData.Prerelease -match '-?[0-9A-Za-z]+' |
                    Should -Be $true -Because 'PSGallery supports only SemVer v1.0 prerelease strings'
            }
        }

        Context 'URLs included' {
            It "LicenseUri is proper URI" -Skip:($manifestData.PrivateData.PSData.Keys -notcontains 'LicenseUri') {
                $uri = $manifest.LicenseUri
                $uri | Should -Not -BeNullOrEmpty
            }
            It "ProjectUri is proper URI" -Skip:($manifestData.PrivateData.PSData.Keys -notcontains 'ProjectUri') {
                $uri = $manifest.ProjectUri
                $uri | Should -Not -BeNullOrEmpty
            }
        }
        Context 'Tags' -Tag Tags {
            $taglist = foreach ($tag in $manifestData.PrivateData.PSData.Tags) {
                @{ tag = $tag }
            }
            if ($taglist) {
                It '"<tag>" should have no spaces in name' -TestCases $tagList {
                    param ($tag)
                    $tag -match ' ' | Should -Be $false
                }
            }

            It "has at least one edition tag" {
                ($manifest.Tags | Select-Object -Unique) -match '^PSEdition_' |
                    Should -Not -BeNullOrEmpty
            }
            It "has at least one OS compatibility tag" {
                ($manifest.Tags | Select-Object -Unique) -match '^(Windows|Linux|MacOS)$' |
                    Should -Not -BeNullOrEmpty -Because 'Every module should be compatible with at least one OS'
            }
        }

        Context 'ChangeLog compared to manifest' -Tag ChangeLog {
            BeforeAll {
                $projectRoot = Split-Path -Path $PSScriptRoot -Parent
                $changelogPath = Join-Path -Path $projectRoot -ChildPath 'CHANGELOG.md'

                $changelogVersion = $null
                foreach ($line in (Get-Content $changelogPath)) {
                    if ($line -match "^## \[(?<Version>(\d+\.){1,2}\d+)\] \d{4}(-\d{2}){2}") {
                        $changelogVersion = $matches.Version
                        break
                    }
                }
            }
            It 'has a valid version in the changelog' {
                $changelogVersion               | Should -Not -BeNullOrEmpty
                $changelogVersion -as [Version] | Should -Not -BeNullOrEmpty
            }
            It 'changelog and manifest versions are the same' {
                $changelogVersion -as [Version] | Should -Be $manifest.Version
            }
            <# if (Get-Command git.exe -ErrorAction SilentlyContinue) {
                $script:tagVersion = $null
                It 'is tagged with a valid version' -Skip {
                    $thisCommit = git.exe log --decorate --oneline HEAD~1..HEAD

                    if ($thisCommit -match 'tag:\s*v?(\d+(?:\.\d+)*)') {
                        $tagVersion = $matches[1]
                    }

                    $tagVersion               | Should -Not -BeNullOrEmpty
                    $tagVersion -as [Version] | Should -Not -BeNullOrEmpty
                }

                It 'manifest and tagged version are the same' -Skip {
                    $script:manifest.Version -as [Version] | Should -Be ( $script:tagVersion -as [Version] )
                }
            } #>
        }
    }

    Context "Individual file validation" {
        BeforeAll {
            $moduleRoot = Split-Path $manifestPath -Parent
        }
        It "The root module file exists" {
            $RootModulePath = Join-Path -Path $moduleRoot -ChildPath $manifest.RootModule
            Test-Path -Path $RootModulePath | Should -Be $true
        }

        $formatList = foreach ($file in $manifestData.FormatsToProcess) {
            @{
                name = $file
            }
        }
        if ($formatList) {
            It "The format file <name> should exist" -TestCases $formatList {
                $formatPath = Join-Path -Path $moduleRoot -ChildPath $name
                Test-Path $formatPath | Should -Be $true
            }
        }

        $typeList = foreach ($file in $manifestData.TypesToProcess) {
            @{
                name = $file
            }
        }
        if ($typeList) {
            It "The type file <name> should exist" -TestCases $typeList {
                $typePath = Join-Path -Path $moduleRoot -ChildPath $name
                Test-Path $typePath | Should -Be $true
            }
        }

        $AssemblyFile = $manifestData.RequiredAssemblies |
            Where-Object { $_ -like "*.dll"} |
            ForEach-Object {
                @{
                    name = $_
                }
            }
        if ($AssemblyFile) {
            It "The assembly file <name> should exist" -TestCases $assemblyList {
                $assemblyPath = Join-Path -Path $moduleRoot -ChildPath $name
                Test-Path $assemblyPath | Should -Be $true
            }
        }
        $assemblyList = $manifestData.RequiredAssemblies |
            Where-Object { $_ -notlike "*.dll"} |
            ForEach-Object {
                @{
                    name = $_
                }
            }
        if ($assemblyList.name) {
            It "The assembly <name> should load from the GAC" -TestCases $assemblyList {
                { Add-Type -AssemblyName $name } | Should -Not -Throw
            }
        }
    }
}
