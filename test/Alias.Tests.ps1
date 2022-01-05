#Requires -Modules BuildHelpers, Pester

[System.Diagnostics.CodeAnalysis.SuppressMessage(
    'PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule'
)]
$SuppressImportModule = $false
. $PSScriptRoot\Shared.ps1

$ModuleInfo = Get-Module $ModuleName

$ExportedAlias = foreach ($alias in $ModuleInfo.ExportedAliases.Values) {
    @{
        Name = $alias.Name
    }
}

if ($ExportedAlias) {
    Describe "Testing exported aliases for module $ModuleName" -Tags @('MetaTest') {
        BeforeEach {
            $aliasToTest = Get-Alias $name -ErrorAction SilentlyContinue
        }
        It "Alias should exist: <Name>" -TestCases $ExportedAlias {
            $aliasToTest | Should -Not -BeNullOrEmpty
        }

        It "Alias should have exported name: <Name>" -TestCases $ExportedAlias {
            $aliasToTest.Name | Should -Be $Name
        }

        It "Alias should have value: <Name>" -TestCases $ExportedAlias {
            $aliasToTest.ResolvedCommandName -or $aliasToTest.Definition | Should -Be $True
        }
    }
} else {
    $scriptName = Split-Path -Path $PSScriptRoot -Leaf
    Write-Warning -Message ("{0}: Module {1} ({2}) does not export any aliases." -f $scriptName, $ModuleInfo.Name, $ModuleInfo.Version)
}
