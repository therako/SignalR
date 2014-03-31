param(
    $environment = "dev",
    $buildNumber = "1.0.0",
    $artifactsDir = "$(pwd)\build"
    )

trap 
{ 
  Write-Error $_ 
  exit 1 
}

$script:scriptDir = split-path $MyInvocation.MyCommand.Path -parent

#Import-Module $script:scriptDir\BuildScripts\YDeliver.psm1
Invoke-YDeploy $environment -buildVersion $buildNumber
