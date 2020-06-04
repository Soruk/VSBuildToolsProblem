[CmdletBinding()]
param(
	[parameter(HelpMessage = "The Configruation of the build")]
	[ValidateSet("Debug","Release")]
	[string]$Configuration = "Release",
	[parameter(HelpMessage = "The Version of the Msbuild")]
	[ValidateSet("2017","2019")]
	[string]$MSBuildVersion = "2019",
	[parameter(HelpMessage = "The Publish profile type")]
	[ValidateSet("Publish","Deploy")]
	[string]$PublishProfileType = "Publish"
)

$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Set-Location $scriptDir
$CurrentDir = $(get-location).Path;

Import-Module -force "$scriptDir\PSScripts\MSBuildFactory.psm1";

$logFileName =  "LogBuild.LibraryCPP.Tools"
$logPath = Join-Path $CurrentDir "$logFileName.txt"
New-Item $logPath -type file -force | Out-Null;

EchoBeginBuild("LibraryCPP TOOLS");
$ok = MSBuildFile -BuildFilePath "LibraryCPP.$($MSBuildVersion).vcxproj" -LogFileName $logFileName -EmptiesLogFile $false -MSBuildForcedVersion $MSBuildVersion -BuildMode "Restore,Build" -Configuration $Configuration -Platform "Win32"
if( $ok -eq $false){
    return EchoEndBuildKO("LibraryCPP TOOLS");
}

return EchoEndBuildOK("LibraryCPP TOOLS");