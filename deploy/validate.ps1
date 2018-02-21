param([String] $version)

. $PSScriptRoot/lib/cf.ps1

[ECR]::Login()

$image = [ECR]::DockerWorkshopRepository($version)

docker run -it $image ./gradlew check