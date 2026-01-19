$dropLocation = "C:\temp\wazuh_agent"
$Posh5ScriptUrl = "https://raw.githubusercontent.com/ggarcia-tn/Wazuh_Win_Agent/refs/heads/main/Agent_setupPS5.ps1"
$Posh7ScriptUrl = "https://raw.githubusercontent.com/ggarcia-tn/Wazuh_Win_Agent/refs/heads/main/Agent_setupPS7.ps1"

if($PSVersionTable.PSVersion.Major -eq 5){
Curl -o $dropLocation\sysmon.zip -s -uri $Posh5ScriptUrl
}
elseif($PSVersionTable.PSVersion.Major -eq 7){
Curl -o $dropLocation\sysmon.zip -s -uri $Posh7ScriptUrl
}
else{
Write-Host "Unable to determine PowerShell version. Exiting script."
}