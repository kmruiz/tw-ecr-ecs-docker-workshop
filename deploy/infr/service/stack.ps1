param([String] $action, [String] $version="0.0.1-SNAPSHOT")

$currentPath=$PSScriptRoot

. $currentPath/../../lib/cf.ps1

$service = "dockerworkshop"
$ServiceName = (Get-Culture).textinfo.totitlecase($service.tolower()).replace("-", "")
$ImageName = $service
$DockerVersion = "$version"
$DesiredCount = 2

$P = $(
"ParameterKey=ServiceName,ParameterValue=$ServiceName",
"ParameterKey=DockerVersion,ParameterValue=$DockerVersion",
"ParameterKey=DesiredCount,ParameterValue=$DesiredCount"
)

$stack = [Stack]::new("file://$currentPath/service.yaml", "docker-workshop-task")
$stack.Invoke($action, $P)
