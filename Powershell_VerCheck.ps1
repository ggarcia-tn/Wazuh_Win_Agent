$dropLocation = "C:\temp\wazuh_agent"
$Posh5ScriptUrl = 
$Posh7ScriptUrl = 

if($PSVersionTable.PSVersion.Major -eq 5){
Curl -o $dropLocation\sysmon.zip -s -uri $Posh5ScriptUrl
}
elseif($PSVersionTable.PSVersion.Major -eq 7){
Curl -o $dropLocation\sysmon.zip -s -uri $Posh7ScriptUrl
}
else{
Write-Host "Unable to determine PowerShell version. Exiting script."
}