#ps1
Start-Transcript -Path "$ENV:SystemDrive\Log\bootstrap.txt" -IncludeInvocationHeader -Force

function Get-InstanceMetadata ($SubPath) {
    $Headers = @{"Metadata-Flavor"="Google"}
    $Url = "http://169.254.169.254/computeMetadata/v1/instance" + $SubPath

    return Invoke-RestMethod -Headers $Headers $Url
}

function Get-KMSDecrypted($Body, $KeyID) {
    $Body_json = "{'ciphertext': '$Body'}"
    $Token     = (Get-InstanceMetadata -SubPath "/service-accounts/default/token").access_token
    $Headers   = @{"Authorization" = "Bearer $Token"}
    $Uri       = "https://kms.yandex/kms/v1/keys/"+$KeyID+":decrypt"
    $Respose   = Invoke-RestMethod `
        -Headers $Headers `
        -ContentType "application/json" `
        -Uri $Uri `
        -Body $Body_json `
        -Method Post     
    return [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($Respose.plaintext))
}

"Set Timezone" | Write-Host
Set-TimeZone -Id (Get-InstanceMetadata -SubPath "/attributes/timezone")

"Creating local user" | Write-Host
$KeyID             = Get-InstanceMetadata -SubPath "/attributes/keyid"
$EncryptedPassword = Get-InstanceMetadata -SubPath "/attributes/pass"
$PlainTextPassword = Get-KMSDecrypted -Body $EncryptedPassword -KeyID $KeyID
$Password          = ConvertTo-SecureString $PlainTextPassword -AsPlainText -Force
Set-LocalUser 'Administrator' -Password $Password



"Bootstrap complete" | Write-Host

