class Stack
{
    hidden [String] $Template
    hidden [String] $StackName

    Stack([String] $template, [String] $stackName)
    {
        $this.Template = $template
        $this.StackName = $stackName
    }

    Invoke([String] $action, $parameters)
    {
        $capabilities = $("CAPABILITY_IAM")

        switch ($action) {
            "deploy"
            {
                aws cloudformation validate-template --template-body $this.Template
                aws cloudformation describe-stacks --stack-name $this.StackName
                if ($?)
                {
                    $o = (aws cloudformation update-stack --template-body $this.Template --stack-name $this.StackName --capabilities $capabilities --parameters $parameters 2>&1)
                    if ($o -match "No updates")
                    {
                        Write-Host "Already up to date"
                    }
                    else
                    {
                         aws cloudformation wait stack-update-complete --stack-name $this.StackName
                    }
                }
                else
                {
                    aws cloudformation create-stack --template-body $this.Template --stack-name $this.StackName --capabilities $capabilities --parameters $parameters
                    aws cloudformation wait stack-create-complete --stack-name $this.StackName
                }
            }

            "delete"
            {
                aws cloudformation delete-stack --stack-name $this.StackName
                aws cloudformation wait stack-delete-complete --stack-name $this.StackName
            }

            "verify"
            {
                aws cloudformation validate-template --template-body $this.Template
            }
        }
    }

    static [String] GetExport([String] $name)
    {
        $object = aws cloudformation list-exports | ConvertFrom-Json | select -expand exports | select name, value | where name -eq $name | select value
        return $object.value
    }

    static [String[]] DefaultSubnets()
    {
        $object = aws ec2 describe-subnets  | ConvertFrom-Json | select -expand Subnets | Select SubnetId
        return $object.SubnetId
    }

    static [String] DefaultVpc()
    {
        $object = aws ec2 describe-vpcs | ConvertFrom-Json | select -expand Vpcs | Select -First 1 | Select VpcId
        return $object.VpcId
    }
}

class ECR {
    static Login()
    {
        Invoke-Expression -Command (aws ecr get-login --no-include-email --region eu-west-1)
    }

    static [String] DockerName([String] $export, [String] $version)
    {
        $repo = [Stack]::GetExport($export)
        return "${repo}:${version}"
    }

    static [String] DockerWorkshopRepository([String] $version)
    {
        return [ECR]::DockerName("DockerWorkshopRepository", $version)
    }
}