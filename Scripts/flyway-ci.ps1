<#
  Runs one Flyway command in a pipeline, for .github/workflows/flyway.yml and
  AzureDevOps/flyway-pipeline.yml. Usage: .\Scripts\flyway-ci.ps1 migrate -environment=Test

  SQL logins: if DB_USERNAME is set, it adds DB_USERNAME and DB_PASSWORD for the
  target environment and for the Check and Build scratch environments.
  Windows authentication: leave DB_USERNAME unset.
  Fails the pipeline step if Flyway fails.
#>
$auth = @()
$user = $env:DB_USERNAME
# Azure DevOps leaves an undefined variable as the literal text '$(NAME)'
if ($user -and $user -notlike '$(*') {
    $auth += "-user=$user", "-password=$env:DB_PASSWORD"
    foreach ($name in 'Check', 'Build') {
        $auth += "-environments.$name.user=$user", "-environments.$name.password=$env:DB_PASSWORD"
    }
}

Write-Host "flyway $($args -join ' ')"
& flyway @args @auth
if ($LASTEXITCODE -ne 0) { throw "Flyway failed with exit code $LASTEXITCODE." }
