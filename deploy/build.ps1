param([String] $version)

$currentPath=$PSScriptRoot
. $currentPath/lib/cf.ps1

$repo = [Stack]::GetExport("DockerWorkshopRepository")
$image = "${repo}:${version}"

docker build --build-arg SERVICE_VERSION=${version} -t $image .

Invoke-Expression -Command (aws ecr get-login --no-include-email --region eu-west-1)
docker push $image