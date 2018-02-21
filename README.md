docker-workshop
================

This is a template of a service working with ECR/ECS and docker, ready for playing in a workshop.

Requirements
------------

All scripts are written in Powershell and using the AWS CLI, so you will need to install it:

### OSX
```bash
brew tap caskroom/cask
brew cask install powershell
``` 

### Linux Distros

Follow the instructions in the Powershell official repo:

https://github.com/PowerShell/PowerShell/blob/master/docs/installation/linux.md

How To Deploy
--------------

Run those scripts in sequence:

```powershell
./deploy/prepare-environment.ps1
./deploy/build.ps1 "1"
./deploy/deploy.ps1 "1"
```

The number "1" is the version of the docker that you are going to use.

If you want to run a version of a Docker, you can use:

```powershell
./deploy/run-version.ps1 "1"
```

Troubleshooting
---------------

### I can't use those scripts because the AWS CLI says I don't have permissions

Check the ~/.aws/credentials and ~/.aws/config files. You will need to set up a profile there. If you are
not using the default profile ([default] section in those files) you will need to overwrite the AWS_PROFILE
envvar like this:

```powershell
$env:AWS_PROFILE="<your profile name>"
```