param(
    $Password,
    $KeyID
)
$Token=yc iam create-token
function Get-KMSEncrypted($Token, $Body, $KeyID) {
    $StringBytes = [System.Text.Encoding]::Unicode.GetBytes($Body)
    $EncodedString =[Convert]::ToBase64String($StringBytes)
    $Body_json = "{'plaintext': '$EncodedString'}"
    $Headers = @{"Authorization" = "Bearer $Token"}
    $Uri = "https://kms.yandex/kms/v1/keys/"+$KeyID+":encrypt"
    $Respose = Invoke-RestMethod `
        -Headers $Headers `
        -ContentType "application/json" `
        -Uri $Uri `
        -Body $Body_json `
        -Method Post     
    return $Respose.ciphertext
}


$EncryptedPassword = Get-KMSEncrypted -Token $Token -Body $Password -KeyID $KeyID

Write-Host $EncryptedPassword
