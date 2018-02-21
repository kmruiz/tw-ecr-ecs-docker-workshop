param([String] $action)

$currentPath=$PSScriptRoot

. $currentPath/../../lib/cf.ps1

$stack = [Stack]::new("file://$currentPath/ecr.yaml", "docker-workshop-ecr")
$stack.Invoke($action, $())
