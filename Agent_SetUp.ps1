Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Step {
    param([Parameter(Manadatory)][string]$Message)
    Write-Host "$Message" -ForegroundColor Cyan
}

function Download-File {
    param(
        [Parameter(Manadatory)][string]$Url,
        [Parameter(Manadatory)][string]$OutFile
    )

    Step "Downloading: $([System.IO.Path]::GetFileName($OutFile))"

    # Try native Powershell first (works in PS5 + PS7)
    try {
        # -UseBasicParsing is required in Powershell 5.1, ignored/removed in PS7
        Invoke-WebRequest -uri $Url -OutFile $OutFile -UseBasicParsing -ErrorAction Stop
        return
    }
    catch {
        # Fallback to the real curl if present (helps in environments where IWR is restricted)
        $curl = Get-Command curl.exe -ErrorAction SilentlyContinue
        if ($null -ne $curl) {
            curl.exe -L -sS -f -o "$OutFile" "$Url"
            if ($LASTEXITCODE -ne 0) {
                throw "curl.exe failed downloading $Url (exit code $LASTEXITCODE)"
            }
            return
        }
        throw "Failed downloading $Url, $($_.Exception.Message)"
    }
}

# =========================
# Variables
# =========================
$dropLocation = "C:\temp\wazuh_agent"
$sysmonUrl = "https://download.sysinterals.com/files/Sysmon.zip"
$sysmonConfig = "https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml"
$sysmonZIP = Join-Path $dropLocation "Sysmon.zip"
$sysmonXML = Join-Path $dropLocation "sysmon.xml"

# =========================
# Setup
# =========================
Step "Preparing set up folder"
New-Item -Path $dropLocation -Itemtype Directory -Force | Out-Null

Step "Starting setup"

# =========================
# Download components
# =========================
Download-File -Url $sysmonUrl -OutFile $sysmonZIP
Download-File -Url $sysmonConfig -OutFile $sysmonXML

# =========================
# Expand Sysmon
# =========================
Step "Expanding Sysmon.zip"
Expand-Archive -LiteralPath $sysmonZIP -DestinationPath $dropLocation -Force

# Locate Sysmon Exe from extracted contents
$sysmonexe = Get-ChildItem -Path $dropLocation -Filter "Sysmon64.exe" -Recurse -File -ErrorAction SilentlyContinue | Select Object -First 1

if (-not $sysmonexe) {
    throw "Sysmon 64.exe is not found after extraction in $dropLocation"
}

# =========================
# Install Sysmon
# =========================
Step "Installing Sysmon (accepting Eula + applying config)"
& $sysmonexe.FullName -accepteula -i $sysmonXML

Step "Agent setup Complete"