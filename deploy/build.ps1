param([String] $version)

. $PSScriptRoot/lib/cf.ps1

[ECR]::Login()

$image = [ECR]::DockerWorkshopRepository($version)

docker build --build-arg SERVICE_VERSION=$version -t $image .
docker push $image