param([String] $version)

. $PSScriptRoot/lib/cf.ps1

. $PSScriptRoot/infr/service/stack.ps1 "deploy" $version
