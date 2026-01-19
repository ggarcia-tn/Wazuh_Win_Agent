$dropLocation = "C:\temp\wazuh_agent"
$Posh5ScriptUrl = "https://github.com/ggarcia-tn/Wazuh_Win_Agent/blob/59854d5883dee7e39b067a94c90d91dc4a4550c7/Agent_setupPS5.ps1"
$Posh7ScriptUrl = "https://github.com/ggarcia-tn/Wazuh_Win_Agent/blob/59854d5883dee7e39b067a94c90d91dc4a4550c7/Agent_setupPS7.ps1"

if($PSVersionTable.PSVersion.Major -eq 5){
Curl -o $dropLocation\sysmon.zip -s -uri $Posh5ScriptUrl
}
elseif($PSVersionTable.PSVersion.Major -eq 7){
Curl -o $dropLocation\sysmon.zip -s -uri $Posh7ScriptUrl
}
else{
Write-Host "Unable to determine PowerShell version. Exiting script."
}