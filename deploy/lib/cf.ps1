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
        switch ($action) {
            "deploy"
            {
                aws cloudformation validate-template --template-body $this.Template
                aws cloudformation describe-stacks --stack-name $this.StackName
                if ($?)
                {
                    $o = (aws cloudformation update-stack --template-body $this.Template --stack-name $this.StackName --parameters $parameters 2>&1)
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
                    aws cloudformation create-stack --template-body $this.Template --stack-name $this.StackName --parameters $parameters
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
}
