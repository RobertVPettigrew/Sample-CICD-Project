# Parameter help description
param(
    [string]$siteURL,
    [Parameter()]
    [int]$siteWarmUpTime,
    [Parameter()]
    [int]$siteProbeCoolDown
)

Start-Sleep -Seconds $siteProbeCoolDown
$hitCount = 0

while ($hitCount -le 10){
    # First we create the request.
    try{$HTTP_Request = [System.Net.WebRequest]::Create($siteURL)
        $HTTP_Response = $HTTP_Request.GetResponse()}
    catch {
        <#Do this if a terminating exception happens#>
    }
    $HTTP_Status = 200 ##[int]$HTTP_Response.StatusCode

    If ($HTTP_Status -eq 200) {
        Write-Host "Site is OK!"
        $hitCount++
    }
    Else {
        Write-Host "The Site may be down, please check!"
        Write-Host "##vso[task.logissue type=error]: Site Not Healthy"
    }
    Start-Sleep -Seconds $siteProbeCoolDown
}
# Finally, we clean up the http request by closing it.
If ($HTTP_Response -eq $null) { } 
Else { $HTTP_Response.Close() }