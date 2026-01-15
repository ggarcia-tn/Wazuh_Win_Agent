# Function that writes the current step
function step { 
    param([string]$Message)
    Write-Host "$Message" -ForegroundColor Cyan
}

# Variables for the download location, sysmon url and sysmon config url
$dropLocation = "C:\temp\wazuh_agent"
$sysmonurl = "https://download.sysinternals.com/files/Sysmon.zip"
$sysmonconfig = "https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/refs/heads/master/sysmonconfig-export.xml"

# Tests if the download location exists
# If not it creates it
if(Test-Path $dropLocation){
    }
else{
    Write-Host "Creating $dropLocation"
    mkdir $dropLocation
}

# Beginning of the set up
Step "Testing Setup..."
Step "Downloading Sysmon"

#Test if the sysmon url is available
Try {
    if ((Invoke-WebRequest $sysmonurl -Method Head -UseBasicParsing).Statuscode -eq 200) {
        Curl -o $dropLocation\sysmon.zip -s -uri $sysmonurl
        Expand-Archive -LiteralPath $dropLocation\sysmon.zip -DestinationPath $dropLocation
    }
}
# If not available, it will output not available
Catch{
    Step "Unable to Download Sysmon"
}

# Downloading of Swift on Security config file
Step "Downloading Sysmon Config"
try {
    if ((Invoke-WebRequest $sysmonconfig -Method Head -UseBasicParsing).Statuscode -eq 200) {
        Curl -o $dropLocation\sysmon.xml -s -uri $sysmonconfig
    }
    
}
# If not available, it will output not available
catch {
    Step "Unable to Download Sysmon Config"
}
# Done downloading components
Step "Done downloading Sysmon"

# Install of sysmon
Step "Installing Sysmon"
sysmon64.exe -accepteula $dropLocation\sysmon.xml

# Announcing successful set up of agent
Step "Agent Set up complete"
break
