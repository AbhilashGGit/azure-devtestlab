Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

$FlexeraZipBLOBURL = 'https://flexeratesting.blob.core.windows.net/testflexeracontainer/VNET-External-BC-FlexeraSetupFiles.zip'

$logFile = "C:\MyTempFolder\VNET-External-BC-FlexeraSetupFiles\Log.log"
$destintionPath = 'C:\MyTempFolder\'
$CompleteFlexeraZipPath = $destintionPath + 'VNET-External-BC-FlexeraSetupFiles.zip'

Write-Host "Checking the destination folder..." -Verbose
if(!(Test-Path $destintionPath -Verbose)){
    Write-Host "Creating the destination folder..." -Verbose
    New-Item -ItemType directory -Path $destintionPath -Force -Verbose
}

Invoke-WebRequest -Uri $FlexeraZipBLOBURL -OutFile $CompleteFlexeraZipPath


Unzip $CompleteFlexeraZipPath $destintionPath

#variable declaration
$swName = "FlexNet Inventory Agent"
$path1="HKLM:\SOFTWARE\Wow6432Node\ManageSoft Corp\ManageSoft\Common\DownloadSettings"
$path2="HKLM:\SOFTWARE\Wow6432Node\ManageSoft Corp\ManageSoft\Common\UploadSettings"
$flag=$false
$logFile = "C:\MyTempFolder\VNET-External-BC-FlexeraSetupFiles\Log.log"
$dt = date

if (Test-Path -Path $logFile)
{
       $dt | out-file $logFile -Append  
}
else
{
       "Flexera Agent Installation Log" | out-file $logFile
       $dt | out-file $logFile -Append  
}

try
{
       #fetch list of installed softwares
       $installedSWs = Get-WmiObject -Class Win32_Product

       #check to see if the software is installed
       foreach ($installedSW in $installedSWs) 
       { 
             if ($installedSW.Name -eq $swName) 
             { 
                    $flag=$true
                    break 
             }      
       }

       #check to see is the required registry sub keys are present and take decision whether to install or skip
       $result = (Test-Path -Path $path1) -And (Test-Path -Path $path2) -And $flag
       if ($result)
       {
             "Flexera Agent already installed. Hence skipping!!!" | out-file $logFile -Append
       }
       else
       {
             "Installing Flexera Agent!!!" | out-file $logFile -Append
             $exitCode = (Start-Process -FilePath "C:\MyTempFolder\VNET-External-BC-FlexeraSetupFiles\Win32\setup.exe" -ArgumentList "/S" -NoNewWindow -PassThru -Wait).exitcode
             if ($exitCode -eq 0)
             {
                    "Flexera Agent Installed Successfully!!!" | out-file $logFile -Append
             }
             else
             {
                    "Flexera Agent Installation Failed with error code:" + $exitCode  | out-file $logFile -Append
             }
       }
}
catch
{
       $_.Exception.Message | out-file $logFile -Append
       "Error occurred while script execution" | out-file $logFile -Append
} 
