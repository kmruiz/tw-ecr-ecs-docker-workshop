param([String] $action)

$currentPath=$PSScriptRoot
. $PSScriptRoot/../../lib/cf.ps1

$stack = [Stack]::new("file://$currentPath/ecs.yaml", "docker-workshop-ecs")
$subnets = [Stack]::DefaultSubnets() -join ","
$vpc = [Stack]::DefaultVpc()

$P = $(
"ParameterKey=Subnets,ParameterValue='$subnets'"
"ParameterKey=Vpc,ParameterValue=$vpc"
)

$stack.Invoke($action, $P)
