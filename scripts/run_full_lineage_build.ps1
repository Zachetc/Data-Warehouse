param(
    [string]$HostName = "localhost",
    [string]$Database = "citypulse",
    [string]$User = "citypulse"
)

Write-Host "Running CityPulse full lineage warehouse build..."
Write-Host "Database: $Database"
Write-Host "Host: $HostName"

psql -h $HostName -U $User -d $Database -f sql/run_citypulse_integrated_build.sql

if ($LASTEXITCODE -eq 0) {
    Write-Host "Build finished successfully."
} else {
    Write-Host "Build failed. Check SQL output above."
    exit $LASTEXITCODE
}
